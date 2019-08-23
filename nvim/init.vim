call plug#begin("~/.vim/plugged")

Plug 'fholgado/minibufexpl.vim'
Plug 'ntpeters/vim-better-whitespace'

" Use tab for trigger completion with characters ahead and navigate.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Go-tos
nmap <silent> gD <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)<Paste>

Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'elixir-lang/vim-elixir', {'for': ['elixir']}
Plug 'HerringtonDarkholme/yats.vim', {'for': ['typescript']}
Plug 'fatih/vim-go', {'for': ['go']}
Plug 'fsharp/vim-fsharp', {'for': ['fsharp'], 'do': 'make fsautocomplete'}
Plug 'mindriot101/vim-yapf', {'for': ['python']}
Plug 'ambv/black', {'for': ['python']}
Plug 'pangloss/vim-javascript', {'for': ['javascript']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}
Plug 'vim-ruby/vim-ruby', {'for': ['ruby']}


call plug#end()

filetype plugin indent on

let g:python3_host_prog = '/opt/anaconda/envs/neovim/bin/python'
au BufRead,BufNewFile *.pyi set filetype=python

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
colorscheme slate

" Default tab settings
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=8
set scrolloff=5

set autoindent

autocmd Filetype python setlocal expandtab
    \ textwidth=79
    \ shiftwidth=4
    \ tabstop=4
autocmd Filetype ruby setlocal expandtab
    \ tabstop=2
    \ shiftwidth=2
    \ textwidth=79

autocmd Filetype cpp setlocal expandtab
    \ textwidth=79
    \ shiftwidth=2
    \ tabstop=2
autocmd Filetype c setlocal expandtab
    \ textwidth=79
    \ shiftwidth=2
    \ tabstop=2

autocmd Filetype javascript setlocal expandtab
    \ textwidth=79
    \ shiftwidth=2
    \ tabstop=2
autocmd Filetype css setlocal expandtab
    \ textwidth=79
    \ shiftwidth=2
    \ tabstop=2
autocmd Filetype html setlocal expandtab
    \ textwidth=79
    \ shiftwidth=2
    \ tabstop=2
