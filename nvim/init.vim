let g:ycm_python_binary_path = 'python3'

call plug#begin("~/.vim/plugged")

Plug 'scrooloose/syntastic'

Plug 'fholgado/minibufexpl.vim'
Plug 'ntpeters/vim-better-whitespace'

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', {'branch': 'stable', 'for': ['c', 'cpp']}

Plug 'mindriot101/vim-yapf', {'for': ['python']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'elixir-lang/vim-elixir', {'for': ['elixir']}
Plug 'fatih/vim-go', {'for': ['go']}
Plug 'pangloss/vim-javascript', {'for': ['javascript']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}
Plug 'vim-ruby/vim-ruby', {'for': ['ruby']}

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
autocmd Filetype ruby setlocal expandtab
    \ tabstop=2
    \ shiftwidth=2
    \ textwidth=79
autocmd Filetype cpp setlocal noexpandtab
    \ shiftwidth=2
    \ tabstop=2
    \ textwidth=79
