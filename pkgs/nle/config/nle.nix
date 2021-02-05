config: with config.lib; {
  lib = builtins // {
    file = p: config.source + "/${p}";
    importFile = p: import (file p);
    importFileOr = p: nul: if pathExists (file p) then import (file p) else nul;
  };
  nixpkgs = {
    config = importFileOr "config.nix" { };
    overlays = importFileOr "overlays.nix" [ ];
    pkgs = import config.nixpkgs.path {
      inherit (config.nixpkgs) system config overlays;
    };
  };
}
