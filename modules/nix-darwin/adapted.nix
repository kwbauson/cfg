{ scope, ... }: with scope;
{
  imports = [
    ({ config, pkgs, lib, ... }@args:
      let
        nixosModule = import "${ncro.src}/nix/module.nix" args;
        cfg = config.services.ncro;
        configFile = (formats.toml { }).generate "ncro.toml" cfg.settings;
        stateDir = "/var/lib/ncro";
      in
      {
        disabledModules = [ "${ncro.src}/nix/module.nix" ];
        inherit (nixosModule) options;
        config = mkIf cfg.enable (removeAttrs nixosModule.config.content [ "systemd" ] // {
          launchd.daemons.ncro = {
            script = "${getExe' cfg.package "ncro"} --config ${configFile}";
            serviceConfig = {
              RunAtLoad = true;
              StandardOutPath = "${stateDir}/stdout.txt";
              StandardErrorPath = "${stateDir}/stderr.txt";
              WorkingDirectory = stateDir;
            };
          };
        });
      }
    )
    ({ config, pkgs, lib, ... }@args:
      let
        nixosModule = import "${nixpkgsPath}/nixos/modules/services/networking/harmonia.nix" args;
        cfg = config.services.harmonia;
        cacheCfg = cfg.cache;
        stateDir = "/var/lib/harmonia";
        format = pkgs.formats.toml { };
      in
      {
        inherit (nixosModule) options;
        config = {
          services.harmonia.cache.settings = mapAttrValues mkDefault {
            bind = "[::]:5000";
            workers = 4;
            max_connection_rate = 256;
            priority = 50;
          };
          launchd.daemons.harmonia = {
            script = getExe cfg.package;
            environment = {
              CONFIG_FILE = "${format.generate "harmonia.toml" cacheCfg.settings}";
              SIGN_KEY_PATHS = cacheCfg.signKeyPaths;
              HOME = stateDir;
            };
            serviceConfig = {
              RunAtLoad = true;
              StandardOutPath = "${stateDir}/stdout.txt";
              StandardErrorPath = "${stateDir}/stderr.txt";
              WorkingDirectory = stateDir;
            };
          };
        };
      }
    )
  ];
}
