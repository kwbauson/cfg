{ config, scope, ... }: with scope;
let cfg = config.services.clip; in
{
  options.services.clip = {
    sync.enable = mkEnableOption "sync";
  };
  config = {
    systemd.user.services.clip-sync = mkIf cfg.sync.enable {
      Unit.PartOf = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${getExe clip} sync";
    };
  };
}
