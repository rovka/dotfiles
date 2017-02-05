.PHONY: all pathogen vim-plugins rc-files

all: rc-files fzf nvm

rc-files: zshrc vimrc

zshrc: oh-my-zsh
	rm -rf ~/.zshrc
	ln -s `realpath zshrc` ~/.zshrc

oh-my-zsh: zsh curl
	rm -rf ~/.oh-my-zsh
	curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

zsh:
	sudo apt-get install -y zsh
	chsh -s $(shell which zsh)

vimrc: vim-plugins
	rm -rf ~/.vimrc
	ln -s `realpath vimrc` ~/.vimrc

vim-plugins: pathogen
	mkdir -p ~/.vim
	rm -rf ~/.vim/bundle
	git submodule update --init
	ln -s `realpath vim-plugins` ~/.vim/bundle

pathogen: curl
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

update-vim-plugins:
	for plugin in vim-plugins/*; do git submodule update --remote "${plugin}"; done

fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

nvm: curl
	rm -rf ~/.nvm
	git clone https://github.com/creationix/nvm.git ~/.nvm
	cd ~/.nvm && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
	./install-latest-node.sh

curl:
	sudo apt-get install -y curl
