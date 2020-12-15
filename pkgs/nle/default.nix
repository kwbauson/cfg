pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = let env = nle { path = ./.; }; in
    [ (alias name env.pkgs.nix-local-env) env ];
} // {
  __functor = let nixpkgs = pkgs; in
    self: { path, pkgs ? nixpkgs }:
      import ./nix-local-env.nix { inherit pkgs path; };
  scripts = makeScripts {
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
