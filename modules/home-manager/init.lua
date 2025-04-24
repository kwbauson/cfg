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

vim.filetype.add({
  extension = {
    kk = "koka",
  },
})

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


vim.lsp.config('lua_ls', {
  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("koka")
vim.lsp.enable("metals")
vim.lsp.enable("ts_ls")
vim.lsp.enable("purescriptls")
vim.lsp.enable("sourcekit")
