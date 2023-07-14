{ config, scope, ... }: with scope;
let cfg = config.programs.pmount; in
{
  options.programs.pmount = {
    enable = mkEnableOption "pmount";
    allow = mkOption {
      type = types.lines;
      default = "*";
      description = mkDoc ''
        List of devices (one device per line) which are additionally permitted for pmounting.
        Globs, such as /dev/sda[123] are permitted.
        See see glob (7) for a more complete syntax.
      '';
    };
  };
  config = mkIf cfg.enable {
    environment.etc."pmount.allow".text = cfg.allow;
    environment.systemPackages = [ pmount ];
    security.wrappers =
      let
        rootWrapper = source: {
          setuid = true;
          owner = "root";
          group = "root";
          inherit source;
        };
      in
      {
        pmount = rootWrapper "${pmount}/bin/pmount";
        pumount = rootWrapper "${pmount}/bin/pumount";
      };
    systemd.tmpfiles.rules = [ "d /media" ];
  };
}
