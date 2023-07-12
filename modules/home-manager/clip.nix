{ config, scope, ... }: with scope;
let cfg = config.services.clip; in
{
  options.services.clip = {
    enable = mkEnableOption "clip";
    port = mkOption {
      type = types.port;
      default = 6543;
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
  };
}
