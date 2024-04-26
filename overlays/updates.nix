final: prev: with final.scope; {
  updater = names:
    let
      packages = map (attrPath: { inherit attrPath; package = pkgs.${attrPath}; }) (toList names);
      # modified from nixpkgs/maintainers/script/update.nix
      packageData = { package, attrPath }: {
        inherit (package) name;
        pname = getName package;
        oldVersion = getVersion package;
        updateScript = map toString (toList package.updateScript.command or package.updateScript);
        supportedFeatures = [ ];
        inherit attrPath;
      };
      jsonFile = writeText "packageData.json" (toJSON (map packageData packages));
    in
    writeBashBin "updater" ''
      echo | ${getExe python3} ${pkgs.path}/maintainers/scripts/update.py --max-workers 1 ${jsonFile}
    '';
  update-extra-packages =
    let updatable = attrNames (filterAttrs (_: hasAttr "updateScript") extra-packages);
    in (updater updatable).overrideAttrs (_: {
      passthru = genAttrs updatable updater;
    });
  updates = (writeBashBin "updates" ''
    nix flake update
    nix run .#update-extra-packages
  '').overrideAttrs (_: {
    passthru = mergeAttrsList [
      update-extra-packages.passthru
      (forAttrNames
        inputs
        (input: writeBashBin "update-${input}" ''
          nix flake lock --update-input ${input}
        '')
      )
      { all = updates; }
    ];
  });
  sourcesInfo = pipe ../flake.lock [
    readFile
    fromJSON
    (x: x.nodes)
    (filterAttrs (name: _: name != "root"))
    (mapAttrValues (x: { inherit (x.locked) owner repo rev; }))
  ] // pipe extra-packages [
    (filterAttrs (_: pkg: pkg ? src.rev))
    (mapAttrValues (pkg: { inherit (pkg.src) owner repo rev; }))
  ];
}
