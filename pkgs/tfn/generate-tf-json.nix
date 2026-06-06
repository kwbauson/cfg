{ configPath
, cfgScope ? import ../../. { }
, terranixSrc ? cfgScope.terranix.src
, scope ? cfgScope.fix (scope: with scope; cfgScope.mergeAttrsList [
    cfgScope
    (cfgScope.fix (self: import "${terranixSrc}/core/helpers.nix" pkgs self lib))
    {
      mkRef = ref: mkOption { type = types.str; default = tf.ref ref; };
    }
  ])
}: with scope;
let
  core = import "${terranix.src}/core/default.nix" {
    inherit (scope) pkgs;
    extraArgs = { inherit scope; };
    terranix_config = { imports = [ configPath ]; };
  };
in
writeJSON "config.tf.json" core.config
