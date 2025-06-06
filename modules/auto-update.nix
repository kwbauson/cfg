{ config, scope, username, machine-name, ... }: with scope;
let
  cfg = config.services.auto-update;
  script = ''
    set -x
    export PATH=/run/wrappers/bin:"$HOME"/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/usr/sbin:/bin:/sbin
    cd $HOME/cfg
    if [[ $(git rev-parse --abbrev-ref HEAD) = main ]];then
      if [[ -z $(git status -s) ]];then
        nou
        nod ${optionalString (machine-name == "kwbauson") "--delete-booted-system"}
      else
        echo working branch dirty, skipping
      fi
    else
      echo not on main branch, skipping
    fi
  '';
in
{
  options.services.auto-update = {
    enable = mkEnableOption "auto-update";
  };
  config = mkIf cfg.enable (
    if !isDarwin then {
      systemd.services.auto-update = {
        restartIfChanged = false;
        startAt = "*-*-* 05:00:00";
        serviceConfig.User = username;
        inherit script;
      };
    } else {
      launchd.daemons.auto-update = {
        serviceConfig = {
          UserName = username;
          StartCalendarInterval = [{ Hour = 5; Minute = 0; }];
          StandardOutPath = "/tmp/auto-update-logs.txt";
          StandardErrorPath = "/tmp/auto-update-logs.txt";
        };
        inherit script;
      };
    }
  );
}
