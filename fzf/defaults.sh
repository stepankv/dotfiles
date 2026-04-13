export FZF_DEFAULT_OPTS="
  --info='right'
  --prompt='  '
  --marker='▌'
  --pointer=' '"

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
