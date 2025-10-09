# Neovim Cheatsheet

A personal collection of useful commands and concepts.

## Normal Mode

### Navigation

- Put your right index finger on `j` and the middle finger on `k` for easy navigation.
- `<C-f>` and `<C-b>` - **Page down** and **page up**.
- `<C-e>` and `<C-y>` - **Scroll down** and **scroll up** one line without moving the cursor.
- `H`, `M`, `L` - Move the cursor to the **top**, **middle**, or **bottom** of the screen.
- `zz` - **Center** the current line in the window. Also works with `zt` (top) and `zb` (bottom).
- `'m` and `m - Jump to beginning of mark line or exact position of mark.

### Editing

- `yy` - **Copy (yank)** the entire current line.
- `.` - **Repeat** the last change (e.g., a deletion, paste, or command).
- `cib` - **Change inside block** (parentheses). Deletes content inside `()` and enters insert mode.
- `cgn` - **Change** the **next search match**. Can be repeated with `.`.
- `<C-a>` - **Increment** the number under or after the cursor.
- `<C-x>` - **Decrement** the number under or after the cursor.
- `:windo diffthis` - **Show differences** between all open buffers in diff mode. Use `:windo diffoff` to exit diff mode.
- `D` - delete from the cursor to the end of the line (same as `d$`).
- `<C-[>` or `<C-c>` - Exit insert mode (similiar as `Esc`).
- `d/pattern<CR>`, `c/pattern<CR>`, `y/pattern<CR>` - **Delete**, **change**, or **yank** from the cursor to the next occurrence of "pattern".
- `<C-b>$` - Move to end of line for all lines in visual block mode. Can be combined with `A` to append text at the end of multiple lines for example.
- `J` - **Join** the current line with the next line, adding a space between them. Also works with a count (e.g., `3J` joins three lines). Also works in visual mode. Can also be used to make multi line arrays and objects in one line.

### Motions

- `e` / `E` - Jump to the **end** of the current word. `E` uses WORDs (delimited by whitespace).
- `w` / `W` - Jump forward to the start of the next **word**. `W` uses WORDs. Often time you can use it to jump between function names or variables or other identifiers.
- `f{char}` / `F{char}` - **Find** a character on the current line (forward/backward).
- `t{char}` / `T{char}` - Jump **'til** (just before) a character on the current line (forward/backward).
- `;` / `,` - **Repeat** the last `f`, `F`, `t`, or `T` motion forward (`;`) or backward (`,`).
- `L` - Move the cursor to the **lowest** line visible in the window.
- `[{` - Jump to the **previous unmatched `{` brace**. Can be combined with `v%` (e.g., `[{v%`) to select the entire block.
- `gn` / `gN` - **Select** the **next/previous search match** in visual mode.
- `'.` - Jump to the **exact position** of the last change.
- `f(w` - Jump to function arguments (inside parentheses).
- `]m` / `[m` - Jump to the start of the **next/previous method** in languages like C, Java, or Python.
- `]M` / `[M` - Jump to the end of the **next/previous method**.
- `as` / `is` - Select **around** or **inside** a sentence.

## Visual Mode

- `gv` - **Reselect** the **previous visual selection**.
- `o` - Toggle the cursor between the **beginning and end** of the visual selection.
- **Text Objects** - Use text objects like `iw` (inside word) or `a"` (around quotes) to quickly change or expand your visual selection.
- `an` / `in` - Select **around** or **inside** a node in languages like XML or HTML.
- `u` / `U` - **Lowercase** or **uppercase** the selected text.
- `:s/\n/, ` - Replace newlines with commas in a selected block.
- `:s/, /,\r` - Split a comma-separated list into multiple lines.

## Insert Mode

- `<C-r>{register}` - **Paste** the content from a specified register. For example, `<C-r>"` pastes from the default register.
- `<C-x><C-s>` - **Signature Help**. When an LSP is active, this can show function parameter information. Note: `<C-s>` alone often freezes the terminal (XOFF).

## Command-Line Mode

- `C-f>` - Open the command-line window for easier editing of long commands. Press `<C-c>` to exit.
- `/\v` - Start a search with **very magic** mode, where most characters are treated as special regex characters without needing to escape them.
- `/\c` - Start a search that is **case-insensitive** or `/\C` for **case-sensitive**.

### Files & Buffers

- `:enew` - Create a **new, unnamed buffer** for scratch work.
- `:view {file}` - Open a file in **read-only mode**.
- `:e!` - **Reload the file**, discarding all unsaved changes.
- `:e #` - Open alternate file (the last file you were editing).
- `:b` - Switch between open **buffers**. Use `<Tab>` to complete buffer names.
- `:r {file}` - Read file in
- `:r {cmd}` - Read the output of a shell command into the current buffer.
- `:x` - Saves, if there are changes, and exits (same as `:wq`). You can also use `ZZ` in normal mode for a similar effect.

### The `:global` Command

The `:global` command (`:g`) executes a command on all lines matching a pattern. Use `:vglobal` (`:v`) for all lines **not** matching.

- `:g/pattern/d` - **Delete** all lines containing "pattern".
- `:g/pattern/norm {cmd}` - Execute a **normal mode command** on each matching line.

## Registers & Macros

- `:reg` - **Show all registers** and their content.
- `"_` - The **black hole register**. Use it to delete text without affecting any other register (e.g., `"_dd`).
- `"0` - The **yank register**. Always contains the last text you yanked with `y`.
- `"1`-`"9` - The **delete registers**. A history of your last 9 multi-line deletions.
- `"-"` - The **small delete register**. Contains text from deletions of less than one line.
- `"/"` - The **search register**. Contains your last search pattern.
- `@a` - **Execute the macro** stored in register 'a'.
- `5@a` - **Execute macro 'a' five times**.

## Window Management

- `<C-w>H` - **Move the current split** to the far left, making it a vertical split. Works with `H` (left), `J` (bottom), `K` (top), and `L` (right).
- `:vert {cmd}` - **Execute a command** and open its result in a **vertical split**. For example, `:vert help marks`.

## Folding

- `za` - **Toggle** the fold at the current line.
- `zA` - **Recursively toggle** all folds under the cursor.
