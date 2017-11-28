export LANG=en_US.UTF-8

export BASH_IT=$HOME/.bash_it
export BASH_IT_THEME="zorg"
. $BASH_IT/bash_it.sh

export TERM=xterm-256color
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
fi

alias ag='ag --smart-case --pager="less -MIRFX"'
alias e='emacs'
alias eb='emacs -q'
alias para='parallel'
alias tas='tmux attach-session -t'
alias tls='tmux ls'
alias tns='tmux new-session -A -s'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

file_append () {
    echo "$1" >> "$2"
}

file_overwrite () {
    echo "$1" > "$2"
}

file_prepend () {
    local ed_cmd="1i"
    if [ ! -f "$2" ]; then
        touch "$2"
        ed_cmd="a"
    fi
    printf '%s\n' H "$ed_cmd" "$1" . w | ed -s "$2"
}

export -f file_append
export -f file_overwrite
export -f file_prepend

export EDITOR="emacs"
export GIT_EDITOR="emacs"

if [ -f "$HOME/.bash_env" ]; then
    . $HOME/.bash_env
fi

export IS_LOCAL_DOCKER_SERVER="$(cat /docker-container/.environ | \
                                 grep IS_LOCAL_DOCKER_SERVER | \
                                 awk -F'=' '{print $2}')"

export LOCAL_DOCKER_MODE="$(cat /docker-container/.environ | \
                            grep LOCAL_DOCKER_MODE | \
                            awk -F'=' '{print $2}')"

source ~python3/envs/app/bin/activate

cd ~python3
