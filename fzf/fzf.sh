export FZF_DEFAULT_OPTS="
  --info='right'
  --prompt='  '
  --marker='▌'
  --pointer=' '"

# https://vitormv.github.io/fzf-themes/
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
  --color=fg:#DFE1E5,fg+:#d0d0d0,bg:-1,bg+:#2E436E
  --color=hl:#BA9752,hl+:#BA9752,info:#6F737A,marker:#548AF7
  --color=prompt:#CED0D6,spinner:#548AF7,pointer:#5c8ff6,header:#6F737A
  --color=gutter:#1E2022,border:#323438,separator:#323438,scrollbar:#525355
  --color=preview-bg:#1E2022,preview-border:#323438,preview-scrollbar:#525355,label:#6F737A
  --color=query:#BCBEC4"

export FZF_DEFAULT_COMMAND="fd \
  --hidden \
  --follow \
  --color never \
  --type file \
  --type symlink \
  --exclude '.git/*' \
  --exclude '.cache/*' \
  --exclude '.gradle/.tmp/*' \
  --exclude '.gradle/caches/*' \
  --exclude '.kube/cache/*' \
  --exclude '.npm/_cache/*' \
  --exclude 'Library/Caches/*'"

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
