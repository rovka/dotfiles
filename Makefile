PWD := $(shell pwd)

all: rc-files fzf

.PHONY: rc-files
rc-files: zsh vim git tmux

.PHONY: zsh
zsh: antigen
	ln -sf "${PWD}/zshrc" ~/.zshrc

.PHONY: antigen
antigen:
	rm -rf ~/.antigen.zsh
	curl -L git.io/antigen > ~/.antigen.zsh

.PHONY: vim
vim: vim-plugins
	ln -sf "${PWD}/vimrc" ~/.vimrc
	mkdir -p ~/.vim/backups

.PHONY: vim-plugins
vim-plugins: powerline
	rm -rf ~/.vim
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

.PHONY: powerline
# vim-airline uses patched powerline fonts.
powerline:
	rm -rf /tmp/fonts
	cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1
	cd /tmp/fonts && ./install.sh

.PHONY: git
git: git-config
	ln -sf "${PWD}/git/gitattributes" ~/.gitattributes
	ln -sf "${PWD}/git/gitignore" ~/.gitignore
	ln -sf "${PWD}/git/git-imgdiff.sh" ~/git-imgdiff.sh

.PHONY: git-config
git-config:
	git config --global core.excludesfile '~/.gitignore'
	git config --global core.attributesfile '~/.gitattributes'
	git config --global push.default simple
	git config --global grep.lineNumber true
	git config --global diff.renames true
	git config --global diff.image.command '~/git-imgdiff.sh'
	git config --global alias.l 'log --first-parent --oneline'
	git config --global commit.verbose true
	git config --global rerere.enabled true

.PHONY: fzf
fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

.PHONY: tmux
tmux:
	rm -rf ~/.tmux.conf ~/.tmux.conf.local
	git submodule update --init
	ln -sf "${PWD}/tmux/config/.tmux.conf" ~/.tmux.conf
	ln -sf "${PWD}/tmux/tmux.conf.local" ~/.tmux.conf.local

.PHONY: node
node:
	rm -rf ~/n
	curl -L https://git.io/n-install | bash -s -- -y -n

.PHONY: npm
npm:
	npm config set -g save-prefix ~
	npm config set -g init-license MIT
