vim.pack.add({
	{
		src = "https://github.com/iamcco/markdown-preview.nvim",
		-- version = "v0.0.10"
	},
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("MarkdownPreviewUpdated", { clear = true }),
	callback = function(args)
		local data = args.data

		if data.spec and data.spec.name == "markdown-preview.nvim" and data.kind == "update" then
			vim.system({ "npm", "--yes", "install" }, { cwd = data.path }, function()
				vim.schedule(function()
					vim.notify("markdown-preview npm install done", vim.log.levels.INFO)
				end)
				vim.system({ "npm", "--yes", "run", "build" }, { cwd = data.path }, function()
					vim.schedule(function()
						vim.notify("markdown-preview npm run build done", vim.log.levels.INFO)
					end)
				end)
			end)
		end
	end,
})
