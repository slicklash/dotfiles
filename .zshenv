export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ -d "$HOME/Library/Caches" ]; then
  export XDG_CACHE_HOME="$HOME/Library/Caches"
else
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
fi

. "$HOME/.cargo/env"
