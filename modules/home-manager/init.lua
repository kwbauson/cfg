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

local api = vim.api
local fn = vim.fn
local group_id = api.nvim_create_augroup("KeithTest", {})

local create_callback = function()
  local not_started = true
  local channel
  local on_change = function()
    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    fn.chansend(channel, lines)
  end

  return function()
    if not_started then
      channel = fn.jobstart({ "/home/keith/cfg/modules/home-manager/buftest.rb" }, {
        on_stdout = function(_, data)
          if data then
            api.nvim_buf_set_lines(0, 0, -1, false, data)
          end
        end,
      })

      api.nvim_create_autocmd({ 'CursorMoved', 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
        group = group_id,
        callback = on_change,
      })
    else
      api.nvim_clear_autocmds({ group = group_id })
      fn.jobstop(channel)
    end
    not_started = not not_started
  end
end

api.nvim_create_user_command('KeithTest', create_callback(), {})
