set backspace=indent,eol,start
set nocompatible
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" Enable code folding
set foldenable
set foldmethod=manual
set foldopen-=search
set foldopen-=undo

" Set options
set backup
set backupdir=~/.vim/backup,/tmp
set dir=~/.vim/swap,/tmp

set smartindent 
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set backspace=2
set foldmethod=marker
set clipboard=unnamed

set hidden
set history=50
set ruler
set showcmd
set relativenumber
set number 
set incsearch
set ignorecase
set laststatus=2
set noshowmode
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
inoremap <C-U> <C-G>u<C-U>

if has('mouse')
  set mouse=a
endif

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

" Autocommands
if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
  au!
  autocmd BufReadPost *
   \ if line("'\"") > 1 && line("'\"") <= line("$") |
   \   exe "normal! g`\"" |
   \ endif
  augroup END
else 
  set autoindent
endif 
