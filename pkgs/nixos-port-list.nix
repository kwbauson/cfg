scope: with scope;
addMetaAttrs { includePackage = true; } ((
  writeBashBin pname ''
    nix eval --raw "${flake}#${pname}.machines.$(machine-name)" \
      2>&1 | grep -Ev '^trace: Obsolete option|^fetching path input'
  ''
).overrideAttrs (_: {
  passthru = rec {
    erroringModules = [ "redis" "frp" "vmalert" ];
    machines = mapAttrValues (v: get v.config) nixosConfigurations;
    get = flip pipe [
      (config:
        let
          getPath = p: getAttrFromPath (splitString "." p) config;
          mkGroup = path: mapAttrsToList
            (name: attrs: { inherit path name attrs; })
            (getPath path);
        in
        flatten [
          (mkGroup "services")
          (mkGroup "programs")
          (mapAttrsToList
            (user: _: [
              (mkGroup "home-manager.users.${user}.services")
              (mkGroup "home-manager.users.${user}.programs")
            ])
            config.home-manager.users)
        ]
      )
      # exclude deprecations that error
      (filter (g: g.path == "services" && !elem g.name erroringModules))
      (filter (g: (tryEval g.attrs.enable or false).value))
      # only portish named attrs
      (map (g: g // { attrs = filterAttrs (n: _: match "^port$|.+Port$" n != null) g.attrs; }))
      (filter (g: g.attrs != { }))
      (concatMap (g: mapAttrsToList (n: v: { inherit (g) path name; portAttr = n; portValue = v; }) g.attrs))
      (concatMapStringsSep "\n" (g: "${g.path}.${g.name}.${g.portAttr} = ${toString g.portValue};"))
      (str: ''
        Note: this list is best-effort

        ${str}
      '')
    ];
  };
}))
