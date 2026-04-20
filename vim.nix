{ }:
''
set nocompatible

" Fast startup and predictable defaults.
filetype plugin indent on
syntax on
set encoding=utf-8
set hidden
set history=1000
set undofile
set updatetime=250
set timeout
set timeoutlen=400
set ttimeout
set ttimeoutlen=10
set lazyredraw
set ttyfast

" Terminal-friendly editing.
set backspace=indent,eol,start
set mouse=
set ruler
set showcmd
set number
set scrolloff=4
set sidescrolloff=8
set splitbelow
set splitright
set signcolumn=yes

" Search and completion.
set ignorecase
set smartcase
set incsearch
set hlsearch
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noselect

" Whitespace and tabs.
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smarttab

" Safer files and persistent state.
set nobackup
set nowritebackup
set directory^=$HOME/.vim/swap//
set backupdir^=$HOME/.vim/backup//
set undodir^=$HOME/.vim/undo//

" Better diffs and command-line completion noise.
set diffopt+=vertical,algorithm:histogram,indent-heuristic
set shortmess+=c
set nrformats-=octal

if has('mouse_sgr')
  set ttymouse=sgr
endif

if has('clipboard')
  set clipboard=unnamedplus
endif

if !isdirectory(expand('$HOME/.vim/swap'))
  call mkdir(expand('$HOME/.vim/swap'), 'p')
endif
if !isdirectory(expand('$HOME/.vim/backup'))
  call mkdir(expand('$HOME/.vim/backup'), 'p')
endif
if !isdirectory(expand('$HOME/.vim/undo'))
  call mkdir(expand('$HOME/.vim/undo'), 'p')
endif

" Manual fallback if terminal paste escapes ever misbehave.
set pastetoggle=<F2>

nnoremap <leader><space> :nohlsearch<CR>
nnoremap Y y$
''
