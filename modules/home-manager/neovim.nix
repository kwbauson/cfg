{ config, scope, isMinimal, ... }: with scope;
{
  included-packages = optionalAttrs (!isMinimal) {
    inherit ctags dhall crystal nim2 nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    ${attrIf (!isMinimal) "extraPackages"} = attrValues { inherit nil solargraph terraform-ls lua-language-server terraform; };
    withNodeJs = true;
    coc.enable = isLinux; # FIXME
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify nvim-web-devicons vim-peekaboo vim-caddyfile unison
        vim-slime patched-barbar-nvim

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur coc-vimlsp formatter-nvim nim-vim;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      treesitter-koka = neovimUtils.grammarToPlugin tree-sitter-grammars.tree-sitter-koka;
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.vim
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.lua
    ";
  };
}
