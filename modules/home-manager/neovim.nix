{ scope, ... }: with scope;
{
  programs.neovim = {
    enable = true;
    package = neovim-unwrapped.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        (fetchpatch {
          name = "use-the-correct-replacement-args-for-gsub-directive.patch";
          url = "https://github.com/neovim/neovim/commit/ccc0980f86c6ef9a86b0e5a3a691f37cea8eb776.patch";
          hash = "sha256-sZWM6M8jCL1e72H0bAc51a6FrH0mFFqTV1gGLwKT7Zo=";
        })
      ];
    });
    withNodeJs = true;
    coc.enable = true;
    plugins = with vimPlugins; attrValues {
      inherit
        conflict-marker-vim fzf-vim nvim-scrollview quick-scope tcomment_vim
        vim-airline vim-better-whitespace vim-code-dark vim-easymotion
        vim-fugitive vim-lastplace vim-multiple-cursors vim-sensible
        vim-startify barbar-nvim nvim-web-devicons nvim-FeMaco-lua vim-peekaboo

        coc-eslint coc-git coc-json coc-lists coc-prettier
        coc-solargraph coc-tsserver coc-pyright coc-explorer
        coc-vetur;
      nvim-treesitter = nvim-treesitter.withAllGrammars.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          (fetchpatch {
            name = "injections-nix-dynamic-language-injection-via-comments.patch";
            url = "https://github.com/nvim-treesitter/nvim-treesitter/pull/4658/commits/49d018d0b43ae260a5f182e090ad816c50edb3e4.patch";
            hash = "sha256-+pUQ+opKub3oy5t/KD1Qgwn6avieFeMANq+MZqNQpNc=";
          })
        ];
      });
    };
    extraLuaConfig = /* lua */ ''
      require'barbar'.setup {
        animation = false,
        auto_hide = false,
        tabpages = true,
        icons = {
          filetype = {custom_colors = true},
          button = false,
          modified = {button = false},
        },
        insert_at_end = true,
        maximum_padding = 0,
      }
      require'nvim-treesitter.configs'.setup {
        auto_install = false,
        highlight = {enable = true},
        incremental_selection = {enable = true},
        indent = {enable = true},
      }
      require'femaco'.setup {}
    '';
    extraConfig = readFile ./init.vim;
  };
}
