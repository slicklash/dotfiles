if [ $commands[fasd] ]; then

  fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"

  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init auto >| "$fasd_cache"
  fi

  source "$fasd_cache"
  unset fasd_cache

  alias v="f -e $EDITOR"

  z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
  }

fi
