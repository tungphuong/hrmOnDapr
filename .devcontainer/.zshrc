export ZSH=$HOME/.oh-my-zsh
export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history

ZSH_THEME="candy"

plugins=(
    git
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh