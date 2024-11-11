export PATH=$HOME/bin:$PATH
# export PATH=$PATH:$HOME/SpiderOak\ Hive/notes
# export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.nimble/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/bin/scripts
export PATH=$PATH:$HOME/bin/pypy3/bin
export PATH=$PATH:$HOME/bin/sonar-scanner/bin
export PATH=$PATH:$HOME/bin/platform-tools
export PATH=$PATH:$HOME/.vim/rc.plugins
export PATH=$PATH:$HOME/.config/lf
# export PATH=$PATH:$HOME/bin/android-studio/bin
# export PATH=$PATH:$HOME/Android/Sdk/platform-tools
# export PATH=$PATH:$HOME/Android/Sdk/emulator
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

export NOTEBOOK_DIR=$HOME/code/nb
export PATH=$PATH:$HOME/code/nb

export GRAALVM_HOME=$HOME/bin/graalvm-ce-java

export DOTNET_CLI_TELEMETRY_OPTOUT=1
# export TSS_LOG="-level verbose -file $HOME/tmp/tsserver.log"
export BAT_THEME="aloneinthedark"

export LF_UEBERZUG_TEMPDIR="/tmp/lf-ueberzug-tmp"

source $HOME/.zsh/init.zsh

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PYENV_ROOT="$HOME/.pyenv"
if [ -s "$PYENV_ROOT/bin/pyenv" ]; then
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/slicklash/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/slicklash/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/slicklash/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/slicklash/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
