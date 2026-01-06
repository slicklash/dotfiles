# zmodload zsh/zprof

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
[ -d "$HOME/Library/Caches" ] && export XDG_CACHE_HOME="$HOME/Library/Caches"

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

for d in \
  "$HOME/bin" \
  "$HOME/.local/bin" \
  "$HOME/.local/share/fnm" \
  "$HOME/.cargo/bin" \
  "$HOME/.nimble/bin" \
  "$HOME/.vim/rc.plugins" \
  "$HOME/go/bin" \
  "$HOME/zig" \
  "$HOME/bin/pypy3/bin" \
  "$HOME/bin/platform-tools"
do
  [ -d "$d" ] && PATH="$d:$PATH"
done

[ -d /opt/homebrew/bin ] && PATH="/opt/homebrew/bin:$PATH"
[ -d /opt/homebrew/opt/postgresql@17/bin ] && PATH="$PATH:/opt/homebrew/opt/postgresql@17/bin"

if [ -d "$HOME/Library/Python" ]; then
  PY_PYLSP_BIN=""
  while IFS= read -r d; do
    [ -d "$d" ] || continue
    if [ -x "$d/pylsp" ]; then
      PY_PYLSP_BIN="$d"  # keep the highest version found
    fi
  done <<EOF
$(printf '%s\n' "$HOME/Library/Python"/*/bin 2>/dev/null | sort -V)
EOF

  [ -n "$PY_PYLSP_BIN" ] && PATH="$PATH:$PY_PYLSP_BIN"
fi

export PATH
export GRAALVM_HOME=$HOME/bin/graalvm-ce-java
export BAT_THEME="aloneinthedark"
export LF_UEBERZUG_TEMPDIR="/tmp/lf-ueberzug-tmp"
export HOMEBREW_NO_AUTO_UPDATE=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

source $HOME/.zsh/init.zsh

export PYENV_ROOT="$HOME/.pyenv"
if [ -s "$PYENV_ROOT/bin/pyenv" ]; then
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# zprof
