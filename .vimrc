set scrolloff=8
set number
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
" set clipboard+=unnamedplus
let mapleader = " "

syntax enable

"~~~~~~~~~ Plugins ~~~~~~~~~~~~

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'

Plug 'sainnhe/everforest'

" lsp
Plug 'neovim/nvim-lspconfig' 
Plug 'prettier/vim-prettier', { 'do': 'npm install --legacy-peer-deps', 'for': ['javascript', 'typescript', 'css', 'json', 'markdown'] }
Plug 'jiangmiao/auto-pairs'

" ts/js plugins
Plug 'maxmellon/vim-jsx-pretty'

" svelte
Plug 'evanleck/vim-svelte', {'branch': 'main'}

call plug#end()

"~~~~~~~~~ Color schemes ~~~~~~~~~~~

" colorscheme everforest

" Seoul Dark settings
" range: 233(darkest) - 239(lightest)
" let g:seoul256_background = 234
" color seoul256
" set background=dark

" Seoul Light settings
" range: 252(darkest) - 256(lightest)
let g:seoul256_background = 256
color seoul256
set background=light

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" opens file explorer in vertical split
nnoremap <leader>pv :Vex <CR>

" linting and syntax settings
" format on save with Prettier
augroup prettier_fmt
    autocmd!
    autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx PrettierAsync
augroup END

"~~~~~~~~~~ LSP settings ~~~~~~~~~~~~
" Tell lspconfig to initialize the svelte server
lua << EOF
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.cmd[[set completeopt+=menuone,noselect,popup]]
-- typescript-tools.nvim is faster than the ts language server. github.com/pmizio/typescript-tools.nvim

-- ty settings. More here https://docs.astral.sh/ty/reference/editor-settings/
vim.lsp.config['ty'] = {
    settings = {
        runtime = {
            version = "LuaJIT",
            },
        showSyntaxErrors = true,
        inlayHints = {
            variableTypes = true,
            callArgumentNames = true,
            },
        completions = {
            autoImport = true,
            completeFunctionParentheses = true,
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
-- vim.lsp.config['svelte'] = {
--     on_attach = function(client, bufnr)
--      vim.lsp.completion.enable(true, client.id, bufnr, {
--         autotrigger = true,
--         convert = function(item)
--          return { abbr = item.label:gsub('%b()', '') }
--         end,
--         })
--      end,
--     }
vim.lsp.codelens.enable(true)
vim.lsp.inlay_hint.enable(true)
vim.lsp.enable({'ty', 'svelte'})
vim.lsp.log.set_level('ERROR')
EOF
