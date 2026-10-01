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

" Colorschemes
Plug 'junegunn/seoul256.vim'
Plug 'sainnhe/everforest'
Plug 'rose-pine/neovim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'prettier/vim-prettier', { 'do': 'npm install --legacy-peer-deps', 'for': ['javascript', 'typescript', 'css', 'json', 'markdown'] }
Plug 'jiangmiao/auto-pairs'

" completion
" use a release tag to download pre-built binaries. To build from source instead, use { 'do': 'cargo build --release' }
Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
Plug 'rafamadriz/friendly-snippets'

" ts/js plugins
Plug 'maxmellon/vim-jsx-pretty'

" svelte
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" treesitter (better highlighting + needed for autotag)
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }
Plug 'windwp/nvim-ts-autotag'

call plug#end()

"~~~~~~~~~ Color schemes ~~~~~~~~~~~

" colorscheme everforest
" colorscheme rose-pine
 colorscheme rose-pine-moon
" colorscheme rose-pine-dawn

" Seoul Dark settings
" range: 233(darkest) - 239(lightest)
 " let g:seoul256_background = 235
 " color seoul256
 " set background=dark

" Seoul Light settings
" range: 252(darkest) - 256(lightest)
" let g:seoul256_background = 256
" color seoul256
" set background=light

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" opens file explorer in vertical split
nnoremap <leader>pv :Vex <CR>

" linting and syntax settings
" format on save with Prettier
augroup prettier_fmt
    autocmd!
    autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx PrettierAsync
augroup END

"~~~~~~~~~~ LSP / completion settings ~~~~~~~~~~~~
" Each `-----` section below is self-contained lua and can be lifted verbatim
" into its own file (e.g. lua/config/completion.lua, lua/config/lsp.lua)
" when this migrates to a lua-based config.
lua << EOF
----------------------------------------------------------------------
-- keymaps / options
----------------------------------------------------------------------
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.cmd[[set completeopt+=menuone,noselect,popup]]

----------------------------------------------------------------------
-- completion (blink.cmp)
----------------------------------------------------------------------
require('blink.cmp').setup({
    -- 'super-tab' = tab to accept, like VS Code's IntelliSense.
    -- 'default' instead gives vim-native-style mappings (C-y to accept).
    keymap = { preset = 'super-tab' },
    appearance = {
        nerd_font_variant = 'mono',
        },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },
    signature = { enabled = true },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    fuzzy = {
        implementation = 'prefer_rust_with_warning',
        },
    })

----------------------------------------------------------------------
-- LSP servers
----------------------------------------------------------------------
-- note: blink.cmp automatically merges its LSP capabilities into
-- vim.lsp.config('*', ...) on load (nvim 0.11+), so no manual
-- capabilities/on_attach wiring is needed here for completion to work.

-- ty settings. More here https://docs.astral.sh/ty/reference/editor-settings/
vim.lsp.config['ty'] = {
    settings = {
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
    }

vim.lsp.codelens.enable(true)
vim.lsp.inlay_hint.enable(true)
vim.lsp.enable({
    'ty', 'svelte',
    'vtsls', 'html', 'cssls', 'jsonls', 'eslint', 'emmet_language_server',
    })

-- VS Code-style squiggles + inline messages
vim.diagnostic.config({ virtual_text = true })

-- gd isn't mapped to LSP by default
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

----------------------------------------------------------------------
-- treesitter + auto close/rename tags
----------------------------------------------------------------------
-- pcall so a fresh install (before :PlugInstall) doesn't error on startup
local ok_ts, ts = pcall(require, 'nvim-treesitter')
if ok_ts then
    ts.install({
        'html', 'css', 'javascript', 'typescript', 'tsx', 'svelte', 'json', 'python', 'lua',
        })
end
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
    })
local ok_tag, autotag = pcall(require, 'nvim-ts-autotag')
if ok_tag then autotag.setup() end
vim.lsp.log.set_level('ERROR')
EOF
