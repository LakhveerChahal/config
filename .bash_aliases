# git aliases
alias gd='git pull origin Develop'
alias gca='git commit --amend --no-edit'
alias ga='git add -A && git status'
alias gc='git commit -m'
alias gco='git checkout'
alias gf='git fetch origin'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gr='git rebase'
alias gcls='git add -A && git stash && git stash drop stash@{0}'
alias gp='git push'
alias gpf='git push -f'
alias gpl='git pull origin $(git branch --show-current)'
alias gsync='gco main && gpl && gco - && git rebase main'
alias gl='git log --oneline --graph --all --decorate'

# mvn aliases
alias mvni='mvn -T 4 clean install -DskipTests'

mver() {
    eval "mvn versions:set -DnewVersion=$1"
}

# CLI Aliases
alias ll="ls -la"
alias c="clear"
alias ..="cd .."

# Vim Aliases
alias v="nvim ."
alias vi="nvim ."
alias vim="nvim ."
