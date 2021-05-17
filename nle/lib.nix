config: with config.lib;
(lib: { inherit lib; }) ((import config.nixpkgs.path { }).lib // builtins // {
  hasAttrs = xs: attrs: all (x: hasAttr x attrs) xs;
  import' = path:
    let importEntry = entry: type:
      if type == "directory" then
        let
          mkEntry = file: type: [{
            name = removeSuffix ".nix" file;
            value = importEntry (entry + "/${file}") type;
          }] ++ optional (hasSuffix ".nix" file) { name = file; value = path + "/${file}"; };
          entries = listToAttrs (concatLists (mapAttrsToList mkEntry (readDir entry)));
          default = entries.default or { };
        in
        if isAttrs default then default // entries
        else if isFunction default then entries // { __functor = _: default; __functionArgs = functionArgs default; }
        else default
      else if hasSuffix ".nix" entry then import entry
      else entry;
    in
    importEntry path "directory";
})
