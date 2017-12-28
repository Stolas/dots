# Read: http://bewatermyfriend.org/p/2012/003/
# man zshbuiltins
# man zshmisc

# Autoload
autoload -Uz compinit
autoload -Uz promptinit
autoload -U history-search-end

# Run
compinit
promptinit

# Set Opt
setopt autocd
setopt automenu
setopt correctall
setopt extendedglob
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Keys
bindkey -v
zle -N history-beginning-search-backward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end

# Styles
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Functions
function task_status
{
    task +inbox +PENDING count
}

function repo_status
{
  return
  #echo "(master)"
}

function bat_status
{
    if [[ -d /proc/acpi/battery/BAT0/ ]]; then
        echo "BAT: $((100*$(sed -n "s/remaining capacity: *\(.*\) m[AW]h/\1/p" /proc/acpi/battery/BAT0/state)/$(sed -n "s/last full capacity: *\(.*\) m[AW]h/\1/p" /proc/acpi/battery/BAT0/info)))%%"
    fi
}

function taskinfo
{
    printf "ta : Task Add\ttl : Task List\n"
    printf "tw : Watch Task\ttr : Read Task\n"
    printf "tb : Buy List\ttB : Task Burndown\n"
    printf "tW : Show waiting tasks\n"
    printf "tx : Task Important Task\n"
}

function gvim ()
{
    command gvim --remote-silent "$@" || command gvim "$@";
}

function check_mail
{
    if [ -d ~/.mail/ ]; then
        for i in ~/.mail/*; do
            mailpath[$#mailpath+1]="${i}?You have new mail in ${i:t}."
        done
    fi
}

# Exports
export EDITOR="vim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export PROMPT="%m[$(task_status)] %~ $(repo_status) > "
# export PS1=$PROMPT
export RPROMPT="$(bat_status)"
export SAVEHIST=$HISTSIZE
export PATH=$PATH:~/scripts/

# Aliases
alias "manzshbuildin=man zshbuiltins"
alias "manzshmisc=man zshmisc"
alias "e=gvim"
alias "l=ls -Alhx"
alias "ll=ls"

# Aliases -- Taskwarrior
alias "ta=task add +inbox prio:M"
alias "ti=taskinfo"
alias "tl=task inbox"
alias "tr=task add +read"
alias "tw=task add +watch prio:L"
alias "tx=ta prio:H"
alias "tB=task burndown"
alias "tb=task add +buy"
alias "tW=task waiting"
# Todo: task add Send xxx a birthday card  due:yyyy-mm-dd scheduled:due-4d wait:due-7d util:due+2d recur:yearly prio:H

# Aliases -- nmcli
alias "wlscan=nmcli dev wifi list"
alias "wlcon=sudo nmcli dev wifi connect"


# Auto included by installers.
# Thisis for 010
PATH=$PATH:/home/robin/bin/010editor;export PATH;

# This is all for cocos2d-x
export COCOS_CONSOLE_ROOT="$HOME/bin/cocos2d-x-3.16/tools/cocos2d-console/bin"
export PATH=$COCOS_CONSOLE_ROOT:$PATH
export COCOS_X_ROOT="$HOME/bin/"
export PATH=$COCOS_X_ROOT:$PATH
export COCOS_TEMPLATES_ROOT="$HOME/bin/cocos2d-x-3.16/templates"
export PATH=$COCOS_TEMPLATES_ROOT:$PATH
export NDK_ROOT="$HOME/bin/android-ndk-r16"
export PATH=$NDK_ROOT:$PATH
export ANDROID_SDK_ROOT="$HOME/Android/Sdk/"
export PATH=$ANDROID_SDK_ROOT:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
