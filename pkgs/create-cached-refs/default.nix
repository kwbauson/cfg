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
    , sourceStorePath ? flake.outPath
    , packages ? flake.packages.${system}
    , appendSystem ? true
    , appendStoreHash ? false
    }:
    let
      sourceHash = substring 11 32 (builtins.unsafeDiscardStringContext sourceStorePath);
      getName = p: concatStringsSep "." (flatten [
        p
        (optional appendSystem system)
        (optional appendStoreHash sourceHash)
      ]);
      getOutput = p: getAttrFromPath (splitString "." p) packages;
      outputs = listToAttrs (map (p: { name = getName p; value = getOutput p; }) paths);
    in
    linkFarm "ref-paths" (outputs // { __sourceHash = writeText "ref-paths-hash" sourceHash; });
}
