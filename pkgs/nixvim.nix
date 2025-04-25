scope: with scope;
importPackage rec {
  inherit pname;
  version = "0-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "a21504f2b084e7e1c5da09ca5cc87791d2564f3b";
    hash = "sha256-Ig9m38EL6gZHwqKS89401Eooe/Zi9CqQsaehVlf1wcQ=";
  };
  passthru.updateScript = unstableGitUpdater { };
  flake = import src;
  package = flake.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = configuration;
  };

  lib = flake.lib.nixvim // {
    mkKeyMaps = mapAttrsToList (
      key: value: { inherit key; } // (
        if !isString value then value else {
          action = value;
          options.silent = true;
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
  };

  configuration = {
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
    };
    keymaps = lib.mkKeyMaps {
      "<C-p>" = { mode = "c"; action = "<up>"; };
      "<C-n>" = { mode = "c"; action = "<down>"; };
      gh = ":BufferLineCyclePrev<cr>";
      gl = ":BufferLineCycleNext<cr>";
      gH = ":BufferLineMovePrev<cr>";
      gL = ":BufferLineMoveNext<cr>";
      gb = ":BufferLinePick<cr>";
      " p" = ":Telescope find_files<cr>";
      " d" = ":bdelete!<cr>";
    };
    plugins = {
      bufferline.enable = true;
      bufferline.settings.options.show_buffer_close_icons = false;
      web-devicons.enable = true;
      lualine.enable = true;
      treesitter.enable = true;
      treesitter.settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      lsp.enable = true;
      lsp.servers = {
        nil_ls.enable = true; # FIXME switch to nixd?
        nil_ls.settings.formatting.command = [ "nixpkgs-fmt" ];
        ts_ls.enable = true;
      };
      lsp-format.enable = true;
      gitsigns.enable = true;
      comment.enable = true;
      comment.settings.toggler.block = "gcb";
      telescope.enable = true;
      nvim-tree.enable = true;
      scrollview.enable = true;
      blink-cmp.enable = true;
      blink-cmp.settings = {
        signature.enabled = true;
        completion.documentation.auto_show = true;
        completion.documentation.auto_show_delay_ms = 50;
        keymap."<Tab>" = [ "select_and_accept" "fallback" ];
        keymap."<C-l>" = lib.mkCmdlineMap "select_and_accept" "fallback";
        keymap."<C-p>" = lib.mkCmdlineMap "select_prev" "fallback_to_mappings";
        keymap."<C-n>" = lib.mkCmdlineMap "select_next" "fallback_to_mappings";
        cmdline.keymap.preset = "inherit";
        cmdline.completion.menu.auto_show = true;
      };
      lastplace.enable = true;
      fugitive.enable = true;
      startify.enable = true;
      startify.settings = {
        fortune_use_unicode = true;
        session_persistence = true;
        lists = [
          { type = "sessions"; header = [ "   Sessions" ]; }
          { type = "dir"; header = [{ __raw = "'   MRU' .. vim.loop.cwd()"; }]; }
          { type = "files"; header = [ "   MRU" ]; }
          { type = "bookmarks"; header = [ "   Bookmarks" ]; }
          { type = "commands"; header = [ "   Commands" ]; }
        ];
      };
      which-key.enable = true;
    };
    extraConfigLua = ''
      vim.o.winborder = "rounded"
    '';
    extraPackages = [ nixpkgs-fmt ];
  };
}
