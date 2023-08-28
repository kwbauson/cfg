{ config, scope, ... }: with scope;
let cfg = config.services.scribblers; in
{
  options.services.scribblers = {
    enable = mkEnableOption "scribblers";
    port = mkOption { type = types.port; default = constants.scribblers.port; };
    address = mkOption { type = types.str; default = "0.0.0.0"; };
    rootPath = mkOption { type = types.str; default = ""; };
  };
  config = mkIf cfg.enable {
    systemd.services.scribblers = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        export PORT=${toString cfg.port}
        export NETWORK_ADDRESS=${cfg.address}
        export ROOT_PATH=${cfg.rootPath}
        exec ${scribblers}/bin/scribblers
      '';
    };
  };
}
