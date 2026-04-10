scope: with scope;
let
  build = { flake, refs, postBuild ? "" }:
    let
      pathsAttrs = listToAttrs (map
        (ref: {
          name = concatStringsSep "." ref;
          value = (getAttrFromPath ref flake.packages.${system}).outPath;
        })
        refs);
      flakeText = builtins.unsafeDiscardStringContext /* nix */ ''
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
      getDrvHash = drv: substring 11 32 (builtins.unsafeDiscardStringContext drv.outPath);
      sourceHash = getDrvHash flake;
      flakeBuild = runCommand "flake"
        {
          passAsFile = [ "flakeText" ];
          inherit flakeText;
        } ''
        mkdir $out
        cp $flakeTextPath $out/flake.nix
      '';
      flakeHash = getDrvHash flakeBuild;
      links = linkFarmFromDrvs
        "${pname}-links"
        ([ flakeBuild ] ++ map (ref: getAttrFromPath ref flake.packages.${system}) refs);
    in
    runCommand "${sourceHash}-${flakeHash}" { } ''
      mkdir -p $out/cached-refs
      ln -s ${links} $out/cached-refs/.links
      touch $out/cached-refs/$(basename ${flakeBuild})
      ${postBuild}
    '';
in
(writeBashBin pname ''
  set -euo pipefail
  ${pathAdd [ curl jq ]}

  if [[ $1 = -v ]];then
    set -x && shift
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
    flake=/nix/store/$cachedFlakeHash-flake
    impure=--impure
    if [[ ! -e "$flake" ]];then
      nix build --no-link "$flake"
    fi
  else
    impure=
  fi

  exec nix "$cmd" $impure "$flake"#"$installable" "$@"
'').overrideAttrs {
  passthru = { inherit build; };
}
