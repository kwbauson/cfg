pkgs: with pkgs; with mylib;
let
  nleFunc = let nixpkgs = pkgs; in
    { path ? ./., pkgs ? nixpkgs }:
    import ./nix-local-env.nix { inherit pkgs path; };
  pkg = (nleFunc { }).overrideAttrs (_: { inherit passthru; });
  passthru = rec {
    __functor = _: nleFunc;
    lib = rec {
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
          nix flake update
          git status &> /dev/null
        fi
      '';
    };
    conf = mapAttrs (n: v: v // { enable = true; }) (fixSelfWith (import ./nle.nix) { source = ./.; inherit pkgs; });
  };
in
latestWrapper (override pkg { name = "nle"; })
