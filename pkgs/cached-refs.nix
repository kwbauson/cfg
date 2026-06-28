scope: with scope;
let
  build = { flake, refs, bucket, endpoint_url, postBuild ? "" }:
    let
      sourceHash = getDrvHash flake;
      refsJson = (formats.json { }).generate "cached-refs.json" (map
        (ref: {
          path = concatStringsSep "." ref;
          attrs = let pkg = getAttrFromPath ref flake; in toPretty { multiline = false; } {
            # a type attr makes the json serialization just a store path
            attrsType = pkg.type;
            outPath = unsafeDiscardStringContext pkg.outPath;
            drvPath = unsafeDiscardStringContext pkg.drvPath;
            inherit (pkg) name outputName;
            ${attrIf (pkg.meta ? mainProgram) "meta"} = { inherit (pkg.meta) mainProgram; };
          };
        })
        refs);
      push = writePython3Bin "${pname}-push"
        { doCheck = false; libraries = ps: [ ps.boto3 ]; } /* python */
        ''
          import boto3, json
          s3 = boto3.client(
              service_name="s3",
              endpoint_url="${endpoint_url}",
              region_name="auto",
          )
          with open("${refsJson}") as f:
              for item in json.load(f):
                  print('Pushing', item["path"])
                  s3.put_object(
                      Key=f"${sourceHash}/{item["path"]}",
                      Body=item["attrs"].replace("attrsType", "type"),
                      Bucket="${bucket}",
                  )
        '';
    in
    runCommandLocal "${pname}-build" { passthru = { inherit refsJson push; }; } ''
      mkdir -p $out/bin
      ln -s ${push}/bin/* $out/bin
      ${postBuild}
    '';
in
(writeBashBin pname ''
  set -euo pipefail
  ${pathAdd [ curl ]}

  if [[ $1 = -v ]];then
    set -x && shift
  fi
  force=
  if [[ $1 = -f ]];then
    force=1 && shift
  fi

  flake=$1 && shift
  ref=$1 && shift
  cmd=$1 && shift

  if [[ $force != 1 ]];then
    sourceStorePath=$(nix flake metadata --no-warn-dirty --json "$flake" | jq -r .path)
    sourceHash=''${sourceStorePath:11:32}

    # FIXME make this not hard coded
    baseUrl=https://pub-404f73faa0964c73b37ec30873b983bc.r2.dev
    attrs=$(curl -sf "$baseUrl/$sourceHash/$ref" || true)

    if [[ -n $attrs ]];then
      errorPattern="don't know how to build these paths:"
      outPath=$(nix eval --raw --expr "$attrs.outPath")
      if ! nix build "$outPath" --dry-run --log-format internal-json |& grep -qF "$errorPattern";then
        nix build --no-link "$outPath"
        exec nix "$cmd" --expr "$attrs" "$@"
      fi
    fi
  fi
  exec nix "$cmd" "$flake"#"$ref" "$@"
'').overrideAttrs {
  passthru = { inherit build; };
}
