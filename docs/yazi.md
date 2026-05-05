# Yazi

Installed with `make install`: Homebrew `yazi`, `fd`, `ripgrep`; Catppuccin Mocha flavor copied under `~/.config/yazi/flavors/`; config Stow’d from `yazi/.config/yazi/` in this repo.

## From zsh

| Command | Action |
|---------|--------|
| `y` | Opens Yazi via the `y()` wrapper in **zsh**: quit with **`q`** to **`cd`** to the hovered folder; **`Q`** quits without changing the shell cwd |
| `yazi` | Same binary as-is — no cwd handoff |

## “Normal mode” on the file list (`mgr`)

Browsing with **`hjkl`** *is* Yazi’s default interaction — there is no separate Vim insert/normal toggle on the **manager**. **`Esc`** clears visual selection / search / filter **when Yazi has returned focus to the manager** (see below).

File-oriented **`y`** (yank paths for copy/move):

| Keys | Action |
|------|--------|
| **`y`** | **`yank`** — copy hovered / selected entries (then **`p`** paste, **`x`** cut, **`Y`** unyank) |
| **`v`** / **`V`** | Visual selection mode; **`y`** yanks that selection |
| **`Space`** | Toggle selection |

Copy bits of path without yanking files (`c` prefix):

| Keys | Action |
|------|--------|
| **`c`** **`c`** | Copy full path |
| **`c`** **`d`** | Copy directory |
| **`c`** **`f`** | Copy filename |
| **`c`** **`n`** | Copy name without extension |

Full defaults live in Yazi’s preset [`keymap-default.toml`](https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml); override with **`~/.config/yazi/keymap.toml`** (`[mgr].prepend_keymap` / …).

## Why **`y`** seems broken

Yazi switches **keymaps per UI layer**. When a **filter**, **find**, **`cd`/`rename` shell bar**, **`:` shell**, etc. has focus, you are usually on the **`[input]`** map — **`y`** there means **copy selected text in that box**, not **yank files**.

**Fix:** press **`Esc`** until you’re back to plain listing (header/footer prompts gone), then **`y`** applies to files again.

On the **`[input]`** layer Yazi still behaves Vim-ish: **`Esc`** backs out / cancel; **`v`** visual-select inside the field; **`y`** **yanks that selection** (see preset **`[input]`** section).

## Help

In-app **`~`** or **`F1`**, plus [quick start keybindings](https://yazi-rs.github.io/docs/quick-start#keybindings).
