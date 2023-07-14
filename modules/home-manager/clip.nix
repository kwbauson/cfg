{ config, scope, ... }: with scope;
let cfg = config.services.clip; in
{
  options.services.clip = {
    enable = mkEnableOption "clip";
    port = mkOption {
      type = types.port;
      default = 6543;
    };
    hosts = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    sync-primary.enable = mkEnableOption "sync-primary";
  };
  config = {
    systemd.user.services.clip-sync-primary = mkIf cfg.sync-primary.enable {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Service.ExecStart = "${getExe clip} --sync_primary";
    };
    systemd.user.services.clip-server = mkIf cfg.enable {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Service.ExecStart = "${getExe clip} --server --port ${toString cfg.port} ${optionalString (cfg.hosts != []) "--hosts ${concatStringsSep "," cfg.hosts}"}";
    };
  };
}
