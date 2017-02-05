.PHONY: all pathogen vim-plugins rc-files

all: rc-files vim-plugins fzf nvm

rc-files:
	rm -rf ~/.bashrc ~/.vimrc ~/.zshrc
	ln -s `realpath bashrc` ~/.bashrc
	ln -s `realpath zshrc` ~/.zshrc
	ln -s `realpath vimrc` ~/.vimrc

pathogen:
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

vim-plugins: pathogen
	mkdir -p ~/.vim
	rm -rf ~/.vim/bundle
	git submodule update --init
	ln -s `realpath vim-plugins` ~/.vim/bundle

update-vim-plugins:
	for plugin in vim-plugins/*; do git submodule update --remote "${plugin}"; done

fzf:
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

nvm:
	curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
