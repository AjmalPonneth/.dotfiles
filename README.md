# Dotfiles

Personal dotfiles managed with GNU Stow.

## Layout

```text
.
├── external/
│   └── kickstart.nvim/    # Neovim config submodule
├── packages/
│   ├── scripts/           # ~/.local/bin/*
│   ├── ssh/               # ~/.ssh/config
│   ├── tmux/              # ~/.tmux.conf
│   └── zsh/               # ~/.zshrc
└── install.sh
```

## Install

```sh
git clone --recurse-submodules <repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

If the repository was cloned without submodules, `install.sh` will try to initialize
`external/kickstart.nvim` automatically.

The installer links Neovim to `~/.config/nvim` and stows everything under
`packages/` into `$HOME`.
