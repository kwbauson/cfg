{ config, options, scope, ... }: with scope;
let
  extraSecretOptions = {
    enable = mkOption {
      default = true;
      type = types.bool;
    };
    isUser = mkOption {
      default = false;
      type = types.bool;
    };
    isShared = mkOption {
      default = false;
      type = types.bool;
    };
    isEnvironment = mkOption {
      default = false;
      type = types.bool;
    };
  };
  enabledSecrets = filterAttrs (_: v: v.enable) config.secrets;
in
{
  imports = [
    "${agenix.src}/modules/age.nix"
  ];

  options.secrets = mkOption {
    type = types.attrsOf (types.submoduleWith ({
      modules = options.age.secrets.type.getSubModules ++ [
        { options = extraSecretOptions; }
        ({ config, name, ... }: {
          file = ../secrets/${if config.isShared then name else "${machine.name}.${name}"}.age;
        })
        ({ config, ... }: {
          config = mkIf config.isUser { owner = username; };
        })
      ];
    }));
    default = { };
  };

  config = mkMerge [
    {
      age.identityPaths = [ "${config.users.users.${username}.home}/.ssh/id_ed25519" ];
      age.secrets = mapAttrValues (s: removeAttrs s (attrNames extraSecretOptions)) enabledSecrets;
    }
    (optionalAttrs isLinux {
      systemd.services = pipeValue [
        enabledSecrets
        (filterAttrs (_: v: v.isEnvironment))
        (mapAttrValues (v: { serviceConfig.EnvironmentFile = mkForce v.path; }))
      ];
    })
  ];
}
