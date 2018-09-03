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

# Always update Xresouces
if type xrdb &> /dev/null; then
    [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
fi
# Reminder to never do the thing below again.
# [[ -z "$TMUX" ]] && tmux new-session -A -s default

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
    if type task &> /dev/null; then
        echo -n "[$(task +inbox +PENDING count)] "
    fi
}

function repo_status
{
  # Todo;
  return
  #echo "(master)"
}

# Disable globbing on the remote path.
function scp_wrap {
    local -a args
    local i
    for i in "$@"; do case $i in
        (*:*) args+=($i) ;;
        (*) args+=(${~i}) ;;
    esac; done
    command scp "${(@)args}"
}

function taskinfo
{
    printf "ta : Task Add\ttl : Task List\n"
    printf "tw : Watch Task\ttr : Read Task\n"
    printf "tb : Buy List\ttB : Task Burndown\n"
    printf "tW : Show waiting tasks\n"
    printf "tx : Task Important Task\n"
}

function vim ()
{
    command vim --remote-silent "$@" || command vim "$@";
}


# Exports
export EDITOR="vim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export PROMPT="%m$(task_status) %~ $(repo_status) > "
# export PS1=$PROMPT
export SAVEHIST=$HISTSIZE
export PATH=$PATH:$HOME/scripts/:$HOME/.local/bin/:$HOME/bin/

# Aliases
alias "manzshbuildin=man zshbuiltins"
alias "manzshmisc=man zshmisc"
alias scp='noglob scp_wrap'
alias "e=gvim"
alias "l=ls -Alhx"
alias "ll=ls"
alias "getip=ip -br -c a"
alias "denv=tmux new-session -A -s development"


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


cat ~/.todo
