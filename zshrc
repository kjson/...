alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
ZSH_THEME="abel"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

Plugins=(git command-not-found)
source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/.nix-profile/etc/profile.d/nix.sh
