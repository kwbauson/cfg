{ self, source, pkgs }: with pkgs; with mylib; with self.lib; {
  lib = {
    file = f: source + ("/" + f);
    fileExistBools = fs: map pathExists (words fs);
    read = f:
      let p = file f; in optionalString (pathExists p) (readFile p);
    matches =
      { enable ? false
      , files ? ""
      , extraFiles ? ""
      , generated ? ""
      , ...
      }: enable && all (fileExistBools "${files} ${generated}") || any (fileExistBools extraFiles);
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
    notFiles = "yarn.lock";
    out = npmlock2nix.node_modules {
      pname = "node_modules";
      version = "0.0.0";
      src = buildDir (map file (words self.npm.files));
    };
  };
  yarn = {
    files = "package.json yarn.lock .enable-nle-yarn";
    generated = "yarn.nix";
    extraFiles = ".npmrc";
  };
  pip = {
    enable = true;
    files = "requirements.txt";
    extraFiles = "requirements.dev.txt";
    notFiles = self.poetry.files;
    out = override
      (inputs.mach-nix.lib.${system}.mkPython {
        ignoreDataOutdated = true;
        ignoreCollisions = true;
        requirements = excludeLines (hasPrefix "itomate") ''
          ${read "requirements.txt"}
          ${read "requirements.dev.txt"}
        '';
        _.curtsies.patches = [ ];
      })
      { name = "pip-env"; };
  };
  poetry = {
    enable = true;
    files = "pyproject.toml poetry.lock";
    out = poetry2nix.mkPoetryEnv {
      projectDir = buildDir (map file (words self.poetry.files));
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
  bundler = {
    enable = true;
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
