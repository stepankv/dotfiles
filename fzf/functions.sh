# https://github.com/junegunn/fzf/discussions/3803
# Find files
ff() {
  fzf \
    --bind "enter:become:$EDITOR {1}" \
    --preview='bat --color=always --theme=TwoDark {}' \
    --preview-window='right,border-left,~3' \
    --query "$*"
}

# https://junegunn.github.io/fzf/tips/ripgrep-integration/
# Find in files
fif() (
  reload='reload:rg --column --color=always --smart-case {q} || :'
  fzf \
    --disabled \
    --ansi \
    --bind "start:$reload" \
    --bind "change:$reload" \
    --bind "enter:become:$EDITOR {1} +{2}" \
    --delimiter : \
    --preview 'bat --color=always --highlight-line {2} {1}' \
    --preview-window='right,border-left,~3' \
    --query "$*"
)
