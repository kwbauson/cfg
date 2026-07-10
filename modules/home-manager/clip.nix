{ config, scope, ... }: with scope;
let cfg = config.services.clip; in
{
  options.services.clip = {
    sync.enable = mkEnableOption "sync";
  };
  config.systemd.user.services.clip-sync = mkIf cfg.sync.enable
    (mkGraphicalService config {
      Service.ExecStart = "${getExe clip} sync";
    });
}
