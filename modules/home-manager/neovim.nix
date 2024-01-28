{ config, scope, ... }: with scope;
{
  included-packages = {
    inherit ctags dhall crystal nim nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = attrValues {
      inherit nil solargraph terraform-ls lua-language-server terraform nimlangserver pyright typescript ruff-lsp typos-lsp;
    };
    withNodeJs = true;
    plugins = with vimPlugins; attrValues {
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      inherit nvim-lspconfig formatter-nvim which-key-nvim;
      barbar-nvim = withPatch barbar-nvim ./barbar-show-parent-option.patch;
      neode-nvim = withPatch neodev-nvim ./neodev-always-enable.patch;
      # extra languages
      inherit vim-caddyfile unison typescript-tools-nvim;
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors
        vim-startify nvim-web-devicons vim-peekaboo;
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.vim
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.lua
    ";
  };
}
