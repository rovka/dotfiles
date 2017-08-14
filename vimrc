" Necessary for listchars to work in all environments.
scriptencoding utf-8
set encoding=utf-8

" Fix webpack watch.
set backupcopy=yes

" OSX you so silly
set backspace=2

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

" Enable pathogen.
try
  execute pathogen#infect()
catch
endtry

syntax enable

" Wombat!
let g:airline_theme='wombat'

" Tab length.
set tabstop=2
set sw=2
set sts=2

" Expand tab to spaces.
set expandtab

" Line length.
set tw=80
set wrap

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
set cindent
set cinkeys-=0#
set indentkeys-=0#

" Load indentation rules and plugins according to detected filetype.
" Also required by pathogen.
filetype plugin indent on

" Per filetype-settings
" c/cpp modified by Deedee to match LLVM coding style
autocmd FileType c,cpp      setlocal tw=80 sw=2 sts=2 tabstop=2
autocmd FileType java       setlocal foldmethod=marker
autocmd FileType python     setlocal expandtab
autocmd FileType php        setlocal tw=80 sw=4 sts=4 tabstop=4
autocmd FileType html       setlocal tw=0 cc=101 nowrap
autocmd FileType javascript setlocal sw=2 sts=2
autocmd FileType coffee     setlocal sw=4 sts=4 tabstop=4

" -ro: Don't insert comment leader when explicitly startling a new line.
" +1: Try to break a line before the last one letter word.
autocmd FileType * set fo-=r fo-=o fo+=1

" Enable JSDoc syntax highlighting
let g:javascript_plugin_jsdoc = 1

" Remove trailing whitespaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Productivity shortcuts.
imap jk <Esc>
imap jj <Esc><Down>
imap kk <Esc><Up>
imap ggg <Esc>gg

nnoremap J <C-D>
nnoremap K <C-U>

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
map <S-Q> gq

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
set clipboard=unnamed

" Apply macros to the visual selection. Doesn't stop on lines that don't match.
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
