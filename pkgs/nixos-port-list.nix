scope: with scope; (
  writeBashBin pname ''
    nix eval --impure --raw --expr \
      "with import ${self-flake} {}; ${pname}.get nixosConfigurations.$(machine-name).config" 2>&1 |
      grep -v 'trace: Obsolete option'
  ''
).overrideAttrs (_: {
  passthru.get = flip pipe [
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
    (filter (g: g.path == "services" && !elem g.name [ "redis" ]))
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
})
