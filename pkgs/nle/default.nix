scope: with scope;
let
  build = let nixpkgs = pkgs; in
    { path, pkgs ? nixpkgs, source ? null }:
    import ./nix-local-env.nix { inherit pkgs path source; };
  joinMapAttrValuesIf = f: p: as: concatMapStringsSep "\n" f (attrValues (filterAttrs (n: v: p n) as));
  scripts = makeScripts {
    update = ''
      set -e
      ${joinMapAttrValuesIf nr (hasPrefix "update-") scripts}
    '';
    update-npm = ''
      ${pathAdd [ nodejs_latest nodePackages.npm-check-updates ]}
      if [[ -e package.json && package-lock.json ]];then
        if ! ncu -e2;then
          ncu -u
        fi
        rm package-lock.json
        if [[ -L node_modules ]];then
          unlink node_modules
        fi
        npm --package-lock-only i
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
        nix flake update
        git status &> /dev/null
      fi
    '';
  };
  conf = mapAttrs (n: v: v // { enable = true; }) (fixSelfWith (import ./nle.nix) { source = ./.; inherit pkgs; });
  passthru = rec { inherit build scripts; };
  pkg = override (build { path = ./.; }) {
    name = "nle";
    passthru = { inherit build scripts; };
  };
in
latestWrapper name pkg // { inherit scripts; }
