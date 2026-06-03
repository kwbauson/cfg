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
          file = /tmp/${if config.isShared then name else "${machine.name}.${name}"}.age;
        })
        ({ config, ... }: {
          config = mkIf config.isUser { owner = username; };
        })
      ];
    }));
    default = { };
  };

  config = {
    age.identityPaths =
      let path = "${config.users.users.${username}.home}/.ssh/id_ed25519";
      in [ path "${path}.old" ];
    age.secrets = mapAttrValues (s: removeAttrs s (attrNames extraSecretOptions)) enabledSecrets;
    systemd.services = pipeValue [
      enabledSecrets
      (filterAttrs (_: v: v.isEnvironment))
      (mapAttrValues (v: { serviceConfig.EnvironmentFile = mkForce v.path; }))
    ];
  };
}
