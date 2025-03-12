scope: with scope;
let
  mkFlakePins =
    { paths
    , flake ? null
    , includeSystem ? true
    , includeFlakeStoreHash ? false
    , packages ? flake.packages.${system}
    }:
    let
      storeHash = lib.substring 11 32 (builtins.unsafeDiscardStringContext flake.outPath);
      getName = p: lib.concatStringsSep "." (lib.flatten [
        (lib.optional includeFlakeStoreHash storeHash)
        p
        (lib.optional includeSystem system)
      ]);
      getOutput = p: lib.getAttrFromPath (lib.splitString "." p) packages;
      outputs = lib.listToAttrs (map (p: { name = getName p; value = getOutput p; }) paths);
      metadata = lib.filterAttrsRecursive (_: v: v != null) (
        lib.mapAttrs
          (_: out: {
            inherit (out) name;
            pname = out.pname or null;
            meta.mainProgram = out.meta.mainProgram or null;
          })
          outputs
      );
      "metadata.json" = writeText "metadata.json" (builtins.toJSON metadata);
    in
    linkFarm "flake-pins" (outputs // { inherit "metadata.json"; });
in
mkArgc {
  inherit pname version;
  scriptPath = ./create-cached-refs.argc.sh;
  buildInputs = [ jq coreutils gnutar gzip gnused ];
  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --set TEMPLATE_DEFAULT ${./template-default.nix} \
      --set TEMPLATE_FLAKE ${./template-flake.nix}
  '';
  passthru = { inherit mkFlakePins; };
}
