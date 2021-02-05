config: with config.lib; {
  lib = builtins // {
    file = p: config.source + "/${p}";
    tryImport = p: nul:
      let f = file p; in
      if config ? source && pathExists f
      then import f else nul;
  };
  # imports = tryImport "nle-config.nix" { };
  nixpkgs = {
    config = tryImport "config.nix" { };
    overlays = tryImport "overlays.nix" [ ];
    pkgs = import config.nixpkgs.path {
      inherit (config.nixpkgs) system config overlays;
    };
  };
}
