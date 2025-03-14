{ system ? builtins.currentSystem
, mkPath ? builtins.storePath
}:
let
  inherit (builtins)
    foldl' attrNames readDir mapAttrs zipAttrsWith length head elemAt isAttrs
    elem substring replaceStrings genList stringLength;
  lib = rec {
    # from https://github.com/NixOS/nixpkgs/blob/master/lib/attrsets.nix
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
    recursiveUpdate =
      lhs:
      rhs:
      recursiveUpdateUntil (path: lhs: rhs: !(isAttrs lhs && isAttrs rhs)) lhs rhs;
    hasAttrByPath =
      attrPath:
      e:
      let
        lenAttrPath = length attrPath;
        hasAttrByPath' = n: s: (
          n == lenAttrPath || (
            let
              attr = elemAt attrPath n;
            in
            if s ? ${attr} then hasAttrByPath' (n + 1) s.${attr}
            else false
          )
        );
      in
      hasAttrByPath' 0 e;

    # from https://github.com/NixOS/nixpkgs/blob/master/lib/lists.nix
    unique = foldl' (acc: e: if elem e acc then acc else acc ++ [ e ]) [ ];

    # from https://github.com/NixOS/nixpkgs/blob/master/lib/strings.nix
    splitString = sep: s:
      let
        splits = builtins.filter builtins.isString (builtins.split (escapeRegex (toString sep)) (toString s));
      in
      map (addContextFrom s) splits;
    addContextFrom = src: target: substring 0 0 src + target;
    escapeRegex = escape (stringToCharacters "\\[{()^$?*+|.");
    escape = list: replaceStrings list (map (c: "\\${c}") list);
    stringToCharacters = s:
      genList (p: substring p 1 s) (stringLength s);
  };
in
with lib;
let
  files = attrNames (readDir ./paths);
  pathsAttrs = map (p: import (./paths + ("/" + p)) { inherit mkPath; }) files;
  paths = foldl' recursiveUpdate { } pathsAttrs;
  sourceHashes = unique (map (x: x.__sourceHash) pathsAttrs);
in
assert length sourceHashes == 1;
mapAttrs (_: value: value.${ system} or value) paths // { inherit lib; }
