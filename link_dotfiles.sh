#!/bin/bash

## Creates or updates existing symlink to dotfiles in ~/.config directory.
## Before linking, checks if existing files already symlinks.
## Otherwise stops execution.

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
declare -a dotfiles=(
  "alacritty"
  "lazygit"
  "yazi"
  "zellij"
  "zsh"
  "starship.toml"
)

check_if_dotfiles_symliks() {
  for file in "${dotfiles[@]}"; do
    local dotfile="$config_dir/$file"
    if [ -e "$dotfile" ]; then
      if [ ! -L "$dotfile" ]; then
        echo "file/directory '$file' is not a simlink. move/remove it and run script again." 1>&2
        exit 1
      fi
    fi
  done
}

if [ -d "$config_dir" ]; then
  check_if_dotfiles_symliks
else
  mkdir -p "$config_dir"
fi

for dotfile in "${dotfiles[@]}"; do
  ln -sfn "$(pwd)/$dotfile" "$config_dir/$dotfile"
done
ln -sfn "$(pwd)/dotfiles.nvim" "$config_dir/nvim"
