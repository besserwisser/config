vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
})

local dap = require("dap")
local dapui = require("dapui")
local dap_widgets = require("dap.ui.widgets")
local dap_utils = require("dap.utils")

dapui.setup()

local function get_pkg_path(pkg, path)
	pcall(require, "mason")
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	path = path or ""
	local ret = root .. "/packages/" .. pkg .. "/" .. path
	return ret
end

dap.adapters["pwa-node"] = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
			"${port}",
		},
	},
}

local function pick_node_process()
	return dap_utils.pick_process({
		filter = function(p)
			return p.name:match("^node")
		end,
	})
end

dap.configurations["typescript"] = {
	{
		type = "pwa-node",
		request = "attach",
		port = 9229,
		name = "Attach",
		processId = pick_node_process,
		protocol = "inspector",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
	},
}

-- DAP event listerns to open and close ui automatically

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- Keymaps for DAP

vim.keymap.set("n", "<F5>", function()
	dap.continue()
end)
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end)
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end)
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint()
end)
vim.keymap.set("n", "<Leader>lp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	dap.repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
	dap.run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	dap_widgets.hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	dap_widgets.preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = dap_widgets
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = dap_widgets
	widgets.centered_float(widgets.scopes)
end)
