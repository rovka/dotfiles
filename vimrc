" Potentially re-usable keys:
" Normal mode:
" c,
" U - uppercase, u - lowercase

let mapleader=","
let maplocalleader=';'

" Quick access to this file
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Necessary for listchars to work in all environments.
scriptencoding utf-8
set encoding=utf-8

" Auto reload vimrc.
augroup rc
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup end

" Fix webpack watch.
set backupcopy=yes

" Try to stop saving backup files and swap files in the current folder.
set backupdir=~/.vim/backups,.
set directory=~/.vim/backups,.

" Enable modeline.
set modeline
set modelines=1

" Show (partial) command in the last line of the screen. Helps to see if you
" accidentally pressed any key.
set showcmd

let mapleader=","

" Number of lines to keep visible at the top/bottom.
set scrolloff=2

" Enable mouse interaction.
set mouse=a

" Enable line numbers.
set nu

" Increment numbers in decimal format, as you'd expect.
" Without this, Ctrl-A-ing on 07 would change to 10 because
" of the leading 0 that tells vim to increment in octal.
" From http://stackoverflow.com/questions/13273741/why-does-incrementing-with-ctrl-a-in-vim-take-me-from-07-to-10
set nrformats-=octal

" Enable Vundle.
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

syntax enable

" Tab length.
set tabstop=2
set sw=2
set sts=2

" Expand tab to spaces.
set expandtab

" Line length.
set tw=80
set wrap
set linebreak
set breakindent
let &showbreak = '>>> '

" Highlight the line length limit.
if version >= 703
	set cc=+1
endif

" Copy the indentation of the previous line when creating a new one.
set ai

" An indent is automatically inserted:
" - After a line ending in '{'.
" - After a line starting with a keyword from 'cinwords'.
" - Before a line starting with '}' (only with the "O" command).
" When typing '}' as the first character in a new line, that line is
" given the same indent as the matching '{'.
" set smartindent
set cindent
set cinkeys-=0#
set indentkeys-=0#

" Syntax highlighting.
Plugin 'ekalinin/Dockerfile.vim'

" Git.
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" File exploring.
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdtree'

Plugin 'scrooloose/nerdcommenter'

Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'ycm-core/YouCompleteMe'

" All of the Vundle plugins must be added before this.
call vundle#end()

let g:solarized_termcolors=256
try
  colorscheme solarized
catch
endtry
set background=dark

" Airline.
try
  let g:airline_theme='solarized'
  let g:airline_powerline_fonts = 1
  let g:airline_extensions=[] " Disable the whitespace extension.
  " Remove some of the noise.
  let g:airline_section_b=airline#section#create(['branch'])
  let g:airline_section_x=airline#section#create([])
  let g:airline_section_y=airline#section#create([])
  let g:airline_section_y=airline#section#create([])
catch
endtry

" Always show the status line.
set laststatus=2

" Enable auto completion in the command line.
set wildmenu

" Load indentation rules and plugins according to detected filetype.
" Also required by vundle.
filetype plugin indent on

" Per filetype-settings
" c/cpp modified by Deedee to match LLVM coding style
augroup lints
  autocmd FileType c,cpp      setlocal tw=80 sw=2 sts=2 tabstop=2
  autocmd FileType llvm       setlocal tw=0 sw=2 sts=2 tabstop=2 expandtab
  autocmd FileType python     setlocal expandtab
  autocmd FileType gitcommit  setlocal tw=72

  " +1: Try to break a line before the last one letter word.
  autocmd FileType * set fo+=1

  " Remove trailing whitespaces
  fun! <SID>StripTrailingWhitespaces()
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      call cursor(l, c)
  endfun
  " Sometimes it's not ok to remove trailing whitespaces. Stay on the safe side
  " by explicitly selecting which kinds of files we want this for.
  autocmd BufWritePre *.c,*.h,*.cpp,*.hpp,*.inc,*.td,*.py :call <SID>StripTrailingWhitespaces()
augroup end

" Productivity shortcuts.
imap jk <Esc>
imap jj <Esc><Down>
imap kk <Esc><Up>
inoremap ;; <Esc>e
inoremap hh <Esc>b
imap ggg <Esc>gg

vnoremap jk <Esc>

vnoremap H <Home>
vnoremap L <End>
onoremap H <Home>
onoremap L <End>

nnoremap H <Home>
nnoremap L <End>

nnoremap J <C-D>
nnoremap K <C-U>
"
" Move lines up or down.
nnoremap J :m .+1<CR>==
nnoremap K :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Just save!
inoremap :w <Esc>:w

