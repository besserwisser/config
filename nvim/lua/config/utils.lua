-- Utility functions for neovim configuration

local M = {}

M.search_count = function()
	if vim.v.hlsearch == 1 then
		local ok, searchcount = pcall(vim.fn.searchcount)

		if ok and searchcount["total"] > 0 then
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
	local current_h1 = ""
	local current_h2 = ""
	local current_h3 = ""

	for _, line in ipairs(lines) do
		if line:match("^# ") then
			current_h1 = line
			current_h2 = ""
			current_h3 = ""
		elseif line:match("^## ") then
			current_h2 = line
			current_h3 = ""
		elseif line:match("^### ") then
			current_h3 = line
		elseif line:match("^- ") then
			local context = {}
			if current_h1 ~= "" then
				table.insert(context, current_h1)
			end
			if current_h2 ~= "" then
				table.insert(context, current_h2)
			end
			if current_h3 ~= "" then
				table.insert(context, current_h3)
			end
			table.insert(context, "") -- Empty line for separation
			table.insert(context, line)
			table.insert(tips, context)
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
