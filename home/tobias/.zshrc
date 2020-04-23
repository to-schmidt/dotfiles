eval `dircolors ~/.dircolors/solarized.dark`

alias git='unset SSH_ASKPASS; git'
alias g='git'
alias le='l'
alias cat='cat'

RPROMPT=''

POWERLEVEL9K_COLOR_SCHEME='light'
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time dir ssh vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

plugins=(git colorize colored-man-pages sudo docker)

ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh-custom
ZSH_THEME="powerlevel9k/powerlevel9k"

source $HOME/.oh-my-zsh/oh-my-zsh.sh
