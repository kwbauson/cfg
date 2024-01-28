local nmap = function(lhs, rhs)
  vim.keymap.set('n', lhs, rhs)
end

local nmappings = function(mappings)
  for lhs, rhs in pairs(mappings) do
    nmap(lhs, rhs)
  end
end

require 'barbar'.setup {
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

require 'nvim-treesitter.configs'.setup {
  auto_install = false,
  sync_install = false,
  ensure_installed = {},
  ignore_install = { "all" },
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
  modules = {},
}

require 'formatter'.setup {
  filetype = {
    terraform = {
      require 'formatter.filetypes.terraform'.terraformfmt,
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

require 'which-key'.setup {
  plugins = {
    presets = {
      g = false,
    },
  },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.max_width = opts.max_width or 120
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require 'neodev'.setup {}
local lspconfig = require 'lspconfig'
lspconfig.pyright.setup {}
lspconfig.ruff_lsp.setup {}
require 'typescript-tools'.setup {}
lspconfig.nim_langserver.setup {}
lspconfig.nil_ls.setup {}
lspconfig.typos_lsp.setup {}
lspconfig.lua_ls.setup {}

nmappings {
  -- navigation/info
  gd = vim.lsp.buf.definition,
  gD = vim.lsp.buf.declaration,
  gh = vim.lsp.buf.hover,
  gi = function()
    vim.diagnostic.open_float(nil, {})
  end,
  ge = vim.diagnostic.goto_next,
  gE = vim.diagnostic.goto_prev,
  ['g<C-e>'] = vim.diagnostic.setloclist,
  ['<C-k>'] = vim.lsp.buf.signature_help,
  ['g<C-d>'] = vim.lsp.buf.type_definition,
  gr = vim.lsp.buf.references,
  gI = '<cmd>LspInfo<cr>',
  -- actions
  ['<space>e'] = vim.lsp.buf.rename,
  ['<space>wa'] = vim.lsp.buf.add_workspace_folder,
  ['<space>wr'] = vim.lsp.buf.remove_workspace_folder,
  ['<space>wl'] = function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end,
  ['<space>f'] = function()
    vim.lsp.buf.format { async = true }
  end,
  ['<space>a'] = vim.lsp.buf.code_action,
}
