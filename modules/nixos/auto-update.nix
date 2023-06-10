{ config, scope, username, ... }: with scope;
let cfg = config.services.auto-update; in
{
  options.services.auto-update = {
    enable = mkEnableOption "auto-update";
  };
  config = mkIf cfg.enable {
    systemd.services.auto-update = {
      startAt = "minutely";
      serviceConfig.User = username;
      path = [ git ];
      script = ''
        export PATH="$HOME"/.nix-profile/bin:/run/wrappers/bin:${makeBinPath [ nix ]}
        cd $HOME
        cd cfg
        if [[ $(git rev-parse --abbrev-ref HEAD) = main ]];then
          if [[ -z $(git status -s) ]];then
            nou
            nod
          else
            echo working branch dirty, skipping
          fi
        else
          echo not on main branch, skipping
        fi
      '';
    };
  };
}
