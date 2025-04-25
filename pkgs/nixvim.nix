scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "a21504f2b084e7e1c5da09ca5cc87791d2564f3b";
    hash = "sha256-Ig9m38EL6gZHwqKS89401Eooe/Zi9CqQsaehVlf1wcQ=";
  };
  passthru.updateScript = unstableGitUpdater { };
  flake = import attrs.src;
  package = attrs.flake.legacyPackages.${system}.makeNixvim attrs.configuration;

  configuration = {
    colorschemes.vscode.enable = true;
    plugins = {
      bufferline.enable = true;
      bufferline.settings.options.show_buffer_close_icons = false;
      web-devicons.enable = true;
      lualine.enable = true;
      treesitter.enable = true;
    };
  };
})
