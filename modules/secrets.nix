{ config, options, scope, ... }: with scope;
let
  boolOrStrOption = mkOption {
    type = types.oneOf [ types.bool types.str ];
    default = false;
  };
  extraSecretOptions = {
    enable = mkEnableOption "secret";
    user = mkOption {
      type = types.bool;
      default = false;
    };
    environmentFile = boolOrStrOption;
    loadCredential = boolOrStrOption;
    path = mkOption {
      type = types.str;
    };
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
      systemd.services = pipeValue [
        enabledSecrets
        (filterAttrs (_: v: v.environmentFile != false))
        (mapAttrs' (n: v: nameValuePair (if v.environmentFile == true then n else v.environmentFile) {
          serviceConfig.EnvironmentFile = mkForce v.path;
        }))
      ];
    })
  ];
}
