call plug#begin("~/.vim/plugged")
Plug 'fholgado/minibufexpl.vim'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()

" The Basics
set number
set magic       " Make regexes work nicely
set mouse=c     " Command-line mode
syntax on
let g:python3_host_prog = '/home/alandu/miniconda3/envs/neovim/bin/python'
let g:miniBufExplModSelTarget = 1

" Color Scheme
let g:gruvbox_contrast_dark = "none"
set termguicolors
hi Normal ctermbg=none
colorscheme gruvbox
let g:airline_theme = "gruvbox"

set statusline^=%{coc#status()}


" Tab settings
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=8
set scrolloff=5
set autoindent
set updatetime=300
filetype plugin indent on

" Keybindings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Use ENTER to use the default completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gD <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gR <Plug>(coc-rename)
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <leader>r <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OrgImports :call CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>;  :<C-u>CocList commands<cr>

" Spellcheck
set spelllang=en
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
