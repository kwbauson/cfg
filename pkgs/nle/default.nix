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
      yarn.lock npm-package.nix npm-deps.nix
      Gemfile Gemfile.lock gemset.nix
      requirements.txt requirements.dev.txt
    '';
    build-paths = path: filter pathExists (map (p: path + "/${p}") build-files);
    joinMapAttrValuesIf = f: p: as: concatMapStringsSep "\n" f (attrValues (filterAttrs (n: v: p n) as));
  };
  scripts = with lib; makeScripts {
    update = joinMapAttrValuesIf nr (hasPrefix "update-") scripts;
    update-npm = ''
      if [[ -e package.json && package-lock.json ]];then
        if ! ${nr nodePackages.npm-check-updates} -e2;then
          ${nr nodePackages.npm-check-updates} -u
          ${nr nodePackages.npm} --package-lock-only i
        fi
      fi
    '';
    update-python = ''
      [[ -e requirements.txt ]] && ${nr pur} -zfr requirements.txt || true
      [[ -e requirements.dev.txt ]] && ${nr pur} -zfr requirements.dev.txt || true
    '';
    update-flake = ''
      ${pathAdd [ git nix-wrapped ]}
      if [[ -e flake.nix && -e flake.lock ]];then
        git status &> /dev/null
        nix flake update --recreate-lock-file
        git status &> /dev/null
      fi
    '';
    pin = echo ''
      {
        outPath = ${cfg.outPath};
      }
    '';
  };
}
