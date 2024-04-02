export ZSH=~/.oh-my-zsh

ZSH_THEME="af-magic"

plugins=(git)

source $ZSH/oh-my-zsh.sh

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

alias push='git push origin $(parse_git_branch)'
alias gb='git branch --sort=-committerdate'

alias master='git checkout master && git pull'
alias rebase='git pull origin master --rebase'
alias aa='git add .'
alias ci='git commit -m '
alias gdh='git diff HEAD^'

# alias pg_start="launchctl load ~/Library/LaunchAgents"
# alias pg_stop="launchctl unload ~/Library/LaunchAgents"

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.emacs.doom/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"

export PORT=5002
export PATH="/opt/homebrew/sbin:$PATH"
