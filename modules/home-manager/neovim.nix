{ config, scope, isMinimal, ... }: with scope;
{
  imports = [
    nixvim.flake.homeManagerModules.nixvim
    { programs.nixvim = nixvim.configuration; }
  ];

  programs.nixvim = {
    # enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
  };

  included-packages = optionalAttrs (!isMinimal) {
    inherit nixpkgs-fmt shellcheck vim-language-server lua-language-server;
    inherit typescript-language-server;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    ${attrIf (!isMinimal) "extraPackages"} = attrValues { inherit nil lua-language-server; };
    plugins = with vimPlugins; attrValues {
      inherit
        # core
        nvim-scrollview quick-scope vim-code-dark tcomment_vim
        vim-better-whitespace vim-lastplace vim-multiple-cursors vim-sensible
        vim-peekaboo
        # project stuff
        vim-startify git-conflict-nvim vim-fugitive vim-airline
        nvim-web-devicons patched-barbar-nvim
        # programming
        formatter-nvim nvim-lspconfig telescope-nvim;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      treesitter-koka = neovimUtils.grammarToPlugin tree-sitter-grammars.tree-sitter-koka;
      inherit fzf-vim; # FIXME telescope-nvim
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.vim
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.lua
    ";
  };
}
