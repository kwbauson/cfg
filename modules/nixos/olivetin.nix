{ config, scope, ... }: with scope;
let cfg = config.services.olivetin; in
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
        exec ${olivetin}/OliveTin --configdir ${writeTextDir "config.yaml" cfg.config}
      '';
    };
  };
}
