config: with config.lib; {
  sources = [ ];
  imported._replace = foldl' (a: x: a // import' x) { } config.sources;

  nixpkgs = with config; {
    config = tryImport "config.nix" { };
    overlays = imported.overlays or [ ];
    pkgs = import nixpkgs.path {
      inherit (nixpkgs) system config overlays;
    };
  };

  bundler = with config; {
    enable = hasAttrs [ "Gemfile" "Gemfile.lock" "gemset" ] imported;
    build = nixpkgs.pkgs.bundlerEnv;
    settings = {
      name = "bundler-env";
      gemfile = imported.Gemfile;
      lockfile = imported."Gemfile.lock";
      gemset = imported.gemset;
    };
  };

  outputs =
    let build = n: cfg:
      if cfg.enable or false then (cfg.build cfg.settings).overrideAttrs (_: { name = "${n}-env"; }) else null;
    in filterAttrs (n: v: v != null) (mapAttrs build (config // { outputs = null; paths = null; }));
  paths._replace = attrValues config.outputs;
}
