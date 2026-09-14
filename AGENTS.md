# AGENTS.md

This repository is `~/.config`: configuration for many unrelated tools, each in
its own directory. Only `nvim/` has rules beyond "do not break it".

## Neovim config (`nvim/`)

The Lua here is checked by EmmyLua (the analyzer behind both `emmylua_ls`, the
editor's language server, and `emmylua_check`, its standalone CLI linter --
same project, same diagnostics). These are the closest thing this config has to
a test suite.

### Check EmmyLua diagnostics after changing Lua

Install `emmylua_check` once (it comes bundled with the `emmylua_ls` Homebrew
formula, alongside the language server itself):

```zsh
brew install emmylua_ls
```

Then, before reporting Lua work as done:

```zsh
cd nvim
VIMRUNTIME=$(nvim --headless -c 'lua io.write(vim.env.VIMRUNTIME)' -c 'qa' 2>/dev/null) emmylua_check .
```

`VIMRUNTIME` has to be exported explicitly: it exists only inside a running
Nvim process (`vim.env.VIMRUNTIME`), never as an ambient shell variable, and
without it `emmylua_check` cannot see Nvim's own Lua API stubs -- expect
hundreds of `unresolved-require`/`undefined-field` diagnostics if you skip it,
cascading from every plugin `require()` failing to resolve. `.emmyrc.json` in
this directory carries the rest of the setup (LuaJIT runtime, the `vim`
global, and the `vim.pack` plugin directory as a library path) and mirrors
`lua/config/lsp.lua`'s `workspace.library`, which configures the same analyzer
for the editor. If a plugin fails to resolve that the editor resolves fine (or
the reverse), the two have drifted apart -- update both.

A previous version of this file had you drive `emmylua_ls` headlessly from
Lua instead, because `emmylua_check` had not been noticed yet. Don't do that:
it needs the language server protocol's connection handshake and a
polling loop to wait for diagnostics to stabilize, which is slower, harder to
get right (a first attempt silently missed a real diagnostic, having read a
buffer's diagnostics before the workspace had finished revising them), and
duplicates what `emmylua_check` already does correctly in about two seconds.

### Fixing diagnostics

Fix the cause, not the symptom. Prefer making the code actually type-correct, or
making an invariant explicit (an `assert` where a guard already rules out `nil`),
over silencing a rule with `---@diagnostic disable`.

A whole class of these has one shared cause worth knowing: `unresolved-require`
on a plugin module cascades into `undefined-field` on every use of it. That is
almost never a code problem — it means the plugin directory is missing from
`workspace.library` in `lua/config/lsp.lua`. Fix it there once.

### Pre-existing diagnostics

As of 2026-09-14 the config reports **32** diagnostics, none of them in
`init.lua`, `lua/config/lsp.lua`, `lua/config/utils.lua`, or
`lua/plugins/fuzzy-find.lua`:

| File | Count |
| --- | --- |
| `lua/plugins/colorscheme.lua` | 19 |
| `lua/plugins/keymap-helper.lua` | 4 |
| `lua/config/completion.lua` | 4 |
| `lua/plugins/syntax-parser.lua` | 2 |
| `lua/plugins/binaries.lua` | 1 |
| `lua/plugins/debugging.lua` | 1 |
| `lua/plugins/formatting.lua` | 1 |

These are the baseline, not a regression you caused. Do not "fix" them as a side
errand. Do fix them when you are editing that file anyway, and leave the number
above lower than you found it.

### Formatting

`stylua` is also a Mason binary. Format the files you touched, and only those:

```zsh
~/.local/share/nvim/mason/bin/stylua <files...>
```

Do not run it across `nvim/lua` wholesale. `lua/plugins/syntax-parser.lua` does
not currently match stylua's output, so a blanket run reformats it and buries
your change in unrelated churn.

Tabs for indentation, matching the existing files. Where stylua's output hurts
readability -- a long string list exploded to one item per line -- prefer
`-- stylua: ignore` on the statement above it, as `lua/plugins/fuzzy-find.lua`
already does for the keymap block.
