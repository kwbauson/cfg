config: with config.lib; {
  lib = (import config.nixpkgs.path { }).lib // builtins // {
    file = p: config.source + "/${p}";
    hasFile = p: tryFile p != null;
    tryFile = p:
      let f = file p; in
      if config ? source && pathExists f then f else null;
    tryRead = p: if tryFile p == null then "" else readFile (tryFile p);
    tryImport = p: nul:
      let f = tryFile p; in if f == null then nul else import f;
    makePaths = attrs:
      if attrs.enable or true
      then if attrs ? paths then attrs else if attrs ? build then attrs // {
        paths = attrs.build attrs.settings or { };
      } else attrs else attrs // { paths = [ ]; };
  };

  nixpkgs = {
    config = tryImport "config.nix" { };
    overlays = tryImport "overlays.nix" [ ];
    pkgs = import config.nixpkgs.path {
      inherit (config.nixpkgs) system config overlays;
    };
  };

  bundler = makePaths {
    enable = all hasFile [ "Gemfile" "Gemfile.lock" "gemset.nix" ];
    build = config.nixpkgs.pkgs.bundlerEnv;
    settings = {
      name = "bundler-env";
      gemfile = tryFile "Gemfile";
      lockfile = tryFile "Gemfile.lock";
      gemset = tryFile "gemset.nix";
    };
  };

  paths._replace = flatten (map (x: x.paths or [ ]) (attrValues (config // { paths = null; })));
}
