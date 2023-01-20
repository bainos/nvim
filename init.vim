" Ctrl+b to insert backtick in insert mode
" imap <C-b> `

" Disable mouse
set mouse=

" Don't try to be vi compatible
set nocompatible

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Colors
highlight ColorColumn ctermbg=grey

" Whitespace
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
hi Visual ctermbg=darkgrey
set nowrap
" set colorcolumn=80
set formatoptions=tcqrn1
set expandtab
set noshiftround
set tabstop=2
set shiftwidth=2
set softtabstop=2
" au BufNewFile,BufRead *.py
"     \ set tabstop=4 |
"     \ set softtabstop=4 |
"     \ set shiftwidth=4 |
"     \ set expandtab |
"     \ set autoindent |
"     \ set fileformat=unix |

" Set the compiler for Python files to pylint
" autocmd FileType python compiler pylint

" Enable folding
set foldmethod=indent
set foldlevel=99
noremap <space> za

" Cursor motion
set scrolloff=5
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
" nnoremap j gj
" nnoremap k gk
" map <C-\> :NERDTreeToggle<CR>

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

lua require("plugins").setup()
