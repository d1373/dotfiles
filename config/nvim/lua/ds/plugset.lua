local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})

