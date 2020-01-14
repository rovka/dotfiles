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

# Don't start tmux in the IntelliJ terminal.
if ! ps -p $PPID | grep -q java; then
  ZSH_TMUX_AUTOSTART=true;
fi

ZSH_TMUX_AUTOCONNECT=false

antigen bundle git
antigen bundle tmux
antigen bundle docker
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

# Don't retype commands on !!, just execute them.
unsetopt histverify

# Don't share history between terminals.
unsetopt share_history
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS

# Bash like autocompletion where tab completes the common prefix and then waits.
setopt autolist
unsetopt menucomplete

# https://github.com/zsh-users/zsh-autosuggestions/issues/158#issuecomment-276430989
autosuggest-accept-redraw() {
  zle autosuggest-accept
  zle redisplay
  zle redisplay
}
zle -N autosuggest-accept-redraw
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=autosuggest-accept-redraw
bindkey '^ ' autosuggest-accept-redraw

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
which ag > /dev/null 2>&1 && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Aliases.
[ $(uname) = 'Linux' ] && alias open='xdg-open'
alias cb='git branch --merged | grep -v "\*\|master" | xargs -n 1 git branch -d'
alias cp='rsync -rvPai'
if [ $(uname) = 'Linux' ]; then
  alias cat='~/.bin/bat/linux/bat'
else
  alias cat='~/.bin/bat/osx/bat'
fi
alias ping='~/.bin/prettyping --nolegend'
