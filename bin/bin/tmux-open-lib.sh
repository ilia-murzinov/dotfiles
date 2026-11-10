# tmux-open-lib.sh — sourced by tmux-open-in-vim / tmux-fzf-files
# Prefer macOS `open` for non-text paths (binaries, images, PDFs, dirs, …).

tmux_should_os_open() {
  local f="$1" mime enc
  [[ -e "$f" ]] || return 1
  [[ -d "$f" ]] && return 0

  mime=$(file -b --mime-type "$f" 2>/dev/null || true)
  case "$mime" in
    text/*|inode/x-empty|\
    application/json|application/xml|application/javascript|application/sql|\
    application/toml|application/yaml|application/x-yaml|application/x-sh|\
    application/x-shellscript|application/x-awk|application/xhtml+xml|\
    application/typescript|application/x-httpd-php|application/x-ruby|\
    application/x-python|application/x-perl)
      enc=$(file -b --mime-encoding "$f" 2>/dev/null || true)
      [[ "$enc" == "binary" ]] && return 0
      return 1
      ;;
    "")
      enc=$(file -b --mime-encoding "$f" 2>/dev/null || true)
      [[ "$enc" == "binary" ]] && return 0
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

tmux_os_open() {
  local f="$1"
  if command -v open >/dev/null 2>&1; then
    nohup open "$f" >/dev/null 2>&1 &
    tmux display-message "open: $(basename "$f")"
    return 0
  fi
  return 1
}
