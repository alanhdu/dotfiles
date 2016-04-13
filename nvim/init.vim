let g:python_host_prog='/usr/bin/python'    "Avoid virtualenv/conda problems

"vundle stuff
call plug#begin("~/.vim/plugged")

Plug 'fholgado/minibufexpl.vim'
Plug 'tpope/vim-sensible'
Plug 'ntpeters/vim-better-whitespace'

Plug 'Valloric/YouCompleteMe', {'for': ['python', 'rust', 'c', 'cpp']}
Plug 'rdnetto/YCM-Generator', {'branch': 'stable', 'for': ['c', 'cpp']}

Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}

call plug#end()

filetype plugin indent on

let g:ycm_rust_src_path='/home/alan/workspace/rust/src'

"minibufexpl stuff
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

nnoremap <C-J> <C-W><C-J>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

set number
set magic       " Make regexes work nicely
set mouse=c     " Command-line mode

syntax on
colorscheme custom

" Default tab settings
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=8

set autoindent

autocmd Filetype python setlocal expandtab
    \ textwidth=79
    \ shiftwidth=4
    \ tabstop=4
autocmd Filetype c setlocal noexpandtab
    \ softtabstop=8
    \ shiftwidth=8
    \ tabstop=8
