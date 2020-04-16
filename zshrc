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
zle_highlight=(default:bold)
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

function foreach {
    echo "find . -name \"*$1" # -exec \"$2 \;\""
    # find . -name "*$1" -exec "$2 \;"
}

prompt gentoo

# Exports
export EDITOR="vim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export PROMPT="\$vcs_info_msg_0_$PROMPT"
export LANG=en_US.UTF-8
export SAVEHIST=$HISTSIZE
export PATH=$HOME/scripts/:$HOME/.local/bin/:$HOME/bin/:$PATH
export PATH="/usr/lib/ccache/bin${PATH:+:}$PATH"
export CCACHE_DIR="/var/cache/ccache"
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
alias "formatcode=find . -regextype posix-extended -regex '.*\.(c(pp)?|h)$' -exec astyle  {} \;"
alias "denv=tmux new-session -A -s development"
alias "keepbuilding=while [ true ]; do make -s; sleep 2; clear; done"
alias mc='. /usr/lib/mc/mc-wrapper.sh --nocolor'
alias "grepuni=grep --color='auto' -P -n \"[\x80-\xFF]\" -R ."
alias b=buku
alias doas=sudo

# Aliases -- Filetypes
alias -s {tex}=vim
alias -s {exe}=wine
alias -s {py}=python
alias -s {zip}=unzip -l

# Aliases -- Taskwarrior
alias "ta=task add +inbox prio:M"
alias "ti=taskinfo"
alias "tl=task inbox"
alias "tx=ta prio:H"
alias "tB=task burndown"
alias "tW=task waiting"
alias "cmus-current=cmus-remote -Q | grep status | cut -d" " -f2"
#alias "tb=task add +buy"
# alias "tr=task add +read"
# alias "tw=task add +watch prio:L"
# Todo: task add Send xxx a birthday card  due:yyyy-mm-dd scheduled:due-4d wait:due-7d util:due+2d recur:yearly prio:H

# Aliases -- nmcli
alias "wlscan=nmcli dev wifi list"
alias "wlcon=sudo nmcli dev wifi connect"

[[ ! -f /tmp/presentation ]] && [[ -f ~/.todo ]] && cat ~/.todo

#                        (\,/)
#             Always     oo   '''//,        _
#    ^...^    edit    ,/_;~,        \,    / '
#   / o,o \   dots     "'   \    (    \    !
#   |):::(|   from          ',|  \    |__.'
# ====w=w===  the internet '~  '~----''
