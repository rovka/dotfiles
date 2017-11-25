PWD := $(shell pwd)

all: rc-files fzf

rc-files: zsh vim git npm

zsh: oh-my-zsh
	ln -sf "${PWD}/zshrc" ~/.zshrc

oh-my-zsh:
	rm -rf ~/.oh-my-zsh
	curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

vim: vim-plugins
	ln -sf "${PWD}/vimrc" ~/.vimrc
	mkdir -p ~/.vim/backups

git: git-config
	ln -sf "${PWD}/gitattributes" ~/.gitattributes
	ln -sf "${PWD}/gitignore" ~/.gitignore
	ln -sf "${PWD}/git-imgdiff.sh" ~/git-imgdiff.sh

git-config:
	git config --global core.excludesfile '~/.gitignore'
	git config --global core.attributesfile '~/.gitattributes'
	git config --global push.default simple
	git config --global grep.lineNumber true
	git config --global diff.renames true
	git config --global diff.image.command '~/git-imgdiff.sh'
	git config --global alias.l 'log --first-parent --oneline'
	git config --global commit.verbose true

npm:
	ln -sf "${PWD}/npmrc" ~/.npmrc

vim-plugins:
	rm -rf ~/.vim
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

nvm:
	rm -rf ~/.nvm
	git clone https://github.com/creationix/nvm.git ~/.nvm
	cd ~/.nvm && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
