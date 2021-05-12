config: with config.lib; {
  sources = [ ];

  nixpkgs = {
    config = tryImport "config.nix" { };
    overlays = tryImport "overlays.nix" [ ];
    pkgs = import config.nixpkgs.path {
      inherit (config.nixpkgs) system config overlays;
    };
  };

  bundler = {
    enable = all hasFile [ "Gemfile" "Gemfile.lock" "gemset.nix" ];
    build = config.nixpkgs.pkgs.bundlerEnv;
    settings = {
      name = "bundler-env";
      gemfile = tryFile "Gemfile";
      lockfile = tryFile "Gemfile.lock";
      gemset = tryFile "gemset.nix";
    };
  };

  outputs =
    let build = n: cfg:
      if cfg.enable or false then (cfg.build cfg.settings).overrideAttrs (_: { name = "${n}-env"; }) else null;
    in filterAttrs (n: v: v != null) (mapAttrs build (config // { outputs = null; paths = null; }));
  paths._replace = attrValues config.outputs;
}
