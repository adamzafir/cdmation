#!/usr/bin/env zsh

set -eu

REPO_DIR="${0:A:h}"
CLI_SRC="$REPO_DIR/cdmation"
HOOK_SRC="$REPO_DIR/cdmation-hook.zsh"
BIN_DIR="$HOME/.local/bin"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
HOOK_LINE="source \"$HOOK_SRC\""

append_line_with_spacing() {
  local line="$1"

  if [[ -s "$ZSHRC" ]]; then
    local last_char
    last_char="$(tail -c 1 "$ZSHRC" 2>/dev/null || true)"
    [[ "$last_char" == $'\n' ]] || printf '\n' >> "$ZSHRC"
    printf '\n%s\n' "$line" >> "$ZSHRC"
  else
    printf '%s\n' "$line" >> "$ZSHRC"
  fi
}

if [[ ! -f "$CLI_SRC" || ! -f "$HOOK_SRC" ]]; then
  print -u2 -- "install: run this from inside the cdmation repo"
  exit 1
fi

mkdir -p "$BIN_DIR"
chmod +x "$CLI_SRC"
ln -sf "$CLI_SRC" "$BIN_DIR/cdmation"

touch "$ZSHRC"

if ! grep -Fqx "$PATH_LINE" "$ZSHRC"; then
  append_line_with_spacing "$PATH_LINE"
fi

if ! grep -Fqx "$HOOK_LINE" "$ZSHRC"; then
  append_line_with_spacing "$HOOK_LINE"
fi

print -- "cdmation installed."
print -- "- command: $BIN_DIR/cdmation"
print -- "- zshrc updated: $ZSHRC"
print -- "Reload shell with: source $ZSHRC"
