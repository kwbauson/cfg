scope: with scope;
importPackage rec {
  inherit pname;
  version = "0-unstable-2025-05-06";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "391e4fd093eaa993089525da2648cc2b4ec380ce";
    hash = "sha256-Fe56SJiucdw2Jpa1Wt7PJ9rasdTqSSvZPJnqkIp/T7E=";
  };
  passthru.updateScript = unstableGitUpdater { };
  flake = import src;
  package = flake.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = configuration;
  };
  inherit (package) extend;

  lib = flake.lib.nixvim // {
    mkKeyMaps = mapAttrsToList (
      key: value: { inherit key; } // (
        if !isString value then value else {
          action = value;
          options.silent = true;
          mode = [ "n" "x" "v" "s" ];
        }
      )
    );
    mkCmdlineMap = action: fallback: lib.mkRaw /* lua */ ''{
      function (cmp)
        if vim.fn.getcmdtype() ~= ':' then
          return cmp.${action}()
        end
      end,
      "${fallback}",
    }'';
    bg = "#202020"; # overall background color from colorscheme
  };

  configuration = fix (cfg: {
    performance = {
      byteCompileLua.enable = true;
      byteCompileLua.configs = true;
      byteCompileLua.initLua = true;
      byteCompileLua.nvimRuntime = true;
      byteCompileLua.plugins = true;
      combinePlugins.enable = true;
    };
    colorschemes.vscode.enable = true;
    opts = rec {
      number = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = shiftwidth;
      softtabstop = shiftwidth;
      signcolumn = "yes:1";
      title = true;
      backup = false;
      writebackup = false;
      hidden = true;
      undofile = true;
      mouse = "";
      wrap = false;
      smartcase = true;
    };
    highlight.NormalFloat.bg = replaceStrings [ "2" ] [ "4" ] lib.bg; # lighter than bg
    highlight.Pmenu = cfg.highlight.NormalFloat;
    keymaps = lib.mkKeyMaps {
      "<c-p>" = { mode = "c"; action = "<up>"; };
      "<c-n>" = { mode = "c"; action = "<down>"; };
      gh = "<cmd>BufferLineCyclePrev<cr>";
      gl = "<cmd>BufferLineCycleNext<cr>";
      gH = "<cmd>BufferLineMovePrev<cr>";
      gL = "<cmd>BufferLineMoveNext<cr>";
      gb = "<cmd>BufferLinePick<cr>";
      " d" = "<cmd>bdelete!<cr>";
      "g." = "<cmd>lua require('fastaction').code_action()<cr>";
      gd = "<cmd>Telescope lsp_definitions<cr>";
      " t" = "<cmd>Telescope<cr>";
      " p" = "<cmd>Telescope find_files<cr>";
      " g" = "<cmd>Telescope live_grep<cr>";
      " G" = "<cmd>Telescope grep_string<cr>";
      " b" = "<cmd>Telescope buffers<cr>";
      " r" = "<cmd>Telescope lsp_references<cr>";
      " u" = "<cmd>Telescope undo<cr>";
      " s" = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
      ";w" = "<cmd>HopCamelCase<cr>";
      ";l" = "<cmd>HopLineStart<cr>";
      " e" = "<cmd>NvimTreeFindFileToggle!<cr>";
      "<c-space>" = { mode = [ "i" "c" ]; action = "<cmd>lua require('blink.cmp').show()<cr>"; };
    };
    plugins = {
      lsp.enable = true;
      lsp.servers = {
        nil_ls.enable = true; # FIXME switch to nixd?
        nil_ls.settings.formatting.command = [ "nixpkgs-fmt" ];
        ts_ls.enable = true;
        basedpyright.enable = true;
      };
      none-ls.enable = true;
      none-ls.sources.formatting.prettierd.enable = true;
      none-ls.sources.formatting.prettierd.disableTsServerFormatter = true;
      none-ls.sources.code_actions.gitsigns.enable = true;
      lsp-format.enable = true;
      treesitter.enable = true;
      treesitter.nixvimInjections = false;
      treesitter.settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      blink-cmp.enable = true;
      blink-cmp.settings = {
        completion.list.selection.preselect = false;
        completion.documentation.auto_show = true;
        completion.documentation.auto_show_delay_ms = 50;
        completion.menu.draw.treesitter = [ "lsp" ];
        signature.enabled = true;
        keymap.preset = "none";
        keymap."<c-p>" = lib.mkCmdlineMap "select_prev" "fallback_to_mappings";
        keymap."<c-n>" = lib.mkCmdlineMap "select_next" "fallback_to_mappings";
        keymap."<tab>" = [ "select_next" "fallback" ];
        keymap."<s-tab>" = [ "select_prev" "fallback" ];
        keymap."<c-b>" = [ "scroll_documentation_up" "fallback" ];
        keymap."<c-f>" = [ "scroll_documentation_down" "fallback" ];
        keymap."<c-k>" = [ "show_signature" "hide_signature" "fallback" ];
        cmdline.keymap.preset = "inherit";
        cmdline.completion.list.selection.preselect = false;
        cmdline.completion.menu.auto_show = true;
      };
      tiny-inline-diagnostic.enable = true;
      tiny-inline-diagnostic.settings.options.show_all_diags_on_cursorline = true;
      bufferline.enable = true;
      bufferline.settings.options = {
        show_buffer_close_icons = false;
        indicator.style = "underline";
      };
      web-devicons.enable = true;
      lualine.enable = true;
      lualine.settings.options.globalstatus = true;
      gitsigns.enable = true;
      comment.enable = true;
      comment.settings.toggler.block = "gcb";
      telescope.enable = true;
      telescope.extensions.fzf-native.enable = true;
      telescope.extensions.undo.enable = true;
      telescope.settings.defaults.mappings = {
        i."<esc>" = lib.mkRaw "require('telescope.actions').close";
        i."<c-f>" = lib.mkRaw "require('telescope.actions').preview_scrolling_down";
        i."<c-b>" = lib.mkRaw "require('telescope.actions').preview_scrolling_up";
        i."<c-u>" = false;
      };
      nvim-tree.enable = true;
      # explicit package to resolve combinePlugins conflict
      nvim-tree.package = vimPlugins.nvim-tree-lua.overrideAttrs (old: {
        postInstall = ''
          ${old.postInstall}
          rm $out/doc/.gitignore
        '';
      });
      scrollview.enable = true;
      scrollview.settings.signs_max_per_row = 0;
      colorful-menu.enable = true;
      lastplace.enable = true;
      fugitive.enable = true;
      startify.enable = true;
      startify.settings = {
        fortune_use_unicode = true;
        session_persistence = true;
        lists = [
          { type = "sessions"; header = [ "   Sessions" ]; }
          { type = "dir"; header = [ (lib.mkRaw "'   MRU ' .. vim.loop.cwd()") ]; }
        ];
        session_number = 2;
        files_number = 10 - cfg.plugins.startify.settings.session_number;
      };
      which-key.enable = true;
      hop.enable = true;
      hop.settings.uppercase_labels = true;
      fastaction.enable = true;
      fastaction.settings.dismiss_keys = [ "<esc>" "q" ];
      notify.enable = true;
      notify.settings.background_colour = lib.bg;
    };
    extraPackages = [ nixpkgs-fmt ];
    extraConfigLua = /* lua */ ''
      -- from https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes/#lsp-messages
      -- table from lsp severity to vim severity.
      local severity = {
        "error",
        "warn",
        "info",
        "info", -- map both hint and info to info?
      }
      vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
        vim.notify(method.message, severity[params.type])
      end
    '';
  });
}
