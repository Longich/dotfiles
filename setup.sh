#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_LOCAL="$HOME/.zshrc.local"

info()    { echo "[INFO]  $*"; }
success() { echo "[OK]    $*"; }
skip()    { echo "[SKIP]  $*"; }

# --- シンボリックリンク作成 ---
link_file() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      skip "$dst already linked"
      return
    else
      info "Relinking $dst"
      ln -sf "$src" "$dst"
    fi
  elif [[ -f "$dst" ]]; then
    info "Backing up existing $dst -> ${dst}.backup"
    mv "$dst" "${dst}.backup"
    ln -s "$src" "$dst"
  else
    ln -s "$src" "$dst"
  fi

  success "Linked $dst -> $src"
}

# --- .zshrc.local 作成 ---
create_zshrc_local() {
  if [[ -f "$ZSHRC_LOCAL" ]]; then
    skip "$ZSHRC_LOCAL already exists"
    return
  fi

  cat > "$ZSHRC_LOCAL" << 'EOF'
# Machine-specific settings (not tracked by git)

# export PATH="$PATH:/your/local/path"
# export SOME_API_KEY="..."
EOF

  success "Created $ZSHRC_LOCAL"
}

# --- メイン ---
info "Setting up dotfiles from $DOTFILES_DIR"

link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_zshrc_local

mkdir -p "$HOME/.claude"
link_file "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

info "Done!"