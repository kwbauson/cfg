scope: with scope;
importPackage rec {
  inherit pname;
  version = "0-unstable-2025-10-28";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "3dd024dc2cbf5b7097e38c0fceac2690d8353e69";
    hash = "sha256-fsz6M50kat/MW/UK62KPZzhCGyMXROXjRY6eHga6w0E=";
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
    mkCmdlineMap = action: fallback: lib.mkRaw ''{
      function (cmp)
        if vim.fn.getcmdtype() ~= ':' then
          return cmp.${action}()
        end
      end,
      "${fallback}",
    }'';
    bg = "#202020"; # overall background color from colorscheme
    oneline = text: concatStringsSep " " (filter isString (builtins.split "[[:space:]]+" text));
  };

  configuration = fix (cfg: {
    performance = {
      byteCompileLua.enable = true;
      byteCompileLua.configs = true;
      byteCompileLua.initLua = true;
      byteCompileLua.luaLib = true;
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
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      cursorlineopt = "number";
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
      " d" = "<cmd>Bdelete<cr>";
      "g." = "<cmd>lua require('fastaction').code_action()<cr>";
      gd = "<cmd>Telescope lsp_definitions<cr>";
      gt = "<cmd>Telescope lsp_type_definitions<cr>";
      ge = "<cmd>Telescope diagnostics<cr>";
      "[e" = "<cmd>lua vim.diagnostic.jump({ count = -1, severity = 'error' })<cr>";
      "]e" = "<cmd>lua vim.diagnostic.jump({ count =  1, severity = 'error' })<cr>";
      " t" = "<cmd>Telescope<cr>";
      " p" = "<cmd>Telescope find_files hidden=true<cr>";
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
      K = lib.oneline ''<cmd>lua
        vim.lsp.buf.hover({
          focus = false,
          anchor_bias = 'above',
          close_events = { 'CursorMoved', 'ModeChanged', 'WinLeave', 'BufLeave' },
        })
      <cr>'';
    };
    lsp.servers = {
      nil_ls.enable = true; # FIXME switch to nixd?
      nil_ls.config.settings.nil.formatting.command = [ "nixpkgs-fmt" ];
      ts_ls.enable = true;
      ts_ls.config.on_attach = lib.mkRaw ''function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
      end'';
      jsonls.enable = true;
      basedpyright.enable = true;
      ruff.enable = true;
      bashls.enable = true;
      terraformls.enable = true;
      biome.enable = true;
    };
    plugins = {
      lspconfig.enable = true;
      none-ls.enable = true;
      none-ls.sources = {
        code_actions.gitsigns.enable = true;
      };
      conform-nvim.enable = true;
      conform-nvim.settings.format_on_save.lsp_format = "fallback";
      conform-nvim.package = vimPlugins.conform-nvim.overrideAttrs (old: {
        postInstall = ''
          ${old.postInstall}
          rm $out/doc/recipes.md
        '';
      });
      treesitter.enable = true;
      treesitter.nixvimInjections = false;
      treesitter.settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      blink-cmp.enable = true;
      blink-cmp.settings = {
        sources.default = [ "lsp" ];
        completion.list.selection.preselect = false;
        completion.documentation.auto_show = true;
        completion.documentation.auto_show_delay_ms = 50;
        completion.menu.draw.treesitter = [ "lsp" ];
        signature.enabled = true;
        signature.window.show_documentation = true;
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
        style_preset = lib.mkRaw "require('bufferline').style_preset.no_italic";
        tab_size = 0;
        truncate_names = false;
        diagnostics = "nvim_lsp";
        name_formatter =
          let
            names = [
              "default.nix"
              "shell.nix"
              "configuration.nix"
              "darwin-configuration.nix"
              "index.html"
              "index.css"
              "index.ts"
              "index.tsx"
            ];
          in
          lib.mkRaw ''function(buf)
            if ${concatMapStringsSep " or " (n: "buf.name == '${n}'") names} then
              return buf.path:match("([^/]+/[^/]+)$")
            else
              return buf.name
            end
          end'';
      };
      web-devicons.enable = true;
      lualine.enable = true;
      lualine.settings.options.globalstatus = true;
      lualine.settings.options.refresh.statusline = 200;
      lualine.settings.sections.lualine_b = [ "branch" "diff" ];
      lualine.settings.sections.lualine_x = [
        { __unkeyed-1 = "lsp_status"; ignore_lsp = [ "null-ls" ]; }
        {
          __unkeyed-1 = "diagnostics";
          sources = [ "nvim_workspace_diagnostic" ];
          sections = [ "hint" "info" "warn" "error" ];
          update_in_insert = true;
        }
        { __unkeyed-1 = "filetype"; icon_only = true; }
      ];
      bufdelete.enable = true;
      gitsigns.enable = true;
      comment.enable = true;
      comment.settings.toggler.block = "gcb";
      telescope.enable = true;
      telescope.extensions.fzf-native.enable = true;
      telescope.extensions.undo.enable = true;
      telescope.settings.defaults = {
        mappings = {
          i."<esc>" = lib.mkRaw "require('telescope.actions').close";
          i."<c-f>" = lib.mkRaw "require('telescope.actions').preview_scrolling_down";
          i."<c-b>" = lib.mkRaw "require('telescope.actions').preview_scrolling_up";
          i."<c-u>" = false;
        };
        file_ignore_patterns = [ "^.git/" ];
        sorting_strategy = "ascending";
        layout_config.prompt_position = "top";
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
        session_number = 4;
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
