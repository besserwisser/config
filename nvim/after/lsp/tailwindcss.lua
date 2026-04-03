-- Overrides for nvim-lspconfig's tailwindcss config:
-- 1. Fix blocking full-tree CSS scan (use git ls-files instead of vim.fs.find with limit=math.huge)
--    See https://github.com/neovim/nvim-lspconfig/issues/4373
-- 2. Support both single and double quote @import patterns (upstream only matches single quotes)
--    See https://github.com/neovim/nvim-lspconfig/issues/4371
-- TODO: remove once both issues are fixed upstream.

local function find_tailwind_global_css()
	-- Matches both `@import 'tailwindcss'` and `@import "tailwindcss"`
	local target = [[%@import ['"]tailwindcss['"]%;]]
	local buf = vim.api.nvim_get_current_buf()
	local root = vim.fs.root(buf, function(name)
		return name == ".git"
	end)

	if not root then
		return nil
	end

	-- Use git ls-files to respect .gitignore and avoid scanning node_modules or
	-- other large untracked directories.
	local result = vim.fn.systemlist(
		"git -C "
			.. vim.fn.shellescape(root)
			.. " ls-files --cached --others --exclude-standard -- '*.css' '*.scss' '*.pcss'"
	)
	if vim.v.shell_error ~= 0 then
		return nil
	end

	for _, relpath in ipairs(result) do
		local path = root .. "/" .. relpath
		local ok, content = pcall(vim.fn.readblob, path)
		if ok and content:find(target, 1, true) then
			return path
		end
	end

	return nil
end

return {
	before_init = function(_, config)
		if not config.settings then
			config.settings = {}
		end
		if not config.settings.editor then
			config.settings.editor = {}
		end
		if not config.settings.editor.tabSize then
			config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
		end
		config.settings.tailwindCSS = config.settings.tailwindCSS or {}
		config.settings.tailwindCSS.experimental = config.settings.tailwindCSS.experimental or {}
		config.settings.tailwindCSS.experimental.configFile = config.settings.tailwindCSS.experimental.configFile
			or find_tailwind_global_css()
	end,
}
