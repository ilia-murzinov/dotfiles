# Zsh

Standalone zsh (no Oh My Zsh): completion via `compinit`, Homebrew `site-functions`, optional `zsh-autosuggestions` + `zsh-syntax-highlighting` from `make install` / `brew install`.

Prompt: [Starship](https://starship.rs/) in `starship/.config/starship.toml` (Stow’d by `make install`): directory, `git_branch`, `git_state` (merge/rebase/…), `git_status` (staged/modified/untracked/stash + ahead/behind). Without `starship`, `.zshrc` falls back to directory + `vcs_info` (branch + staged/unstaged markers).

## Vi mode (`zsh-vi-mode`)

| Keys | Action |
|------|--------|
| `Esc` / `Ctrl+[` | Normal mode (vicmd) on the command line |
| `i` `a` `I` `A` | Back to insert |
| **`yy`** | Yank whole line (into kill ring + macOS clipboard if `pbcopy` exists) |
| **`yw`**, **`ye`**, … | Yank motion (same as Vim operator-pending `y` + motion) |
| **`v` / `V`** then **`y`** | Visual selection → yank |
| **`p` / `P`** | Put after / before |

**Note:** A bare **`y`** enters operator-pending mode (like Vim); finish with **`y`** again (**`yy`**) or a motion (**`yw`**). Use **`gp` / `gP`** if you rely on clipboard paste per [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode).

fzf bindings (**`Ctrl+T`**, **`Ctrl+R`**, **`Esc`-`c`** / Alt+C) are sourced **after** `zsh-vi-mode` so they work in **normal mode** too.

## Shortcuts

| Keys | Action |
|------|--------|
| **`Ctrl+Y`** | Open **`y`** (Yazi cwd picker): **`q`** quits and **`cd`**s to hovered dir, **`Q`** quits without **`cd`** |
| **`Ctrl+P`** | fzf over `~/projects`, `~/obsidian`, `~/dotfiles` → **`cd`** (insert + normal mode) |

## fzf

| Keys | Action |
|------|--------|
| `Ctrl+T` | Fuzzy file finder in current dir |
| `Ctrl+R` | Fuzzy history search |
| `Alt+C` | Fuzzy cd |

## zoxide

| Command | Action |
|---------|--------|
| `z <partial>` | Jump to most frequent matching dir |
| `zi` | Interactive dir picker (fzf) |
| `cd` | Aliased to `z` |

## Yazi

| Keys / command | Action |
|----------------|--------|
| **`Ctrl+Y`** | Same as **`y` + Enter** (when `yazi` is installed) |
| **`y`** | Yazi cwd picker — **`q`** = quit and **`cd`**, **`Q`** = quit without changing dir |

## Aliases

| Alias | Expands to |
|-------|-----------|
| `cd` | `z` |
| `nv` / `vn` / `vm` / `vim` | `nvim` |
