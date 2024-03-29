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
  always_show_parent = {
    "default.nix",
    "configuration.nix",
    "home.nix",
    "main.tf",
    "vars.tf",
    "variables.tf",
    "outputs.tf",
    "output.tf",
    "terragrunt.hcl",
    "local.nix",
  }
}

require('nvim-treesitter.configs').setup {
  auto_install = false,
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
}

require('formatter').setup {
  filetype = {
    terraform = {
      require("formatter.filetypes.terraform").terraformfmt,
    },
    hcl = {
      function()
        return {
          exe = "terraform",
          args = { "fmt", "-" },
          stdin = true,
        }
      end
    },
  }
}
