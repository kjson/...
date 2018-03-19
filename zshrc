ZSH_THEME="abel"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
Plugins=(git command-not-found zsh-autosuggestions zsh-syntax-highlighting)
alias tmux='TERM=xterm-256color tmux' # make tmux use 256 colors
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
bindkey -s "\C-r" "\eqhh\n"     # bind hh to Ctrl-r
bindkey -s "\C-f" "\eqranger\n" # bind ranger to Ctrl-f
bindkey -s "\C-t" "\eqtig\n"    # bind tig to Ctrl-t
source $HOME/.oh-my-zsh/oh-my-zsh.sh
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.cargo/env
export HISTFILE=$HOME/.zsh_history  # ensure history file visibility
export HH_CONFIG=hicolor        # get more colors
alias duu='du -d 1'
alias dff='df -gHl'
alias lss='ls -alST'
alias ls+='exa -T'
alias rm+='rm -frPdv'


export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
