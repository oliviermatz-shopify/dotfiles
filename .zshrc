setopt histignorealldups sharehistory

bindkey -e

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

setopt promptsubst
export PS1="\$(myprompt)"

grep-git-ls-files() {
    git ls-files -zco --exclude-standard | xargs -0 grep --color -nH -E $@
}

export EDITOR="vi"

set -o emacs

alias clipcopy="xclip -selection clipboard"
alias clippaste="xclip -selection clipboard -o"
alias gs="git status"
alias gl='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
alias git-clean-all="git clean -f -x -d"
alias git-push-upstream="git push --set-upstream origin master"
alias ts="date +%Y_%m_%d_%H_%M_%S"
alias lpass-login='lpass login maeliss.olivier.teissier.matz@gmail.com'

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

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/gnupg@2.2/bin:$PATH"

export PATH="/usr/local/lib/ruby/gems/2.7.0/bin/:/usr/local/opt/ruby@2.7/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby@2.7/lib"
export CPPFLAGS="-I/usr/local/opt/ruby@2.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby@2.7/lib/pkgconfig"

export PATH="/usr/local/opt/node@14/bin:$PATH"

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

if [ -e /Users/oliviermatz/.nix-profile/etc/profile.d/nix.sh ]; then
	. /Users/oliviermatz/.nix-profile/etc/profile.d/nix.sh;
fi
