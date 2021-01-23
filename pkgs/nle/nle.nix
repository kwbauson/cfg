{ source, pkgs }: with pkgs; with mylib; rec {
  lib = {
    file = f: source + ("/" + f);
  };

  bin = {
    files = "bin";
  };
  niv = {
    files = "nix";
  };
  npm = {
    files = "package.json package-lock.json";
    extraFiles = ".npmrc";
    notFiles = "yarn.nix";
    generated = "node-packages.nix";
  };
  yarn = {
    files = "package.json yarn.lock";
    extraFiles = ".npmrc";
    generated = "yarn.nix";
  };
  pip = rec {
    files = "requirements.txt";
    extraFiles = "requirements.dev.txt";
    read = f: optionalString (pathExists (lib.file f)) (readFile (lib.file f));
    out = mach-nix.mkPython {
      requirements = ''
        ${excludeLines (hasPrefix "itomate") (read "requirements.txt")}
        ${read "requirements.dev.txt"}
      '';
      _.black.buildInputs = [ ];
      _.${attrIf isDarwin "lazy-object-proxy"}.buildInputs = [ ];
    };
  };
  poetry = {
    files = "pyproject.toml poetry.lock";
    out = poetry2nix.mkPoetryEnv {
      projectDir = source;
      overrides = poetry2nix.overrides.withDefaults (self: super: {
        inform = super.inform.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [ self.pytest-runner ];
        });
        shlib = super.shlib.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [ self.pytest-runner ];
        });
      });
    };
  };
  bundler = {
    files = "Gemfile Gemfile.lock";
    generated = "gemset.nix";
  };
  nix = {
    extraFiles = "default.nix flake.nix flake.lock local.nix";
  };
  nixpkgs = {
    extraFiles = "config.nix overlays.nix";
  };
  pkgs = {
    files = "pkgs";
  };
}
