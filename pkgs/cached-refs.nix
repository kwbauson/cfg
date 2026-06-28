scope: with scope;
let
  build = { flake, refs, bucket, endpoint_url, postBuild ? "" }:
    let
      sourceHash = getDrvHash flake;
      refsJson = (formats.json { }).generate "cached-refs.json" (map
        (ref: {
          key = concatStringsSep "." ref;
          pkg = getAttrFromPath ref flake;
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
                  key = f"${sourceHash}/{item["key"]}"
                  print('Pushing', key)
                  s3.put_object(
                      Key=key,
                      Body=item["pkg"],
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
    outPath=$(curl -sf "$baseUrl/$sourceHash/$ref" || true)

    if [[ -n $outPath ]];then
      errorPattern="don't know how to build these paths:"
      if ! nix build "$outPath" --dry-run --log-format internal-json |& grep -qF "$errorPattern";then
        nix build --no-link "$outPath"
        exec nix "$cmd" "$outPath" "$@"
      fi
    fi
  fi
  exec nix "$cmd" "$flake"#"$ref" "$@"
'').overrideAttrs {
  passthru = { inherit build; };
}
