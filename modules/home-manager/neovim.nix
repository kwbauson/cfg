{ config, scope, isMinimal, ... }: with scope;
{
  included-packages = optionalAttrs (!isMinimal) {
    inherit ctags dhall crystal nim2 nixpkgs-fmt shellcheck shfmt black;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    ${attrIf (!isMinimal) "extraPackages"} = attrValues { inherit nil solargraph terraform-ls lua-language-server terraform; } ++ optional (!isDarwin) nimlangserver;
    withNodeJs = true;
    coc.enable = true;
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify nvim-web-devicons vim-peekaboo vim-caddyfile unison
        vim-slime

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur coc-vimlsp formatter-nvim nim-vim;
      nvim-treesitter = nvim-treesitter.withAllGrammars;
      barbar-nvim = barbar-nvim; # FIXME barbar-nvim.overrideAttrs (attrs: { patches = attrs.patches or [ ] ++ [ ./barbar-show-parent-option.patch ]; });
      vim-ohm = vimUtils.buildVimPlugin rec {
        pname = "vim-ohm";
        version = "0-unstable-2017-10-31";
        src = fetchFromGitHub {
          owner = "nfischer";
          repo = pname;
          rev = "76d7cf8f4a131158c4bdde7698bb46bd4d69451f";
          hash = "sha256-F9FU2Cvutf3v3GZiw3NqXL4mBbQ9VxY4goZ+4eQKEl4=";
        };
      };
      peggy-vim = vimUtils.buildVimPlugin rec {
        pname = "peggy-vim";
        version = "0-unstable-2022-02-26";
        src = fetchFromGitHub {
          owner = "TheGrandmother";
          repo = pname;
          rev = "e41bece5776a8a30c8b5e9cfd041cec362f0b494";
          hash = "sha256-oCZr2r1T3M+M2mecDwtxJDTekIs+3wOPhVKhFsgWi54=";
        };
      };
    };
    extraConfig = "
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.vim
      source ${config.home.homeDirectory}/cfg/modules/home-manager/init.lua
    ";
  };
}
