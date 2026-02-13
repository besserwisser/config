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
local registered_bufs = {}

---@param bufnr integer
M.enable_completion_documentation = function(_, _, bufnr)
	if not timer then
		vim.notify("cannot create timer", vim.log.levels.ERROR)
		return
	end

	if registered_bufs[bufnr] then
		return
	end
	registered_bufs[bufnr] = true

	local augroup = vim.api.nvim_create_augroup("CompletionDocumentation" .. bufnr, { clear = true })

	vim.api.nvim_create_autocmd("CompleteChanged", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			timer:stop()

			local user_data = vim.tbl_get(vim.v.completed_item, "user_data")
			if type(user_data) == "string" and user_data ~= "" then
				user_data = vim.json.decode(user_data)
			end
			local completion_item = vim.tbl_get(user_data or {}, "nvim", "lsp", "completion_item")
			local client_id = vim.tbl_get(user_data or {}, "nvim", "lsp", "client_id")

			if not completion_item or not client_id then
				return
			end

			local client = vim.lsp.get_client_by_id(client_id)
			if not client then
				return
			end

			local resolve_provider = vim.tbl_get(client, "server_capabilities", "completionProvider", "resolveProvider")
			if not resolve_provider then
				return
			end

			local complete_info = vim.fn.complete_info({ "selected" })
			if vim.tbl_isempty(complete_info) then
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
								return
							end

							if not result then
								return
							end

							local description = vim.tbl_get(result, "labelDetails", "description") or ""
							local detail = result.detail or ""
							local docs = vim.tbl_get(result, "documentation", "value") or ""

							-- combine label description, detail (type signature), and documentation
							-- description shows where the item will be imported from, at least in tsserver
							-- detail shows the type/function signature
							local parts = {}
							if description ~= "" then
								table.insert(parts, "*" .. description .. "*")
							end
							if detail ~= "" then
								table.insert(parts, "```typescript\n" .. detail .. "\n```")
							end
							if docs ~= "" then
								table.insert(parts, docs)
							end

							if #parts == 0 then
								return
							end

							docs = table.concat(parts, "\n\n")

							local wininfo = vim.api.nvim__complete_set(complete_info.selected, { info = docs })
							if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
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
