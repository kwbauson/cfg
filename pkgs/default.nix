{ _auto, scope }: with scope;
system: pipeValue [
  (readDir ./.)
  (filterAttrs (n: _: n != "default.nix"))
  (mapAttrsToList (name: _: rec {
    pname = removeSuffix ".patch" (removeSuffix ".nix" name);
    file = ./${name};
    type =
      if hasSuffix ".patch" name then "patch"
      else if params ? _overlay then "overlay"
      else if params ? _set then "set"
      else if params == { } then "scopePackage"
      else "package";
    nixFile = findFirst (p: p != null && pathExists p) null [
      (if hasSuffix ".nix" name then file else null)
      ./${name}/package.nix
      ./${name}/default.nix
    ];
    imported = if nixFile != null then import nixFile else null;
    params = if isFunction imported then functionArgs imported else { };
    result.${pname} = scope: {
      patch = prev: prev.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [ file ];
        meta = old.meta or { } // { skipUpdate = true; };
      });
      overlay = prev: imported { _overlay = true; scope = scope // { inherit prev; }; };
      set = imported { _set = true; inherit scope; };
      scopePackage = fix (package:
        let
          pkg = imported (scope // {
            inherit pname package;
            version = "unstable";
            exe = getExe package;
          });
          meta = { }
            // optionalAttrs (pkg.type or null == "derivation" && !pkg ? meta.mainProgram) { mainProgram = pname; }
            // optionalAttrs (pkg ? src) { position = "${toString file}:1"; };
        in
        if meta == { } then pkg else addMetaAttrs meta pkg);
      package = scope.callPackage imported { };
    }.${type};
  }))
  (groupBy' (a: x: a // x.result) { } (x: x.type))
  (groups': rec {
    groups = mapAttrValues (mapAttrValues (f: f scope)) groups';
    pkgs = cfg.legacyPackages.${system};
    scope = pkgs // pkgs.formats // pkgs.writers // cfg.scope // packages.${system};
    overlayFns = groups.patch or { } // groups.overlay or { };
    extra-packages = mapAttrNames (n: pkgs.${n}) overlayFns // groups.package or { } // groups.scopePackage or { };
    final = concatMapAttrs (_: id) groups.set
      // extra-packages // { inherit scope overlayFns extra-packages; };
  }.final)
]
