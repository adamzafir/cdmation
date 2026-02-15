#!/usr/bin/env zsh

set -eu

REPO_DIR="${0:A:h}"
CLI_SRC="$REPO_DIR/cdmation"
HOOK_SRC="$REPO_DIR/cdmation-hook.zsh"
BIN_DIR="$HOME/.local/bin"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
HOOK_LINE="source \"$HOOK_SRC\""

if [[ ! -f "$CLI_SRC" || ! -f "$HOOK_SRC" ]]; then
  print -u2 -- "install: run this from inside the cdmation repo"
  exit 1
fi

mkdir -p "$BIN_DIR"
chmod +x "$CLI_SRC"
ln -sf "$CLI_SRC" "$BIN_DIR/cdmation"

touch "$ZSHRC"

if ! grep -Fqx "$PATH_LINE" "$ZSHRC"; then
  print -- "$PATH_LINE" >> "$ZSHRC"
fi

if ! grep -Fqx "$HOOK_LINE" "$ZSHRC"; then
  print -- "$HOOK_LINE" >> "$ZSHRC"
fi

print -- "cdmation installed."
print -- "- command: $BIN_DIR/cdmation"
print -- "- zshrc updated: $ZSHRC"
print -- "Reload shell with: source $ZSHRC"
