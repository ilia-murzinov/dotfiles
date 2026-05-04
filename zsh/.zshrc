# --- PATH (early) ---
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

# --- Completion (Homebrew site-functions + zsh built-ins; no framework) ---
typeset -U fpath FPATH
if (( $+commands[brew] )); then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# --- History ---
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
[[ -d $HISTFILE:h ]] || mkdir -p "$HISTFILE:h"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# --- Shell behavior ---
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
WORDCHARS=${WORDCHARS/\/}

# --- Editor ---
if (( $+commands[nvim] )); then
  export EDITOR=nvim
  export VISUAL=nvim
fi

# --- SDKMAN, local overrides ---
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# --- zoxide (replaces cd) ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# --- fzf ---
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# --- yazi (cwd follows on quit: y + q; Q quits without cd) ---
if (( $+commands[yazi] )); then
  y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [[ "$cwd" != "$PWD" && -d "$cwd" ]] && builtin cd -- "$cwd"
    command rm -f -- "$tmp"
  }
fi

# --- Vi line editing (Homebrew zsh-vi-mode, else plain vim mode) ---
function zvm_config() {
  ZVM_INIT_MODE=sourcing
  ZVM_LAZY_KEYBINDINGS=false
  ZVM_KEYTIMEOUT=0.25
}

_zvm_file=
if (( $+commands[brew] )); then
  _zb="$(brew --prefix zsh-vi-mode 2>/dev/null)"
  [[ -n $_zb && -f $_zb/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] \
    && _zvm_file=$_zb/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi
if [[ -n $_zvm_file ]]; then
  source "$_zvm_file"
else
  bindkey -v
  KEYTIMEOUT=25
fi
unset _zb _zvm_file

alias nv='nvim'
alias vn='nvim'
alias vm='nvim'
alias vim='nvim'

# --- Prompt (Starship if installed, else plain zsh + git branch) ---
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info add-zsh-hook
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' unstagedstr '*'
  zstyle ':vcs_info:git:*' stagedstr '+'
  zstyle ':vcs_info:git:*' formats '(%b%m%u%c)'
  zstyle ':vcs_info:git:*' actionformats '(%b|%a%m%u%c)'
  _dotfiles_vcs_precmd() { vcs_info }
  add-zsh-hook precmd _dotfiles_vcs_precmd
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%2~%f %F{magenta}${vcs_info_msg_0_}%f%# '
fi

# --- Autosuggestions & syntax highlighting (highlighting must load last) ---
_brewp=
(( $+commands[brew] )) && _brewp="$(brew --prefix 2>/dev/null)"
[[ -n $_brewp && -r "$_brewp/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$_brewp/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -n $_brewp && -r "$_brewp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$_brewp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brewp

# Ctrl+P: projects / obsidian / dotfiles (depth 1); bind after highlighting
_proj_cd() {
  local selected
  selected=$({ find ~/projects ~/obsidian -mindepth 1 -maxdepth 1 -type d; echo ~/dotfiles; } 2>/dev/null | fzf)
  if [[ -n $selected ]]; then
    cd "$selected" || return
    zle reset-prompt
  fi
}
zle -N _proj_cd
if (( $+functions[zvm_bindkey] )); then
  zvm_bindkey viins '^p' _proj_cd
else
  bindkey -M viins '^p' _proj_cd
fi

# Attach to first unattached tmux session
if [[ -z "$TMUX" ]]; then
  orphan=$(tmux list-sessions -F '#{?session_attached,,#{session_name}}' 2>/dev/null | head -1)
  [[ -n "$orphan" ]] && exec tmux attach -t "$orphan" -d
fi
