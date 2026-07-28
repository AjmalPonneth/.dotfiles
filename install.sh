#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PACKAGES=(
  tmux
  zsh
)

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed."
  echo "Install it first, then run this script again."
  exit 1
fi

echo "Installing dotfiles from: $DOTFILES_DIR"

cd "$DOTFILES_DIR"

echo "Installing nvim..."
mkdir -p "$HOME/.config"
if [[ -e "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  echo "Skipping nvim: $HOME/.config/nvim exists and is not a symlink."
else
  ln -sfnT "$DOTFILES_DIR/kickstart.nvim" "$HOME/.config/nvim"
fi

for package in "${PACKAGES[@]}"; do
  if [[ -d "$package" ]]; then
    echo "Installing $package..."
    stow --restow --target="$HOME" "$package"
  else
    echo "Skipping $package: directory not found."
  fi
done

echo "Dotfiles installed successfully."