" Jump to the beginning/end of the block
noremap <leader>J /}<CR>
noremap <leader>K ?{<CR>

" Enter insert mode above/below the current line and add an additional empty
" line.
nnoremap oo o<CR>
nnoremap OO O<CR>

" Select last pasted/modified text in the same visual mode
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Highlight search results.
set hlsearch
" Incremental search: jumps to the first match while typing.
set incsearch
" Toggle search pattern highlighting.
nnoremap <leader>h :noh<CR>

" Fuzzy file find.
set rtp+=~/.fzf
" Make the fzf layout consistent with the one in the shell.
let g:fzf_layout = { 'down': '~40%' }
let $FZF_DEFAULT_OPTS = '--reverse --multi'
nnoremap <C-p> :Files<CR>

" Default options are --nogroup --column --color and they will be merged with
" the new options. Unfortunately there is no --nocolumn option so we're stuck
" with that.
" source: https://github.com/junegunn/fzf.vim/issues/273#issuecomment-267641703
let s:ag_options = '--smart-case --hidden --ignore .git'

" Enable quick preview for search results and use the options above.
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(
    \   <q-args>,
    \   s:ag_options,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0
    \ )

" Search the entire project for the visual selection.
vnoremap <C-f> y:Ag<space><C-R>"<CR>
" When there's no visual selection you have to type your search pattern, or you
" can press enter and then type it to get fuzzy matches.
nnoremap <C-f> :Ag<space>

" Fuzzy search in all the open buffers.
nnoremap <C-g> :Lines<CR>

" Search and replace the current word under the cursor.
:nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Search and replace the current visual selection.
:vnoremap <leader>s y:%s/\<<C-R>"\>//g<Left><Left>

nnoremap <C-b> :Buffers<CR>

" Toggle git diff in the signs column.
nnoremap <leader>g :GitGutterToggle<CR>

" NERDTree
nnoremap <leader>n :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeMapOpenSplit = "<C-x>"
let NERDTreeMapOpenVSplit = "<C-v>"

" Mark tabs and spaces
set list listchars=tab:»\ ,trail:·,extends:»,precedes:«

" Easy split navigation, source=vimbits.com
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Change default location for new splits
set splitbelow
set splitright

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
nnoremap <leader>p :set invpaste paste?<CR>
set pastetoggle=<leader>p
set showmode

" Rewrap a block of text
noremap <S-Q> gq

" Search for selected text, forwards or backwards.
" Ripped off from vim.wikia.com
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Paste from the clipboard the easy way
set clipboard=unnamedplus

" Full-lowercase searches are case insensitive
set ignorecase
set smartcase

" Save when losing focus
au FocusLost * :wa

" YCM key bindings
nnoremap <leader>o :YcmCompleter GoToInclude<CR>
nnoremap <leader>d :YcmCompleter GoTo<CR>
nnoremap <leader>D :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>def :YcmCompleter GoToDefinition<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap <leader>v :YcmCompleter GetParent<CR>
nnoremap <leader>F :YcmCompleter FixIt<CR>
nnoremap <leader>c :YcmDiags<CR>

" YCM - don't bug me about ycm_extra_conf.py
let g:ycm_confirm_extra_conf = 0

" Add or remove { } around single statement
" Note that this may leave trailing whitespaces, but we don't care because it
" will be handled when saving
nnoremap <leader>+{ <Up><End>a<Space>{<Down><End><CR>}<Esc><Up>
nnoremap <leader>-{ <Up><End><Delete><Down><Down>VD

nnoremap <leader>j :join<CR>

" Apply macros to the visual selection. Doesn't stop on lines that don't match.
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Boilerplate for argument parsing in python
" TODO: get ultisnips or something to actually work...
augroup shorthands
  autocmd!
  :autocmd FileType python :iabbrev <buffer> argparsing from argparse import ArgumentParser<CR>parser = ArgumentParser(description="TODO")<CR>parser.add_argument('-arg', required=False, action='store_true', help="TODO")<CR>args=parser.parse_args()<CR>

  " Boilerplate for launching a subprocess in python
  :autocmd FileType python :iabbrev <buffer> subproc from subprocess import CalledProcessError, check_output, STDOUT, SubprocessError<CR>try:<CR><Tab>out=check_output(command, stderr=STDOUT)<CR>except CalledProcessError as exc:<CR><Tab>raise<CR>except SubprocessError as exc:<CR><Tab>raise RuntimeError("Error while running command\n{}".format(<CR><Tab><Tab>str(exc.output, 'utf-8'))) from exc
augroup end
