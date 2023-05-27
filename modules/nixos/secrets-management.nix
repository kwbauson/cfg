{ config, scope, ... }: with scope;
let cfg = config.secrets-management; in
{
  options.secrets-management = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        enable = mkEnableOption "secret";
        provider = mkOption {
          type = strMatching "bitwarden";
          default = "bitwarden";
        };
        unitSuffix = mkOption {
          type = str;
          default = "";
        };
      };
    });
    default = { };
  };

  config.systemd.services = forAttrs' cfg (name: options:
    let
      beforeUnit = "${name}${options.unitSuffix}.service";
    in
    nameValuePair "secrets-management-${name}" {
      serviceConfig.Type = "oneshot";
      requiredBy = [ beforeUnit ];
      before = [ beforeUnit ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = [ bws jq ];
      script = ''
        set -eux
        bws list secrets | jq -r '.[] | select(.key == "${name}") | .value'
      '';
    }
  );

  config.secrets-management.github-runner = {
    enable = true;
    unitSuffix = "-${config.networking.hostName}";
  };
}
