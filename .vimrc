" Necessary for listchars to work in all environments.
scriptencoding utf-8
set encoding=utf-8

" Auto reload vimrc.
autocmd BufWritePost .vimrc source %

" Enable modeline.
set modeline
set modelines=1

let mapleader=","

" Tab length.
set tabstop=2
set sw=2
set sts=2

" Expand tab to spaces.
set expandtab

" Line length.
set tw=80
set wrap

" Auto smart indentation.
set ai
set smartindent

" Number of lines to keep visible at the top/bottom.
set scrolloff=2

" Enable mouse interaction.
set mouse=a

" Enable line numbers.
set nu

" Enable pathogen.
try
  execute pathogen#infect()
catch
endtry

syntax enable

" Load indentation rules and plugins according to detected filetype.
" Also required by pathogen.
filetype plugin indent on

" Per filetype-settings
" c/cpp modified by Deedee to match LLVM coding style
autocmd FileType c,cpp      setlocal tw=80 sw=2 sts=2 tabstop=2 expandtab
autocmd FileType java       setlocal foldmethod=marker
autocmd FileType python     setlocal expandtab
autocmd FileType python     inoremap # X<c-h>#
autocmd FileType html,php   setlocal tw=0 cc=101 expandtab nowrap
autocmd FileType javascript setlocal sw=2 sts=2 expandtab
autocmd FileType css        setlocal expandtab
autocmd FileType coffee     setlocal sw=4 sts=4 tabstop=4 expandtab
autocmd FileType coffee     inoremap # X<c-h>#

" Remove trailing whitespaces
autocmd BufWritePre * :%s/\s\+$//e

" Productivity shortcuts.
imap jk <Esc>
imap jj <Esc><Down>
imap kk <Esc><Up>
imap ggg <Esc>gg

nnoremap J <C-D>
nnoremap K <C-U>

" Select last pasted/modified text in the same visual mode
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Toggle search pattern highlighting.
set hlsearch
set incsearch
nnoremap <F3> :noh<CR>

" ctrlp: Ignore files that are in gitignore; also much faster.
let g:ctrlp_user_command = 'git ls-files -cmo --exclude-standard %s'

" Toggle git diff in the signs column.
nnoremap <leader>g :GitGutterToggle<CR>

" NERDTree
nnoremap <leader>n :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeMapOpenSplit = "<C-x>"
let NERDTreeMapOpenVSplit = "<C-v>"

" Mark tabs and spaces
set list listchars=tab:»\ ,trail:·,extends:»,precedes:«

" Configure bottom status line.
set statusline=%F       " full path of the file
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}] " file format
set statusline+=%h      " help file flag
set statusline+=%m      " modified flag
set statusline+=%r      " read only flag
set statusline+=%y      " filetype
set statusline+=%=      " left/right separator
set statusline+=%c,     " cursor column
set statusline+=%l/%L   " cursor line/total lines
set statusline+=\ %P    " percent through file
set laststatus=2
set wildmenu

" Easy split navigation, source=vimbits.com
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Improve up/down movement on wrapped lines, source=vimbits.com
nnoremap j gj
nnoremap k gk

" Force saving files that require root, source=vimbits.com
cmap w!! %!sudo tee > /dev/null %

" Open a new vsplit and switch to it, source=stevelosh.com
nnoremap <leader>w <C-w>v<C-w>l

" Undo works after restarting vim, source=vimbits.com
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" Jump to last position when reopening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Paste toggle so that pasted code isn't auto indented, source=vim.wikia.com
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Highlight the 81st column, not visible in normal terminal, visible when using
" viewports.
if version >= 703
	set cc=+1
endif

" Rewrap a block of text
map <S-Q> gq

" Search and replace the current word under the cursor.
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Ripped off from Cosmin Ratiu, on SO list; 30 Jun 2009
if has("cscope")
        " Look for a 'cscope.out' file starting from the current directory,
        " going up to the root directory.
        let s:dirs = split(getcwd(), "/")
        while s:dirs != []
                let s:path = "/" . join(s:dirs, "/")
                if (filereadable(s:path . "/cscope.out"))
                        execute "cs add " . s:path . "/cscope.out " . s:path . " -v"
                        break
                endif
                let s:dirs = s:dirs[:-2]
        endwhile

        set csto=0	" Use cscope first, then ctags
        set cst		" Only search cscope
        set csverb	" Make cs verbose

        nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

        nmap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

        " Open a quickfix window for the following queries.
        set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
endif

