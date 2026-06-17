set scrolloff=8
set number
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
" set clipboard+=unnamedplus

syntax enable


call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'junegunn/seoul256.vim'

Plug 'sainnhe/everforest'

" lsp
Plug 'neovim/nvim-lspconfig' 
Plug 'prettier/vim-prettier', { 'do': 'npm install --legacy-peer-deps', 'for': ['javascript', 'typescript', 'css', 'json', 'markdown'] }
Plug 'jiangmiao/auto-pairs'

" ts/js plugins
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'

" svelte
Plug 'othree/html5.vim'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

call plug#end()

" Color scheme
colorscheme everforest
" let g:seoul256_background = 236
" color seoul256
" set background=dark

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

" LSP settings
" Tell lspconfig to initialize the svelte server
lua << EOF
vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.lsp.config['ty'] = {
    settings = {
        runtime = {
            version = "LuaJIT",
            },
        inlayHints = {
            variableTypes = true
            }
        },
    on_attach = function(client, bufnr)
     vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
         return { abbr = item.label:gsub('%b()', '') }
        end,
        })
     end,
    }
vim.lsp.config['svelte'] = {
    on_attach = function(client, bufnr)
     vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
         return { abbr = item.label:gsub('%b()', '') }
        end,
        })
     end,
    }
vim.lsp.enable({'ty', 'svelte'})
vim.lsp.inlay_hint.enable(true)
EOF
