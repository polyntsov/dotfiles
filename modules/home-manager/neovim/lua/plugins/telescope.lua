local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    find_command = {
      'ag', '--hidden',
      '--ignore-dir', '.local',
      '--ignore-dir', '.git',
      '--ignore-dir', '.mozilla',
      '--ignore-dir', '.thunderbird',
      '--ignore-dir', '.dotfiles',
      '--ignore-dir', '.cache',
      '--ignore-dir', '.jj',
      '-g', '',
    },
  })
end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
