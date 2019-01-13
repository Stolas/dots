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
    ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
    echo "[${ref}]"
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

# Exports
export EDITOR="vim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export LANG=en_US.UTF-8
export PROMPT="%m$(task_status) %~ $(repo_status) > "
export SAVEHIST=$HISTSIZE
export PATH=$PATH:$HOME/scripts/:$HOME/.local/bin/:$HOME/bin/
[[ -f /usr/bin/clang ]] && export CC=/usr/bin/clang
[[ -f /usr/bin/clang++ ]] && export CXX=/usr/bin/clang++

# Aliases
alias "manzshbuildin=man zshbuiltins"
alias "manzshmisc=man zshmisc"
alias scp='noglob scp_wrap'
alias "l=ls -Alhx"
alias "ll=ls"
alias "watch=watch -c"
alias "getip=ip -br -c a"
alias "denv=tmux new-session -A -s development"
alias "keepbuilding=while [ true ]; do make -s; sleep 2; clear; done"

# Aliases -- Filetypes
alias -s {tex}=vim
alias -s {exe}=wine
alias -s {py}=python

# Aliases -- Taskwarrior
alias "ta=task add +inbox prio:M"
alias "ti=taskinfo"
alias "tl=task inbox"
alias "tx=ta prio:H"
alias "tB=task burndown"
alias "tW=task waiting"
#alias "tb=task add +buy"
# alias "tr=task add +read"
# alias "tw=task add +watch prio:L"
# Todo: task add Send xxx a birthday card  due:yyyy-mm-dd scheduled:due-4d wait:due-7d util:due+2d recur:yearly prio:H

# Aliases -- nmcli
alias "wlscan=nmcli dev wifi list"
alias "wlcon=sudo nmcli dev wifi connect"

[[ -f ~/.todo ]] && cat ~/.todo
