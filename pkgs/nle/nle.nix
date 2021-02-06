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
    generated = "node-packages.nix";
    extraFiles = ".npmrc";
    notFiles = "yarn.nix";
    out =
      let
        node-packages = callPackage (file "node-packages.nix") { inherit nodeEnv; };
        args = node-packages.args // {
          src = buildDir (map file (words self.npm.files));
          dontNpmInstall = true;
        };
      in
      override (nodeEnv.buildNodeDependencies args) { name = "node_modules"; };
  };
  yarn = {
    files = "package.json yarn.lock";
    generated = "yarn.nix";
    extraFiles = ".npmrc";
  };
  pip = {
    enable = true;
    files = "requirements.txt";
    extraFiles = "requirements.dev.txt";
    notFiles = self.poetry.files;
    out =
      (mach-nix.mkPython {
        requirements = excludeLines (hasPrefix "itomate") ''
          ${read "requirements.txt"}
          ${read "requirements.dev.txt"}
        '';
        overridesPost = [ (self: super: { inherit (python3Packages) black; }) ];
      }).override { ignoreCollisions = true; };
  };
  poetry = {
    enable = true;
    files = "pyproject.toml poetry.lock";
    out = poetry2nix.mkPoetryEnv {
      projectDir = source;
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
