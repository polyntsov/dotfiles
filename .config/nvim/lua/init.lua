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
    'Mofiqul/vscode.nvim',
    'martinsione/darkplus.nvim',
    'folke/tokyonight.nvim',
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
          require('nightfox').setup({
              options = {
                  transparent = false,
              }
          })

          vim.cmd.colorscheme('carbonfox')
          vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg='None' })
        end
    },

    -- Auto closing parenthesis
    --'rstacruz/vim-closer',
    'windwp/nvim-autopairs',

    -- Usable buffers,
    'nvim-tree/nvim-web-devicons',
    'romgrk/barbar.nvim',

    -- File explorer
    'nvim-tree/nvim-tree.lua',

    -- Hop
    {
        'smoka7/hop.nvim',
        version = "v2.5.0",
        opts = {},
    }
})
