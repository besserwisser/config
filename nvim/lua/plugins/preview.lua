vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

local function notify_done(msg)
	vim.schedule(function()
		vim.notify(msg, vim.log.levels.INFO)
	end)
end

local function install_and_build(path)
	vim.system({ "npm", "--yes", "install" }, { cwd = path }, function()
		notify_done("markdown-preview npm install done")
		vim.system({ "npm", "--yes", "run", "build" }, { cwd = path }, function()
			notify_done("markdown-preview npm run build done")
		end)
	end)
end

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("MarkdownPreviewUpdated", { clear = true }),
	callback = function(args)
		local data = args.data
		if data.spec and data.spec.name == "markdown-preview.nvim" and data.kind == "update" then
			install_and_build(data.path)
		end
	end,
})
