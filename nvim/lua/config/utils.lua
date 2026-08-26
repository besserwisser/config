-- Utility functions for neovim configuration

local M = {}

local IMAGE_EXT = {
	avif = true,
	bmp = true,
	gif = true,
	heic = true,
	ico = true,
	jpeg = true,
	jpg = true,
	png = true,
	svg = true,
	tif = true,
	tiff = true,
	webp = true,
}

-- Not an image, but mcat rasterises it to one (via chromium), so it goes down
-- the same path. Note this only works through mcat's image output: asking mcat
-- for a *text* rendering of a pdf just dumps the raw bytes.
local DOC_EXT = { pdf = true }

--- Should an external renderer take over this file?
---
--- Only for things Neovim genuinely cannot show: pictures, and documents that
--- have to be rasterised. Everything else -- code, config, markdown, plain text
--- -- keeps Neovim's own preview, which has treesitter highlighting and can
--- jump to a line, and is simply better at it.
---@param path string
---@return boolean
function M.preview_handles(path)
	local ext = path:lower():match("%.([^.]+)$") or ""
	return IMAGE_EXT[ext] == true or DOC_EXT[ext] == true
end

-- Pixel-perfect image previews ----------------------------------------------
--
-- Drawing into a preview buffer cannot work: a terminal buffer is a nested
-- libvterm PTY, so graphics escape sequences written into it never reach the
-- outer terminal and render as nothing. That is what forced block-character art
-- before, and block art always looks blocky.
--
-- The way around it is the one snacks.image uses for kitty terminals: don't put
-- the image in a buffer at all. Write it straight to the host TTY with
-- nvim_ui_send() and position it over the preview window.
--
-- Unlike kitty, iTerm2 has no unicode-placeholder mechanism anchoring an image
-- to text cells, so the image is ordinary terminal content and survives only
-- until Neovim repaints those cells. Hence: keep the preview buffer empty (so
-- there is nothing to repaint over it) and blit again after anything that moves
-- or resizes the window. `:redraw!` wipes it, which is also how we clear it.

--- Pixel size of one terminal cell, needed to work out how many cells an image
--- will actually occupy once iTerm2 has scaled it. Falls back to a typical 1:2
--- cell when the terminal doesn't report its pixel size.
---@return {w: number, h: number}
local cell_size_cache
local function cell_size()
	if cell_size_cache then
		return cell_size_cache
	end
	local ok, size = pcall(function()
		local ffi = require("ffi")
		pcall(ffi.cdef, [[
			typedef struct { unsigned short row, col, xpixel, ypixel; } nvim_winsize_t;
			int ioctl(int, unsigned long, ...);
		]])
		local ws = ffi.new("nvim_winsize_t")
		local TIOCGWINSZ = vim.fn.has("linux") == 1 and 0x5413 or 0x40087468
		if ffi.C.ioctl(1, TIOCGWINSZ, ws) ~= 0 or ws.col == 0 or ws.row == 0 or ws.xpixel == 0 then
			return nil
		end
		return { w = ws.xpixel / ws.col, h = ws.ypixel / ws.row }
	end)
	cell_size_cache = (ok and size) or { w = 1, h = 2 }
	return cell_size_cache
end

--- Pixel dimensions from a PNG's IHDR header (mcat always emits PNG).
---@param b64 string base64-encoded PNG
---@return integer? width, integer? height
local function png_size(b64)
	-- 32 base64 chars decode to exactly the 24 bytes covering signature + IHDR
	local ok, head = pcall(vim.base64.decode, b64:sub(1, 32))
	if not ok or #head < 24 or head:sub(2, 4) ~= "PNG" then
		return nil, nil
	end
	local a, b, c, d, e, f, g, h = head:byte(17, 24)
	return a * 2 ^ 24 + b * 2 ^ 16 + c * 2 ^ 8 + d, e * 2 ^ 24 + f * 2 ^ 16 + g * 2 ^ 8 + h
