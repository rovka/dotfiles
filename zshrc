export ADOTDIR=~/.antigen/config
source ~/.antigen/antigen.zsh

export EDITOR=vim

antigen use oh-my-zsh

# Case-sensitive completion.
CASE_SENSITIVE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

antigen bundle git
antigen bundle docker
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure@main
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

# Don't retype commands on !!, just execute them.
unsetopt histverify

# Add pushd directory to stack even if it's already there.
setopt nopushdignoredups

# Aliases
alias debug='gdb -tui --args'
alias ddb='gdb -tui -d $LLVM_SRC --args'

# Load environment for working with my LLVM helper scripts
source ~/.setenv.sh

alias llvm-env="source llvm-env"
alias src='cd $LLVM_SRC'
alias bld='cd $LLVM_BLD'

alias llvm-build="llvm-build -j6"
alias llvm-check="llvm-build check-all"
alias llvm-check-arm="llvm-build check-llvm-codegen-arm"
alias llvm-check-aarch64="llvm-build check-llvm-codegen-aarch64"
alias llvm-check-a64="llvm-build check-llvm-codegen-aarch64"
alias llvm-check-a32="llvm-build check-llvm-codegen-arm"

alias gg='git grep'
alias ggi='git grep -i'
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

# Aliases.
[ $(uname) = 'Linux' ] && alias open='xdg-open'
alias cb='git branch --merged | grep -v "\*\|master" | xargs -n 1 git branch -d'
alias cp='rsync -rvPai'
alias ping='~/.bin/prettyping --nolegend'
