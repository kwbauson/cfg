{ config, scope, ... }: with scope;
let
  cfg = config.secret;
  mkRef = ref: mkOption { type = types.str; default = tf.ref ref; };
  secretModule = { name, ... }: {
    options = {
      enable = mkEnableOption "secret";
      value = mkRef "data.google_secret_manager_secret_version.${name}.secret_data";
    };
  };
  forEnabled = f: mkMerge (mapAttrsToList (n: _: f n) (filterAttrs (_: c: c.enable) cfg));
in
{
  options.secret = mkOption {
    type = types.attrsOf (types.submoduleWith { modules = [ secretModule ]; });
  };
  config.resource = forEnabled (name: {
    google_secret_manager_secret.${name} = {
      secret_id = name;
      replication.auto = { };
    };
    google_secret_manager_secret_version.${name} = {
      secret = tf.ref "google_secret_manager_secret.${name}.id";
      secret_data = "initial";
    };
  });
  config.data = forEnabled (name: {
    google_secret_manager_secret_version.${name} = {
      secret = tf.ref "google_secret_manager_secret_version.${name}.secret";
    };
  });
}
