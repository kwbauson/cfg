scope: with scope;
let
  refspec = "refs/notes/${pname}";
  build = { flake, refs, postBuild ? "" }:
    let
      pathsAttrs = listToAttrs (map
        (ref: {
          name = concatStringsSep "." ref;
          value = (getAttrFromPath ref flake.packages.${system}).outPath;
        })
        refs);
      sourceHash = getDrvHash flake;
      flakeBuild = writeTextFile {
        name = "source";
        destination = "/flake.nix";
        text = builtins.unsafeDiscardStringContext /* nix */ ''
          {
            outputs = { self }:
              let
                p = builtins.storePath;
              in
              {
                ${concatMapAttrsStringSep "\n      " (n: p:
                "${n} = p ${p};"
                ) pathsAttrs}
              };
          }
        '';
      };
      flakeHash = getDrvHash flakeBuild;
      links = linkFarmOfHashes "${pname}-links"
        ([ flakeBuild ] ++ map (ref: getAttrFromPath ref flake.packages.${system}) refs);
      push = writeBash "push-cached-refs" ''
        set -xeuo pipefail
        git fetch origin ${refspec}:${refspec}
        git notes --ref=${pname} add --force --message test
        git push origin ${refspec}
      '';
    in
    runCommandLocal "${sourceHash}-${flakeHash}" { } ''
      mkdir -p $out
      ln -s ${links} $out/.${links.name}
      ln -s ${push} $out/.push-${pname}
      ${postBuild}
    '';
in
(writeBashBin pname ''
  set -euo pipefail
  ${pathAdd [ curl jq ]}

  if [[ $1 = -v ]];then
    set -x && shift
  fi

  repo=$1 && shift

  cd "$repo"

  if [[ $1 = --clean ]];then
    git update-ref -d ${refspec}
    exit
  fi

  cache=$1 && shift
  pin=$1 && shift

  cmd=$1 && shift
  flake=$1 && shift
  installable=$1 && shift

  storePath=$(
    curl -s https://app.cachix.org/api/v1/cache/"$cache"/pin |
      jq -r ".[] | select(.name == \"$pin\") | .lastRevision.storePath"
  )
  cachedSourceHash=''${storePath:44:32}
  cachedFlakeHash=''${storePath:77:32}

  sourceStorePath=$(nix flake metadata --no-warn-dirty --json "$flake" | jq -r .path)
  sourceHash=''${sourceStorePath:11:32}

  if [[ $sourceHash = $cachedSourceHash ]];then
    flake=/nix/store/$cachedFlakeHash-source
    impure=--impure
    if [[ ! -e "$flake" ]];then
      nix build --no-link "$flake"
    fi
  else
    impure=
  fi

  exec nix "$cmd" $impure "$flake"#"$installable" "$@"
'').overrideAttrs (old: {
  meta = old.meta // { includePackage = true; };
  passthru = { inherit build; };
})
