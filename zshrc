export ZSH=~/.oh-my-zsh

ZSH_THEME="af-magic"

plugins=(git)

source $ZSH/oh-my-zsh.sh

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

alias push='git push origin $(parse_git_branch)'
alias gb='git branch --sort=-committerdate'

# Smart function to checkout and pull from master or main
unalias master 2>/dev/null
master() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "Switching to main branch..."
    git checkout main && git pull
  elif git show-ref --verify --quiet refs/heads/master; then
    echo "Switching to master branch..."
    git checkout master && git pull
  elif git show-ref --verify --quiet refs/remotes/origin/main; then
    echo "Checking out main branch from origin..."
    git checkout -b main origin/main && git pull
  elif git show-ref --verify --quiet refs/remotes/origin/master; then
    echo "Checking out master branch from origin..."
    git checkout -b master origin/master && git pull
  else
    echo "Neither master nor main branch found locally or on origin"
    return 1
  fi
}
alias rebase='git pull origin master --rebase'
alias aa='git add .'
alias ci='git commit -m '
alias gdh='git diff HEAD^'

# alias pg_start="launchctl load ~/Library/LaunchAgents"
# alias pg_stop="launchctl unload ~/Library/LaunchAgents"

export HOMEBREW_NO_AUTO_UPDATE=1

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.emacs.doom/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"

export PORT=5002
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# fnm
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env`"
fi
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/nyancache/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
