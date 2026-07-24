#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PACKAGES=(
  nvim
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

for package in "${PACKAGES[@]}"; do
  if [[ -d "$package" ]]; then
    echo "Installing $package..."
    stow --restow --target="$HOME" "$package"
  else
    echo "Skipping $package: directory not found."
  fi
done

echo "Dotfiles installed successfully."
