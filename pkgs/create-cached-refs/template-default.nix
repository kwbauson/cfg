{ system ? builtins.currentSystem
, storePath ? builtins.storePath
}:
let
  inherit (builtins) foldl' attrNames readDir mapAttrs;
  mergeAttrsList = foldl' (a: b: a // b) { };
  pinsFiles = attrNames (readDir ./pins);
  pinsAttrs = map (p: import (./pins + ("/" + p)) { inherit storePath; }) pinsFiles;
  pins = mergeAttrsList pinsAttrs;
in
mapAttrs (_: value: value.${system} or value) pins
