{ config, scope, ... }: with scope;
let
  cfg = config.services.olivetin;
  olivetinDir = runCommand "olivetin-dir" { } ''
    mkdir $out
    ln -s ${olivetin}/* $out
    ln -sf ${writeText "config.yaml" cfg.config} $out/config.yaml
  '';
in
{
  options.services.olivetin = {
    enable = mkEnableOption "olivetin";
    config = mkOption { type = types.lines; };
  };
  config = mkIf cfg.enable {
    systemd.services.olivetin = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        export "PATH=/run/current-system/sw/bin:$PATH"
        cd ${olivetinDir}
        exec ./OliveTin
      '';
    };
  };
}
