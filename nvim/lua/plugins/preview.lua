local function notify_done(msg)
	vim.schedule(function()
		vim.notify(msg, vim.log.levels.INFO)
	end)
end

local function install_and_build(path)
	vim.notify("Installing and building markdown-preview.nvim...")
	vim.system({ "yarn", "install" }, { cwd = path }, function()
		notify_done("markdown-preview yarn install done")
		vim.system({ "yarn", "run", "build" }, { cwd = path }, function()
			notify_done("markdown-preview yarn run build done")
		end)
	end)
end

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("MarkdownPreviewUpdated", { clear = true }),
	callback = function(args)
		local data = args.data
		if data.spec and data.spec.name == "markdown-preview.nvim" then
			if data.kind == "update" or data.kind == "install" then
				install_and_build(data.path)
			end
		end
	end,
})

-- Need to set it up here to ensure the autocmd is created before the plugin is installed/updated
vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })
