PATH=$PATH:$HOME/.local/bin

gitf() {
    file=$(git status -s | fzf -m)

    if [ $? -eq 0 ]; then
        git $* $(echo "$file" | sed -E 's/^.. (.+)$/\1/')
    fi
}

gitb() {
    branch=$(git branch --sort=-committerdate | fzf -m)

    if [ $? -eq 0 ]; then
        git $* $(echo "$branch" | sed -E 's/^\s*(.*)\s*$/\1/')
    fi
}

alias gl='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
alias gs='git status'
