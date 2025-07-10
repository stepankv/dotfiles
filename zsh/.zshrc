# https://docs.brew.sh/Tips-and-Tricks#load-homebrew-from-the-same-dotfiles-on-different-operating-systems
command -v brew &> /dev/null || PATH="$PATH:/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin"
command -v brew &> /dev/null && eval "$(brew shellenv)"

# Zsh plugins
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# External scripts
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
# Enable starship prompt
eval "$(starship init zsh)"
# Set up fzf: key bindings, fuzzy completion and theme
source <(fzf --zsh)
source "$XDG_CONFIG_HOME/fzf/darcula-theme.sh"

HISTFILE="$ZDOTDIR/.zsh_history"
SAVEHIST=10000
HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt EXTENDED_HISTORY       # Record timestamp of command in HISTFILE
setopt SHARE_HISTORY          # Share command history between sessions

export EDITOR="nvim"
export VISUAL="$EDITOR"

# Disable swithc to vi style keybindings.
# https://www.reddit.com/r/zsh/comments/p8ir7r/how_to_disable_vi_style_keybinds_in_zsh/
bindkey -e

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

