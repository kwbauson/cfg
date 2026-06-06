{ config, scope, ... }: with scope;
{
  options.secret = mkSubmodulesOption ({ name, ... }: {
    options = {
      enable = mkEnableOption "secret";
      value = mkRef "data.google_secret_manager_secret_version.${name}.secret_data";
    };
  });
  config = mkFromEnabled config.secret (name: _: {
    resource.google_secret_manager_secret.${name} = {
      secret_id = name;
      replication.auto = { };
    };
    resource.google_secret_manager_secret_version.${name} = {
      secret = tf.ref "google_secret_manager_secret.${name}.id";
      secret_data = "initial";
    };
    data.google_secret_manager_secret_version.${name} = {
      secret = tf.ref "google_secret_manager_secret_version.${name}.secret";
    };
  });
}
