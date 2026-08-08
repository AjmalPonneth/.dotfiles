#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"
NVIM_DIR="$DOTFILES_DIR/external/kickstart.nvim"

PACKAGES=(
  scripts
  ssh
  tmux
  zsh
)

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed."
  echo "Install it first, then run this script again."
  exit 1
fi

echo "Installing dotfiles from: $DOTFILES_DIR"

if [[ ! -d "$PACKAGES_DIR" ]]; then
  echo "Missing packages directory: $PACKAGES_DIR"
  exit 1
fi

if [[ ! -f "$NVIM_DIR/init.lua" ]]; then
  if command -v git >/dev/null 2>&1; then
    echo "Initializing Neovim submodule..."
    git -C "$DOTFILES_DIR" submodule update --init --recursive external/kickstart.nvim
  else
    echo "Skipping nvim: git is not installed and $NVIM_DIR is not initialized."
  fi
fi

echo "Installing nvim..."
mkdir -p "$HOME/.config"
if [[ -e "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  echo "Skipping nvim: $HOME/.config/nvim exists and is not a symlink."
elif [[ ! -f "$NVIM_DIR/init.lua" ]]; then
  echo "Skipping nvim: $NVIM_DIR is not initialized."
else
  ln -sfnT "$NVIM_DIR" "$HOME/.config/nvim"
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

for package in "${PACKAGES[@]}"; do
  if [[ -d "$PACKAGES_DIR/$package" ]]; then
    echo "Installing $package..."
    stow --restow --no-folding --dir="$PACKAGES_DIR" --target="$HOME" "$package"
  else
    echo "Skipping $package: directory not found in $PACKAGES_DIR."
  fi
done

echo "Dotfiles installed successfully."
