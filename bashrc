
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
RESET="$(tput sgr0)"
BOLD="$(tput bold)"

shopt -s autocd
set -o vi

git_status() {
	e_start=$(printf '\001')
	e_end=$(printf '\002')
	git rev-parse --git-dir > /dev/null 2>&1 || exit
	echo "($e_start${MAGENTA}${BOLD}$e_end$(git branch --show-current)$e_start${RESET}$e_end) "
}

export TERM=xterm-256color
export EDITOR=vim
export PS1=" \w \$(git_status)\[${BOLD}${GREEN}\]\$\[${RESET}\] "

