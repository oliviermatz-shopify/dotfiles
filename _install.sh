#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo apt --yes update
DEBIAN_FRONTEND=noninteractive sudo apt --yes build-dep fzy

mkdir ~/build
cd ~/build

git clone https://github.com/jhawthorn/fzy.git
cd fzy
cp ~/dotfiles/fzy_multiselect.diff .
patch -p1 < fzy_multiselect.diff
make && sudo make install

cp ~/dotfiles/.tmux.conf ~

cat <<'EOF' >> ~/.zshrc
alias gs="git status"
alias gl='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
alias git-clean-all="git clean -f -x -d"
alias git-push-upstream="git push --set-upstream origin master"

gitf() {
    file=$(git status -s | fzy -l 40)

    if [ $? -eq 0 ]; then
        git $* $(echo "$file" | sed -E 's/^.. (.+)$/\1/')
    fi
}

gitb() {
    branch=$(git branch --sort=-committerdate | fzy -l 40)

    if [ $? -eq 0 ]; then
        git $* $(echo "$branch" | sed -E 's/^\s*(.*)\s*$/\1/')
    fi
}

set -o emacs
EOF
