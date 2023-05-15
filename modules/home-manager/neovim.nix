{ config, scope, ... }: with scope;
{
  included-packages = {
    inherit ctags dhall crystal nim nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = attrValues { inherit nimlsp nil solargraph terraform-ls lua-language-server; };
    withNodeJs = true;
    coc.enable = true;
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify barbar-nvim nvim-web-devicons vim-peekaboo

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur coc-vimlsp;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/init.vim
      source ${config.home.homeDirectory}/cfg/init.lua
    ";
  };
}
