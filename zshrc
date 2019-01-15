# Read: http://bewatermyfriend.org/p/2012/003/
# man zshbuiltins
# man zshmisc

# Autoload
autoload -Uz compinit
autoload -Uz promptinit
autoload -U history-search-end
autoload -Uz vcs_info

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
setopt prompt_subst

# Keys
bindkey -v
zle -N history-beginning-search-backward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end

# Styles
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':vcs_info:git:*' formats '[%b]'

# Functions
function task_status
{
    if type task &> /dev/null; then
        echo -n "[$(task +inbox +PENDING count)] "
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

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )


# function vim ()
# {
#     command vim --remote-silent "$@" || command vim "$@";
# }

# Exports
export EDITOR="vim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export PROMPT="%m$(task_status) %~ \$vcs_info_msg_0_ > "
echo "t"
# export PS1=$PROMPT
export SAVEHIST=$HISTSIZE
export PATH=$PATH:$HOME/scripts/:$HOME/.local/bin/:$HOME/bin/
[[ -f /usr/bin/clang ]] && export CC=/usr/bin/clang
[[ -f /usr/bin/clang++ ]] && export CXX=/usr/bin/clang++

# Aliases
alias "manzshbuildin=man zshbuiltins"
alias "manzshmisc=man zshmisc"
alias scp='noglob scp_wrap'
alias "e=gvim"
alias "l=ls -Alhx"
alias "ll=ls"
alias "getip=ip -br -c a"
alias "denv=tmux new-session -A -s development"
alias "keepbuilding=while [ true ]; do make -s; sleep 2; clear; done"


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

# Aliases -- Fck Apt
alias "zypper=apt"

[[ -f ~/.todo ]] && cat ~/.todo
