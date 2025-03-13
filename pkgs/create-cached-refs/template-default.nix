{ system ? builtins.currentSystem
, mkPath ? builtins.storePath
}:
let
  inherit (builtins) foldl' attrNames readDir mapAttrs zipAttrsWith length head elemAt isAttrs;
  # see https://github.com/NixOS/nixpkgs/blob/master/lib/attrsets.nix
  recursiveUpdateUntil =
    pred:
    lhs:
    rhs:
    let
      f = attrPath:
        zipAttrsWith (n: values:
          let here = attrPath ++ [ n ]; in
          if length values == 1
            || pred here (elemAt values 1) (head values) then
            head values
          else
            f here values
        );
    in
    f [ ] [ rhs lhs ];
  # see https://github.com/NixOS/nixpkgs/blob/master/lib/attrsets.nix
  recursiveUpdate =
    lhs:
    rhs:
    recursiveUpdateUntil (path: lhs: rhs: !(isAttrs lhs && isAttrs rhs)) lhs rhs;

  files = attrNames (readDir ./paths);
  pathsAttrs = map (p: import (./paths + ("/" + p)) { inherit mkPath; }) files;
  paths = foldl' recursiveUpdate { } pathsAttrs;
in
mapAttrs (_: value: value.${system} or value) paths
