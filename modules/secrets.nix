{ config, options, scope, ... }: with scope;
let
  osConfig = config;
  boolOrStrOption = mkOption {
    type = types.oneOf [ types.bool types.str ];
    default = false;
  };
  strOption = mkOption {
    type = types.str;
  };
  extraSecretOptions = {
    enable = mkEnableOption "secret";
    user = mkEnableOption "user";
    environmentFile = boolOrStrOption;
    loadCredential = boolOrStrOption;
    path = strOption;
    serviceName = strOption;
  };
  enabledSecrets = filterAttrs (_: v: v.enable) config.secrets;
  sopsFile = ../machines/${machine.name}/secrets.yaml;
  excludedOptions = attrNames extraSecretOptions ++ [ "sopsFileHash" ];
in
{
  imports = [
    (optionalAttrs isLinux "${sops-nix.src}/modules/sops")
    (optionalAttrs isDarwin "${sops-nix.src}/modules/nix-darwin")
  ];

  options.secrets = mkOption {
    type = types.attrsOf (types.submoduleWith ({
      modules = flatten [
        options.sops.secrets.type.getSubModules
        { options = extraSecretOptions; }
        ({ config, ... }: {
          config = mkIf config.user { owner = username; };
        })
        ({ config, ... }: {
          serviceName =
            let
              xs = filter isString [ config.environmentFile config.loadCredential ];
            in
            if length xs == 0 then config.name else head xs;
          path =
            if config.loadCredential != false
            then "/run/credentials/${config.serviceName}.service/${config.name}"
            else osConfig.sops.secrets.${config.name}.path;
        })
      ];
    }));
  };

  config = mkMerge [
    {
      sops.defaultSopsFile = sopsFile;
      sops.age.keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
      sops.age.sshKeyPaths = mkForce [ ];
      sops.gnupg.sshKeyPaths = mkForce [ ];
      sops.secrets = mapAttrValues (v: removeAttrs v excludedOptions) enabledSecrets;
      secrets = pipeValue [
        (if pathExists sopsFile then readFile sopsFile else "")
        (splitString "\n")
        (map (match "^([^[:space:]]+):.*$"))
        (filter isList)
        (map head)
        (remove "sops")
        (x: genAttrs x (_: { enable = true; }))
      ];
    }
    (optionalAttrs isLinux {
      systemd.services = pipe enabledSecrets [
        (filterAttrs (_: c: c.environmentFile != false || c.loadCredential != false))
        (mapAttrs' (n: c: nameValuePair c.serviceName {
          serviceConfig = {
            EnvironmentFile = mkIf (c.environmentFile != false) [ c.path ];
            LoadCredential = mkIf (c.loadCredential != false) [ "${n}:${config.sops.secrets.${n}.path}" ];
          };
        }))
      ];
    })
  ];
}
