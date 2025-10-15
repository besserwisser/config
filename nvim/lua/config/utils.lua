-- Utility functions for neovim configuration

local M = {}

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

-- based on https://github.com/konradmalik/neovim-flake/blob/6dba374af89a294c976d72615cca6cfca583a9f2/config/native/lua/pde/lsp/completion.lua
local docs_debounce_ms = 100
local timer = vim.uv.new_timer()

---@param client vim.lsp.Client
---@param augroup integer
---@param bufnr integer
M.enable_completion_documentation = function(client, augroup, bufnr)
	if not timer then
		vim.notify("cannot create timer", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_create_autocmd("CompleteChanged", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			timer:stop()

			local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
			if not completion_item then
				vim.notify("no completion item", vim.log.levels.WARN)
				return
			end

			local complete_info = vim.fn.complete_info({ "selected" })
			if vim.tbl_isempty(complete_info) then
				vim.notify("no complete info", vim.log.levels.WARN)
				return
			end

			timer:start(
				docs_debounce_ms,
				0,
				vim.schedule_wrap(function()
					client:request(
						vim.lsp.protocol.Methods.completionItem_resolve,
						completion_item,
						function(err, result)
							if err ~= nil then
								vim.notify("client " .. client.id .. vim.inspect(err), vim.log.levels.ERROR)
								return
							end

							local docs = vim.tbl_get(result, "documentation", "value")
							if not docs then
								vim.notify("no documentation", vim.log.levels.INFO)
								return
							end

							local wininfo = vim.api.nvim__complete_set(complete_info.selected, { info = docs })
							-- sometimes wininfo is empty, e.g. when the completion menu is closed before the docs arrivej	jj
							if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
								vim.notify("no valid wininfo", vim.log.levels.WARN)
								return
							end

							vim.api.nvim_win_set_config(wininfo.winid, { border = "rounded" })
							vim.wo[wininfo.winid].conceallevel = 2
							vim.wo[wininfo.winid].concealcursor = "niv"

							if not vim.api.nvim_buf_is_valid(wininfo.bufnr) then
								return
							end

							vim.bo[wininfo.bufnr].syntax = "markdown"
							vim.treesitter.start(wininfo.bufnr, "markdown")
						end,
						bufnr
					)
				end)
			)
		end,
	})
end

return M
