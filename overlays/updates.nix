final: _: with final.scope; {
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
      set -euo pipefail
      echo 'import ${nixpkgsPath}/shell.nix' > shell.nix
      trap 'rm shell.nix' EXIT
      echo | ${getExe python3} ${nixpkgsPath}/maintainers/scripts/update.py ${jsonFile}
    '';
  update-extra-packages =
    let updatable = attrNames (filterAttrs (_: p: hasAttr "updateScript" p && !p.meta.skipUpdate or false) extra-packages);
    in (updater updatable).overrideAttrs (_: {
      passthru = genAttrs updatable updater;
    });
  updates = mergeAttrsList [
    {
      all = writeBashBin "update-all" ''
        set -euo pipefail
        nix flake update
        nix run .#updates.actions
        nix run .#update-extra-packages
      '';
      actions = writeBashBin "update-actions" "${getExe pinact} run --update";
    }
    (forAttrNames
      inputs
      (input: writeBashBin "update-${input}" ''
        nix flake lock --update-input ${input}
      '')
    )
    update-extra-packages.passthru
  ];
  sourcesInfo = pipe ../flake.lock [
    readFile
    fromJSON
    (x: x.nodes)
    (mapAttrValues (x: x // optionalAttrs (x.original.id or null == "nixpkgs")
      { locked = x.locked // { owner = "NixOS"; repo = "nixpkgs"; }; }))
    (filterAttrs (name: x: name != "root" && x.locked.repo or false != false))
    (mapAttrValues (x: { inherit (x.locked) owner repo rev; }))
  ] // pipe extra-packages [
    (filterAttrs (_: pkg: pkg ? src.repo))
    (mapAttrValues (pkg: { inherit (pkg.src) owner repo rev; }))
  ];
}
