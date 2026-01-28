-- Set the make program explicitly
-- We use 'npx' to use the project's local typescript version
vim.opt_local.makeprg = "npx tsc --noEmit"

-- Set the error format manually
-- Since we couldn't load a compiler plugin, we must tell Neovim
-- how to read the output of tsc.
-- Pattern: filename(line,col): message
vim.opt_local.errorformat = "%f(%l\\,%c): %m"
