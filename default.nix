{ system ? builtins.currentSystem
, storePath ? builtins.storePath
}:
let
  pins = (import ./pins.nix { inherit storePath; });
in
builtins.mapAttrs (_: value: value.${system} or value) pins
