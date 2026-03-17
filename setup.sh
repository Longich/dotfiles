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

# --- リダイレクトシンボリックリンク作成 ---
# dotfiles外のパス同士をリンクする（例: Application Support → XDG config）
redirect_link() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    info "Source does not exist: $src (will be created by link_file later)"
  fi

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

mkdir -p "$HOME/.config/ghostty"
link_file "$DOTFILES_DIR/.config/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"

mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
redirect_link "$HOME/.config/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

info "Done!"