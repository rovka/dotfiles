source ~/.antigen.zsh

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/.local/bin"
export EDITOR=vim

antigen use oh-my-zsh

# Case-sensitive completion.
CASE_SENSITIVE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false

antigen bundle git
antigen bundle tmux

antigen theme robbyrussell

antigen apply

# Defer initialization of nvm until it's needed.
# Copied from https://github.com/creationix/nvm/issues/1277#issuecomment-356309457.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

plugins=(git tmux)

# Don't retype commands on !!, just execute them.
unsetopt histverify

# Don't share history between terminals.
unsetopt share_history
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
which ag > /dev/null && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ $(uname) = 'Linux' ] && alias open='xdg-open'
alias cb='git branch --merged | grep -v "\*\|master" | xargs -n 1 git branch -d'
alias cp='rsync -rvP'
