{ scope, ... }: with scope;
{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    extraConfig = readFile ./init.vim;
    coc.enable = true;
    plugins = with {
      plugins = with vimPlugins; {
        inherit
          conflict-marker-vim fzf-vim nvim-scrollview quick-scope
          tcomment_vim vim-airline
          # vim-better-whitespace
          vim-code-dark vim-easymotion vim-fugitive vim-lastplace
          vim-multiple-cursors vim-peekaboo vim-polyglot vim-sensible
          vim-startify vim-vinegar barbar-nvim nvim-web-devicons

          coc-eslint coc-git coc-json coc-lists coc-prettier
          coc-solargraph coc-tsserver coc-pyright coc-explorer
          coc-vetur
          ;
      };
      makeExtraPlugins = map (n: vimUtils.buildVimPlugin { inherit (sources.${n}) pname version src; });
    }; attrValues plugins
      ++ makeExtraPlugins [ "jsonc.vim" "vim-anyfold" ]
      ++ optional (!isDarwin) vimPlugins.vim-devicons;
    extraLuaConfig = ''
      require'barbar'.setup {
        animation = false,
        auto_hide = false,
        tabpages = true,
        icons = {
          filetype = {custom_colors = true},
          button = false,
          modified = { button = false},
        },
        insert_at_end = true,
        maximum_padding = 0,
      }
    '';
  };
}