end

--- How many cells the image occupies inside a `cols` x `rows` box, and the
--- offset that centres it there. iTerm2 anchors a `preserveAspectRatio` image
--- at the top-left of the box it is given, so to centre it we shrink the box to
--- the image's own footprint and move the paint origin instead.
---@return integer cols, integer rows, integer dcol, integer drow
local function fit_centered(img_w, img_h, cols, rows)
	local cell = cell_size()
	local scale = math.min(cols * cell.w / img_w, rows * cell.h / img_h)
	local w = math.max(1, math.min(cols, math.ceil(img_w * scale / cell.w)))
	local h = math.max(1, math.min(rows, math.ceil(img_h * scale / cell.h)))
	return w, h, math.floor((cols - w) / 2), math.floor((rows - h) / 2)
end

-- `path` is claimed as soon as rendering starts, before the image data exists,
-- so that a repeated request for the same file is recognised as a duplicate
-- rather than kicking off a second render. Oil, for one, opens a preview twice
-- per move: once explicitly and once from its own CursorMoved handler.
local overlay = { seq = nil, win = nil, path = nil, dcol = 0, drow = 0 }
local overlay_group = vim.api.nvim_create_augroup("PreviewImageOverlay", { clear = true })

local function overlay_draw()
	local win = overlay.win
	if not overlay.seq or not win or not vim.api.nvim_win_is_valid(win) then
		return
	end
	-- win_screenpos() reports `config.row + 1`, which for a bordered float is the
	-- border cell, not the content area -- that would draw the image a cell too
	-- far up and left, over the border. Derive the content area from the first
	-- buffer cell instead and subtract the gutter (number/sign/fold columns).
	local sp = vim.fn.screenpos(win, 1, 1)
	if sp.row == 0 then
		return -- window is not currently on screen
	end
	local col = sp.col - vim.fn.getwininfo(win)[1].textoff
	-- Painting means parking the terminal cursor in the preview area, where
	-- iTerm2 would draw it as a second cursor block next to Neovim's own. Hide
	-- it for the duration: hide -> save -> jump to the paint origin -> blit ->
	-- restore position -> show.
	vim.api.nvim_ui_send(
		("\27[?25l\27[s\27[%d;%dH"):format(sp.row + overlay.drow, col + overlay.dcol)
			.. overlay.seq
			.. "\27[u\27[?25h"
	)
end

--- Wipe the image currently drawn over the screen, if any, and drop a pending
--- render so its result can no longer land on screen.
function M.clear_image_overlay()
	local was_drawn = overlay.seq ~= nil
	if not was_drawn and not overlay.path then
		return
	end
	overlay.seq, overlay.win, overlay.path = nil, nil, nil
	overlay.dcol, overlay.drow = 0, 0
	vim.api.nvim_clear_autocmds({ group = overlay_group })
	if was_drawn then
		vim.cmd("redraw!") -- repaint every cell, wiping the image
	end
end

