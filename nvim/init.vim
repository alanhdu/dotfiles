let g:python_host_prog='/usr/bin/python'    "Avoid virtualenv/conda problems

"vundle stuff
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'tpope/vim-sensible'
Plugin 'ntpeters/vim-better-whitespace'

Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

Plugin 'nvie/vim-flake8'
Plugin 'rust-lang/rust.vim'

call vundle#end()

filetype plugin indent on

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

autocmd BufWritePost *.py call Flake8()
autocmd Filetype python setlocal expandtab
    \ textwidth=79
    \ shiftwidth=4
    \ tabstop=4
autocmd Filetype c setlocal noexpandtab
    \ softtabstop=8
    \ shiftwidth=8
    \ tabstop=8
