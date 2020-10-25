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
bindkey '^R' history-incremental-search-backward

# Styles
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':vcs_info:git:*' formats '[%b]'

# Functions
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

#prompt gentoo
#prompt suse
export EDITOR="gvim"
export HISTFILE=~/.histfile
export HISTSIZE=1000
export PROMPT="%d λ "
export LANG=en_US.UTF-8
export SAVEHIST=$HISTSIZE
export PATH=$HOME/scripts/:$HOME/.local/bin/:$HOME/bin/:$PATH:$HOME/.gem/ruby/2.7.0/bin
export PATH="/usr/lib/ccache/bin${PATH:+:}$PATH"
export CCACHE_DIR="/var/cache/ccache"
[[ -f /usr/bin/clang ]] && export CC=/usr/bin/clang
[[ -f /usr/bin/clang++ ]] && export CXX=/usr/bin/clang++

# Aliases
alias "manzshbuildin=man zshbuiltins"
alias "manzshmisc=man zshmisc"
alias scp='noglob scp_wrap'
alias "l=ls -Alhx"
alias "m=make -s -j$(nproc)"
alias "ll=ls"
alias "watch=watch -c"
alias "getip=ip -br -c a"
alias "formatcode=find . -regextype posix-extended -regex '.*\.(c(pp)?|h)$' -exec astyle  {} \;"

# Aliases -- Filetypes
alias -s {tex}=vim
alias -s {exe}=wine
alias -s {py}=python
alias -s {zip}=unzip -l

# Aliases -- Taskwarrior
alias "doom=crispy-doom -iwad ~/Games/DooM/iwad/DOOM2.WAD"
alias "doom-fast=crispy-doom -fast -iwad ~/Games/DooM/iwad/DOOM2.WAD"


gvim () { command gvim --remote-silent "$@" || command gvim "$@"; }
alias "vim=gvim"


[[ ! -f /tmp/presentation ]] && [[ -f ~/.todo ]] && cat ~/.todo

#                        (\,/)
#             Always     oo   '''//,        _
#    ^...^    edit    ,/_;~,        \,    / '
#   / o,o \   dots     "'   \    (    \    !
#   |):::(|   from          ',|  \    |__.'
# ====w=w===  the internet '~  '~----''


# opam configuration
test -r /home/stolas/.opam/opam-init/init.zsh && . /home/stolas/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

