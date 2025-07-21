#!/usr/bin/env bash

set -eu

# Clone dotfiles repository and change cwd.
mkdir -p "$HOME/workbench"
cd "${HOME}/workbench"
[[ -d dotfiles ]] || git clone -q --recurse-submodules git@github.com:bost367/dotfiles.git
cd dotfiles

# Create links in user's configuration directory.
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_dir"
declare -a dotfiles=(
  "alacritty"
  "lazygit"
  "nvim"
  "yazi"
  "zellij"
  "zsh"
  "starship.toml"
  "fzf"
)

check_if_dotfiles_symliks() {
  for file in "${dotfiles[@]}"; do
    local dotfile="$config_dir/$file"
    if [ -e "$dotfile" ]; then
      if [ ! -L "$dotfile" ]; then
        echo "file/directory '$file' is not a simlink. backup '$dotfile.bak' will be created." 1>&2
        mv "$dotfile" "$dotfile.bak"
      fi
    fi
  done
}

# Check if existing files already symlinks before link them.
if [ -d "$config_dir" ]; then
  check_if_dotfiles_symliks
else
  mkdir -p "$config_dir"
fi

# Create or update existing symlink to dotfiles.
for dotfile in "${dotfiles[@]}"; do
  ln -sfn "$(pwd)/$dotfile" "$config_dir/$dotfile"
done

ya pkg install                    # Install yazi plugins.
nvim --headless "+Lazy! sync" +qa # Install neovim plugins.
echo ""
echo "Completed cloning dotfiles!"
