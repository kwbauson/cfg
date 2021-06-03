config: with config.lib; {
  sources = [ ];
  imported._replace = foldl' (a: x: a // import' x) { } config.sources;

  nixpkgs = with config; {
    config =
      if imported ? "config.nix"
      then import imported."config.nix"
      else { };
    overlays = imported.overlays or [ ];
    path = config.flake.inputs.nixpkgs.outPath
      or config.niv.sources.nixpkgs.outPath
      or (throw "nixpkgs.path is required");
    pkgs = import nixpkgs.path {
      inherit (nixpkgs) system config overlays;
    };
  };

  bundler = with config; with nixpkgs.pkgs; {
    enable = hasAttrs [ "Gemfile" "Gemfile.lock" "gemset.nix" ] imported;
    generate = optionalString (imported ? Gemfile) ''
      ${bundix}/bin/bundix \
        --gemfile="${imported.Gemfile}" \
        ${if imported ? "Gemfile.lock" then ''--lockfile="${imported."Gemfile.lock"}"'' else "-l"}
    '';
    build = bundlerEnv;
    settings = {
      name = "bundler-env";
      gemfile = imported.Gemfile;
      lockfile = imported."Gemfile.lock";
      gemset = imported.gemset;
    };
  };

  poetry = with config; with nixpkgs.pkgs; {
    enable = hasAttrs [ "pyproject.toml" "poetry.lock" ] imported;
    build = poetry2nix.mkPoetryEnv;
    settings = {
      pyproject = imported."pyproject.toml";
      poetrylock = imported."poetry.lock";
      overrides = poetry2nix.overrides.withoutDefaults (self: super: {
        inform = super.inform.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [ self.pytest-runner ];
        });
        shlib = super.shlib.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [ self.pytest-runner ];
        });
      });
    };
  };

  modules = with config; [
    { _module.args = { inherit (flake) inputs; }; }
    { nixpkgs = { inherit (nixpkgs) config overlays; }; }
  ];

  nixosConfigurations = with config; mapAttrs
    (host: attrs: nixpkgs.pkgs.nixos {
      imports = modules ++ [
        { _module.args = { inherit host; }; }
        (imported.configuration or { })
        (attrs.configuration or { })
      ];
    })
    (imported.hosts or { });

  homeConfigurations = with config; mapAttrs
    (host: attrs:
      let
        fake-home-module.options.home = {
          homeDirectory = mkOption { type = types.str; };
          username = mkOption { type = types.str; };
        };
        home-modules = modules ++ [
          { _module.args = { inherit host; }; }
          (imported.home or { })
          (attrs.home or { })
        ];
        fake-config = (evalModules { modules = [ fake-home-module ] ++ home-modules; }).config;
      in
      flake.inputs.home-manager.lib.homeManagerConfiguration {
        inherit (config.nixpkgs) system;
        inherit (fake-config.home) homeDirectory username;
        configuration = { imports = home-modules; };
      }
    )
    (imported.hosts or { });

  outputs =
    let build = n: cfg:
      if cfg.enable or false then (cfg.build cfg.settings).overrideAttrs (_: { name = "${n}-env"; }) else null;
    in filterAttrs (n: v: v != null) (mapAttrs build (config // { outputs = null; paths = null; }));

  paths._replace = attrValues config.outputs;
}
