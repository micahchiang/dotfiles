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

" linting and syntax
Plug 'dense-analysis/ale'
Plug 'prettier/vim-prettier', { 'do': 'npm install --legacy-peer-deps', 'for': ['javascript', 'typescript', 'css', 'json', 'markdown'] }
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

" linting and syntax settings
let b:ale_fixers = ['prettier', 'eslint']
let g:ale_fix_on_save = 1
let g:prettier#autoformat = 1
let g:python_highlight_all=1
" format on save with Prettier
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx PrettierAsync

" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

