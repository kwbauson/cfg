{ config, scope, ... }: with scope;
{
  included-packages = {
    inherit ctags dhall crystal nim2 nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = attrValues { inherit nil solargraph terraform-ls lua-language-server terraform; };
    withNodeJs = true;
    coc.enable = true;
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify nvim-web-devicons vim-peekaboo vim-caddyfile unison

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur coc-vimlsp formatter-nvim;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      barbar-nvim = barbar-nvim.overrideAttrs (attrs: { patches = attrs.patches or [ ] ++ [ ./barbar-show-parent-option.patch ]; });
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.vim
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.lua
    ";
  };
}
