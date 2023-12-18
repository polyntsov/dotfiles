local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

-- And now the plugins themselves
require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- LSP stuff
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'ray-x/lsp_signature.nvim',

    -- colorscheme
    'sjl/badwolf',
    'dguo/blood-moon',
    'rebelot/kanagawa.nvim',
    {
        'Mofiqul/vscode.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme vscode]])
        end,
    },
    'martinsione/darkplus.nvim',

    -- Auto closing parenthesis
    --'rstacruz/vim-closer',
    'windwp/nvim-autopairs',

    -- Usable buffers,
    'nvim-tree/nvim-web-devicons',
    'romgrk/barbar.nvim',

    -- File explorer
    'nvim-tree/nvim-tree.lua',
})
