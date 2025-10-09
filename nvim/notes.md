# Neovim Cheatsheet

A personal collection of useful commands and concepts.

---

## Normal Mode

### Navigation

- Put your right index finger on `j` and the middle finger on `k` for easy navigation.
- `<C-f>` and `<C-b>` - **Page down** and **page up**.

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

---

## Visual Mode

- `gv` - **Reselect** the **previous visual selection**.
- `o` - Toggle the cursor between the **beginning and end** of the visual selection.
- **Text Objects** - Use text objects like `iw` (inside word) or `a"` (around quotes) to quickly change or expand your visual selection.
- `an` / `in` - Select **around** or **inside** a node in languages like XML or HTML.

---

## Insert Mode

- `<C-r>{register}` - **Paste** the content from a specified register. For example, `<C-r>"` pastes from the default register.
- `<C-x><C-s>` - **Signature Help**. When an LSP is active, this can show function parameter information. Note: `<C-s>` alone often freezes the terminal (XOFF).

---

## Command-Line Mode

- `C-f>` - Open the command-line window for easier editing of long commands. Press `<C-c>` to exit.

### Files & Buffers

- `:enew` - Create a **new, unnamed buffer** for scratch work.
- `:e!` - **Reload the file**, discarding all unsaved changes.
- `:b` - Switch between open **buffers**. Use `<Tab>` to complete buffer names.

### The `:global` Command

The `:global` command (`:g`) executes a command on all lines matching a pattern. Use `:vglobal` (`:v`) for all lines **not** matching.

- `:g/pattern/d` - **Delete** all lines containing "pattern".
- `:g/pattern/norm {cmd}` - Execute a **normal mode command** on each matching line.

---

## Registers & Macros

- `:reg` - **Show all registers** and their content.
- `"_` - The **black hole register**. Use it to delete text without affecting any other register (e.g., `"_dd`).
- `"0` - The **yank register**. Always contains the last text you yanked with `y`.
- `"1`-`"9` - The **delete registers**. A history of your last 9 multi-line deletions.
- `"-"` - The **small delete register**. Contains text from deletions of less than one line.
- `"/"` - The **search register**. Contains your last search pattern.
- `@a` - **Execute the macro** stored in register 'a'.
- `5@a` - **Execute macro 'a' five times**.

---

## Window Management

- `<C-w>H` - **Move the current split** to the far left, making it a vertical split. Works with `H` (left), `J` (bottom), `K` (top), and `L` (right).
- `:vert {cmd}` - **Execute a command** and open its result in a **vertical split**. For example, `:vert help marks`.

---

## Folding

- `za` - **Toggle** the fold at the current line.
- `zA` - **Recursively toggle** all folds under the cursor.
