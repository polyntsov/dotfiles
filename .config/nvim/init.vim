set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" LSP stuff
Plugin 'nvim-lua/plenary.nvim'
Plugin 'neovim/nvim-lspconfig'
Plugin 'hrsh7th/nvim-cmp'
Plugin 'hrsh7th/cmp-nvim-lsp'
Plugin 'saadparwaiz1/cmp_luasnip'
Plugin 'L3MON4D3/LuaSnip'
Plugin 'ray-x/lsp_signature.nvim'

" colorscheme
Plugin 'sjl/badwolf'
Plugin 'dguo/blood-moon', {'rtp': 'applications/vim'}
Plugin 'rebelot/kanagawa.nvim'
Plugin 'Mofiqul/vscode.nvim'
Plugin 'martinsione/darkplus.nvim'

" Auto closing parenthesis
Plugin 'rstacruz/vim-closer'

call vundle#end()            " required
filetype plugin indent on    " required

" LSP settings {{{

lua << EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- luasnip setup
local luasnip = require 'luasnip'
local async = require "plenary.async"

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  --completion = {
  --  autocomplete = false
  --},
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = '👻 '
    }, bufnr)  -- Note: add in lsp client on-attach
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'pyright', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

"}}}

" General settings {{{
syntax on
let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " True gui colors in terminal
set termguicolors
set nocursorline
set cursorlineopt=number
set tabstop=4   " How many columns of whitespace a \t is worth
set shiftwidth=4
set nowrap
set hlsearch    " Highlight founded words
set expandtab   " Use spaces when tabbing
set splitbelow         " Always split below
set list listchars=tab:▸·,trail:·,extends:> " invisible symbols
set keymap=russian-jcukenwin
set number
set mouse=a
set iminsert=0
set imsearch=0
set cinoptions=(0,+1s,:0,=2s,>s,c1s,g2s,h2s,j1,l1,m1,p2s,t0,u0,w1
set noswapfile
set colorcolumn=101
set scrolloff=7
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"}}}

" auto close { and add semicolon if needed
"function! s:CloseBracket()
"    let line = getline('.')
"    if line =~# '^\s*\(struct\|class\|enum\) '
"        return "{\<Enter>};\<Esc>O"
"    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
"        " Probably inside a function call. Close it off.
"        return "{\<Enter>});\<Esc>O"
"    else
"        return "{\<Enter>}\<Esc>O"
"    endif
"endfunction
"inoremap <expr> {<Enter> <SID>CloseBracket()

" refresh file when it's changed
set autoread
if ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(1000,'CheckUpdate')
endfunction

"refresh vimrc after exiting it
autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw

" usable undo
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.cache/.nvim/undo  "directory where the undo files will be stored
endif

" colorscheme
colorscheme vscode

nnoremap // :noh<esc>