---@param path string
---@param win integer
local function draw_image_overlay(path, win)
	overlay.path, overlay.win = path, win -- claim it now, see the note above
	local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
	-- mcat decodes and downscales (webp, heic, svg, ... all supported) and emits
	-- an iTerm2 inline-image sequence. It only sets `size=`, which would leave
	-- the on-screen scaling to iTerm2's guess at our cell size, so unwrap the
	-- payload and re-wrap it with an explicit size in cells.
	local cmd = {
		"mcat", "-i", "--iterm", "--silent", "--no-center",
		"--img-width", width .. "c",
		"--img-height", height .. "c",
		path,
	}
	vim.system(cmd, { text = false }, function(res)
		local b64 = res.code == 0 and (res.stdout or ""):match("size=%d+:(.*)\7$") or nil
		if not b64 then
			return
		end
		vim.schedule(function()
			-- a newer preview may have superseded this one while mcat was running
			if overlay.path ~= path or not vim.api.nvim_win_is_valid(win) then
				return
			end
			-- Hand iTerm2 the image's own footprint rather than the whole pane, and
			-- shift the paint origin, so it ends up centred instead of top-left.
			local img_w, img_h = png_size(b64)
			local w, h, dcol, drow = width, height, 0, 0
			if img_w and img_h and img_w > 0 and img_h > 0 then
				w, h, dcol, drow = fit_centered(img_w, img_h, width, height)
			end
			overlay.dcol, overlay.drow = dcol, drow
			overlay.seq = ("\27]1337;File=inline=1;width=%d;height=%d;preserveAspectRatio=1;size=%d:%s\7")
				:format(w, h, #b64, b64)
			overlay_draw()
			vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinScrolled", "WinClosed" }, {
				group = overlay_group,
				callback = function(ev)
					if ev.event == "WinClosed" and tonumber(ev.match) == win then
						M.clear_image_overlay()
					else
						vim.schedule(overlay_draw)
					end
				end,
			})
		end)
	end)
end

--- Draw a preview for a file that `preview_handles()` claimed, over `win`.
---
--- The window's buffer is deliberately left empty -- the image is painted on
--- top of it, not into it.
---
---@param path string file to preview
---@param win integer window to draw over
---@return boolean handled false if the caller should fall back to its own preview
function M.preview_file(path, win)
	if overlay.path == path and overlay.win == win then
		-- Already rendering or showing exactly this, so don't run mcat again --
		-- but the caller just reset the canvas under us, so paint it again. A
		-- render still in flight has nothing to paint yet and this is a no-op.
		overlay_draw()
		return true
	end
	M.clear_image_overlay()

	-- Without the iTerm2 protocol there is nothing better on offer than Neovim's
	-- own preview, so say so and let the caller handle it.
	if vim.env.TERM_PROGRAM ~= "iTerm.app" or not vim.api.nvim_ui_send then
		return false
	end

	draw_image_overlay(path, win)
	return true
end

M.search_count = function()
	if vim.v.hlsearch == 1 then
		local ok, searchcount = pcall(vim.fn.searchcount)

		if ok and searchcount["total"] and searchcount["total"] > 0 then
			return " [" .. searchcount["current"] .. "∕" .. searchcount["total"] .. "]"
		end
	end

	return ""
end

M.recording_status = function()
	local reg = vim.fn.reg_recording()
	if reg ~= "" then
		return " @" .. reg
	end
	return ""
end

M.show_tip = function()
	-- Condition: Only run if no file arguments were passed and the current buffer is empty
	if vim.fn.argc() > 0 or vim.fn.bufname("%") ~= "" then
		return
	end

	-- Read notes.md file
	local notes_path = vim.fn.stdpath("config") .. "/notes.md"
	local file = io.open(notes_path, "r")
	if not file then
		return
	end

	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	-- Parse tips with their context
	local tips = {}
	local current_h2 = ""

	for _, line in ipairs(lines) do
		if line:match("^## ") then
			current_h2 = line
		elseif line:match("^- ") then
			local tip = {}
			if current_h2 ~= "" then
				table.insert(tip, current_h2)
			end
			table.insert(tip, "") -- Empty line for separation
			table.insert(tip, line)
			table.insert(tips, tip)
		end
	end

	if #tips == 0 then
		return
	end

	-- Choose a random tip
	math.randomseed(os.time())
	local random_tip = tips[math.random(#tips)]

	--  Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true) -- `false` for not listed, `true` for scratch

	-- Save current position to avoid adding to jump list
	vim.api.nvim_set_current_buf(buf)

	--  Set options for the dashboard buffer to make it feel special
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe" -- Wipe buffer when hidden to avoid jump list issues
	vim.bo.filetype = "markdown" -- Custom filetype for potential syntax/statusline rules

	-- Clear jump list entry for this buffer
	vim.cmd("clearjumps")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, random_tip)
end

return M
