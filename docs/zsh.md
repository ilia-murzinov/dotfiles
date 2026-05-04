# Zsh

Standalone zsh (no Oh My Zsh): completion via `compinit`, Homebrew `site-functions`, optional `zsh-autosuggestions` + `zsh-syntax-highlighting` from `make install` / `brew install`.

Prompt: [Starship](https://starship.rs/) in `starship/.config/starship.toml` (Stow’d by `make install`): directory, `git_branch`, `git_state` (merge/rebase/…), `git_status` (staged/modified/untracked/stash + ahead/behind). Without `starship`, `.zshrc` falls back to directory + `vcs_info` (branch + staged/unstaged markers).

## Project switching

| Keys | Action |
|------|--------|
| `Ctrl+P` | fzf over `~/projects`, `~/obsidian`, `~/dotfiles` → cd there |

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

| Command | Action |
|---------|--------|
| `y` | Yazi; **q** = quit and `cd` to hovered dir, **Q** = quit without changing dir |

## Aliases

| Alias | Expands to |
|-------|-----------|
| `cd` | `z` |
| `nv` / `vn` / `vm` / `vim` | `nvim` |
