require('barbar').setup {
  animation = false,
  auto_hide = false,
  tabpages = true,
  icons = {
    filetype = { custom_colors = true },
    button = false,
    modified = { button = false },
  },
  insert_at_end = true,
  maximum_padding = 0,
}
require('nvim-treesitter.configs').setup {
  auto_install = false,
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
}
