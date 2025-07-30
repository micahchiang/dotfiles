set scrolloff=8
set number
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set background=dark


call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sainnhe/everforest'

" lsp
Plug 'neoclide/coc.nvim', { 'branch': 'release'}

" ts/js plugins
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'quramy/tsuquyomi'

call plug#end()

colorscheme everforest

let mapleader = " "

" opens file explorer in vertical split
nnoremap <leader>pv :Vex <CR>

let g:python_highlight_all=1

" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']
