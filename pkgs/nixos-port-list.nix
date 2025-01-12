scope: with scope; (
  writeBashBin pname ''
    nix eval --impure --raw --expr \
      "with import ${self-flake} {}; ${pname}.get nixosConfigurations.$(machine-name).config" 2>&1 |
      grep -v 'trace: Obsolete option'
  ''
).overrideAttrs (_: {
  passthru.get = flip pipe [
    (config: config.services)
    (filterAttrs (name: attrs: all id
      [
        # exclude deprecations that error
        (!elem name [ "redis" ])
        # only enabled
        ((tryEval attrs.enable or false).value)
      ]))
    (mapAttrs (_: filterAttrs (n: _: match "^port$|.+Port$" n != null)))
    (filterAttrs (_: attrs: attrs != { }))
    (mapAttrsToList (s: mapAttrsToList (a: p: nameValuePair "services.${s}.${a}" p)))
    flatten
    (concatMapStringsSep "\n" (v: "${v.name} = ${toString v.value};"))
    (str: ''
      Note: this list is best-effort

      ${str}
    '')
  ];
})
