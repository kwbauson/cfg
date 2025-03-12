scope: with scope;
mkArgc {
  inherit pname version;
  scriptPath = ./create-cached-refs.argc.sh;
  buildInputs = [ jq coreutils gnutar gzip gnused git ];
  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --set TEMPLATE_DEFAULT ${./template-default.nix} \
      --set TEMPLATE_FLAKE ${./template-flake.nix}
  '';
  passthru.mkRefPaths =
    { paths
    , flake ? null
    , includeSystem ? true
    , includeFlakeStoreHash ? false
    , packages ? flake.packages.${system}
    }:
    let
      storeHash = lib.substring 11 32 (builtins.unsafeDiscardStringContext flake.outPath);
      getName = p: lib.concatStringsSep "." (lib.flatten [
        p
        (lib.optional includeSystem system)
        (lib.optional includeFlakeStoreHash storeHash)
      ]);
      getOutput = p: lib.getAttrFromPath (lib.splitString "." p) packages;
      outputs = lib.listToAttrs (map (p: { name = getName p; value = getOutput p; }) paths);
    in
    linkFarm "ref-paths" outputs;
}
