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
	-- The #tips == 0 guard above already rules this out at runtime; the type
	-- checker cannot relate that count to this index, so it sees `tip?` here.
	-- A plain guard is what it narrows on -- assert() also removes the nil,
	-- but at the cost of a different false positive below, since it expands
	-- as a multi-value return when it is a call's last argument.
	if not random_tip then
		return
	end

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

	-- Lines are in; lock the buffer so the tip can only be viewed, not edited.
	vim.bo.modifiable = false
	vim.bo.readonly = true
end

return M
