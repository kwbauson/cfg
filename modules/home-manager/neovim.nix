{ config, scope, ... }: with scope;
{
  included-packages = {
    inherit ctags dhall crystal nim nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = attrValues { inherit nimlsp nil solargraph terraform-ls; } ++ optionals isLinux [ lua-language-server ];
    withNodeJs = true;
    coc.enable = true;
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify nvim-web-devicons vim-peekaboo vim-caddyfile

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur coc-vimlsp;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      barbar-nvim = barbar-nvim.overrideAttrs (attrs: { patches = attrs.patches or [ ] ++ [ ./barbar-show-parent-option.patch ]; });
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/init.vim
      source ${config.home.homeDirectory}/cfg/init.lua
    ";
  };
}
