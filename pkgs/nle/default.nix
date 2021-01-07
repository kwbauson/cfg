pkgs: with pkgs; with mylib; buildEnv {
  inherit name;
  paths = let env = nle { path = ./.; }; in
    [ (alias name env.pkgs.nix-local-env) env ];
} // rec {
  __functor =
    let
      nixpkgs = pkgs;
      f = { path, pkgs ? nixpkgs }: import ./nix-local-env.nix { inherit pkgs path; };
    in
    _: arg: if isAttrs arg then f arg else f { path = arg; };
  lib = rec {
    build-files = unique (
      flatten (mapAttrsToList (n: v: words "${v.files or ""} ${v.extraFiles or ""} ${v.generated or ""}") conf)
    );
    build-paths = path: filter pathExists (map (p: path + "/${p}") build-files);
    joinMapAttrValuesIf = f: p: as: concatMapStringsSep "\n" f (attrValues (filterAttrs (n: v: p n) as));
  };
  scripts = with lib; makeScripts {
    update = joinMapAttrValuesIf nr (hasPrefix "update-") scripts;
    update-npm = ''
      ${pathAdd [ nodejs_latest nodePackages.npm-check-updates ]}
      if [[ -e package.json && package-lock.json ]];then
        if ! ncu -e2;then
          ncu -u
          npm --package-lock-only i
        fi
      fi
    '';
    update-python = ''
      ${pathAdd [ pur coreutils dasel poetry ]}
      [[ -e requirements.txt ]] && pur -zfr requirements.txt || true
      [[ -e requirements.dev.txt ]] && pur -zfr requirements.dev.txt || true
      [[ -e pyproject.toml && -e poetry.lock ]] &&
        dasel -f pyproject.toml .tool.poetry.dependencies |
        cut -d' ' -f1 |
        grep -v python |
        sed 's/$/:latest/' |
        xargs poetry add --lock
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
  conf = mapAttrs (n: v: v // { enable = true; }) {
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
    pip = {
      files = "requirements.txt";
      extraFiles = "requirements.dev.txt";
    };
    poetry = {
      files = "pyproject.toml poetry.lock";
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
  };
}
