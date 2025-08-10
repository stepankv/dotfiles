export FZF_DEFAULT_OPTS="
  --preview='bat --color=always {}'
  --preview-window='right,border-left'
  --info='right'
  --prompt=' '
  --marker=''
  --pointer=' '"

# https://vitormv.github.io/fzf-themes/
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
  --color=fg:#DFE1E5,fg+:#d0d0d0,bg:-1,bg+:#2E436E
  --color=hl:#FFC15E,hl+:#FFC15E,info:#6F737A,marker:#548AF7
  --color=prompt:#4E8052,spinner:#548AF7,pointer:#5c8ff6,header:#6F737A
  --color=gutter:#1E2022,border:#393B41,separator:#393B41,scrollbar:#525355
  --color=preview-bg:#1E2022,preview-border:#393B41,preview-scrollbar:#525355,label:#6F737A
  --color=query:#BCBEC4"

export FZF_DEFAULT_COMMAND="fd \
  --hidden \
  --follow \
  --color never \
  --type file \
  --type symlink \
  --exclude .git"
