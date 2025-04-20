# Plugins
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# External scripts
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
# Enable starship prompt
eval "$(starship init zsh)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Fix fistory on Ubuntu
HISTFILE="$ZDOTDIR/.zsh_history"
SAVEHIST=10000
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS

export EDITOR="nvim"
export VISUAL="$EDITOR"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

