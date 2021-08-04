#!/bin/bash

sudo sed -Ei 's/^# deb-src/deb-src/' /etc/apt/sources.list

sudo debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local Only'"

DEBIAN_FRONTEND=noninteractive sudo apt --yes update
DEBIAN_FRONTEND=noninteractive sudo apt --yes install fzf ripgrep cmake libtool libtool-bin rsync
DEBIAN_FRONTEND=noninteractive sudo apt --yes build-dep emacs

mkdir ~/build
cd ~/build

wget http://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz
xz -dc emacs-27.2.tar.xz | tar xp
cd emacs-27.2
./configure && make -j4 && sudo make install
cd ..

git clone https://github.com/jhawthorn/fzy.git
cd fzy
cp ~/dotfiles/fzy_multiselect.diff .
patch -p1 < fzy_multiselect.diff
make && sudo make install

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

cd ~
git clone https://github.com/oliviermatz/emacs.d.git .emacs.d
cd ~/.emacs.d
git submodule update --init
ln -s custom/custom.spin.el custom.el
mkdir ~/.emacs.d.run
