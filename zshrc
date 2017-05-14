alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
ZSH_THEME="abel"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

Plugins=(git command-not-found zsh-autosuggestions zsh-syntax-highlighting)
source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/.nix-profile/etc/profile.d/nix.sh

# make tmux use 256 colors
alias tmux='TERM=xterm-256color tmux'
source /Users/kevinjohnson/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.cargo/env
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
source ~/.bash_profile
