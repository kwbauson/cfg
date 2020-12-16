pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = let env = nle { path = ./.; }; in
    [ (alias name env.pkgs.nix-local-env) env ];
} // rec {
  __functor = let nixpkgs = pkgs; in
    _: { path, pkgs ? nixpkgs }:
      import ./nix-local-env.nix { inherit pkgs path; };
  lib = rec {
    build-files = words ''
      bin nix local.nix
      flake.nix flake.lock default.nix
      package.json package-lock.json node-packages.nix
      Gemfile Gemfile.lock gemset.nix
      requirements.txt requirements.dev.txt
    '';
    build-paths = path: filter pathExists (map (p: path + "/${p}") build-files);
  };
  scripts = makeScripts {
    update = with scripts; ''
      ${exe update-python}
    '';
    update-python = ''
      [[ -e requirements.txt ]] && ${exe pur} -zfr requirements.txt
      [[ -e requirements.dev.txt ]] && ${exe pur} -zfr requirements.dev.txt
      true
    '';
    print-pin = echo ''
      {
        outPath = ${cfg.outPath};
      }
    '';
  };
}
