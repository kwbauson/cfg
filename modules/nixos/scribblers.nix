{ config, scope, ... }: with scope;
let cfg = config.services.scribble; in
{
  options.services.scribble = {
    enable = mkEnableOption "scribblers";
    package = scribblers;
    port = mkOption { type = types.port; default = constants.scribblers.port; };
    address = mkOption { type = types.str; default = "0.0.0.0"; };
    rootPath = mkOption { type = types.str; default = ""; };
  };
  config = mkIf cfg.enable {
    systemd.services.scribble = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        export PORT=${cfg.port}
        export NETWORK_ADDRESS=${cfg.address}
        export ROOT_PATH=${cfg.rootPath}
        exec ${cfg.package}/bin/scribblers
      '';
    };
  };
}
