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
    'EdenEast/nightfox.nvim',
    {
        'NLKNguyen/papercolor-theme',
        lazy = false,
        priority = 1000,
        config = function()
          vim.opt.termguicolors = true
          vim.opt.background = "dark"
          vim.cmd.colorscheme('PaperColor')
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
    },

    {
      "sphamba/smear-cursor.nvim",

      opts = {
        -- Smear cursor when switching buffers or windows.
        smear_between_buffers = true,

        -- Smear cursor when moving within line or to neighbor lines.
        -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
        smear_between_neighbor_lines = true,

        -- Draw the smear in buffer space instead of screen space when scrolling
        scroll_buffer_space = true,

        -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
        -- Smears and particles will look a lot less blocky.
        legacy_computing_symbols_support = false,

        -- Smear cursor in insert mode.
        -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
        smear_insert_mode = true,
      },
    }
})

