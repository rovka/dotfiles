.PHONY: all pathogen vim-plugins rc-files

PWD := $(shell pwd)

all: rc-files fzf

rc-files: zsh vim git npm

zsh: oh-my-zsh
	rm -rf ~/.zshrc
	ln -s "${PWD}/zshrc" ~/.zshrc

oh-my-zsh:
	rm -rf ~/.oh-my-zsh
	curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

vim: vim-plugins
	rm -rf ~/.vimrc
	ln -s "${PWD}/vimrc" ~/.vimrc

git:
	rm -rf ~/.gitattributes ~/.gitconfig ~/.gitignore
	ln -s "${PWD}/gitconfig" ~/.gitconfig
	ln -s "${PWD}/gitattributes" ~/.gitattributes
	ln -s "${PWD}/gitignore" ~/.gitignore

npm:
	rm -rf ~/.npmrc
	ln -s "${PWD}/npmrc" ~/.npmrc

vim-plugins: pathogen
	mkdir -p ~/.vim
	rm -rf ~/.vim/bundle
	git submodule update --init
	ln -s "${PWD}/vim-plugins" ~/.vim/bundle

pathogen:
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

update-vim-plugins:
	for plugin in vim-plugins/*; do git submodule update --remote "${plugin}"; done

fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

nvm:
	rm -rf ~/.nvm
	git clone https://github.com/creationix/nvm.git ~/.nvm
	cd ~/.nvm && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
