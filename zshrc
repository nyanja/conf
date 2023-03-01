export ZSH=~/.oh-my-zsh

ZSH_THEME="af-magic"

plugins=(git)

source $ZSH/oh-my-zsh.sh

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# F1=\eOP F2=\eOQ F3=\eOR F4=\eOS F5=\e[15~ F6=\e[17~ F7=\e[18~ F8=\e[19~ F9=\e[20~ F10=\e[21~ F12=\e[24~

alias push='git push origin $(parse_git_branch)'

alias master='git checkout master && git pull'
alias rebase='git pull origin master --rebase'
alias aa='git add .'
alias ci='git commit -m '
alias be='bundle exec'
alias dg='git diff'
alias gdh='git diff HEAD^'
alias raisl='rails'
alias k='cd ~/f/web'
alias a='cd ~/f/mkadmin'

# alias pg_start="launchctl load ~/Library/LaunchAgents"
# alias pg_stop="launchctl unload ~/Library/LaunchAgents"

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.emacs.doom/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"

export PORT=5002
export PATH="/opt/homebrew/sbin:$PATH"
