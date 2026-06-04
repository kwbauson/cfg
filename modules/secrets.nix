{ config, options, scope, ... }: with scope;
let
  extraSecretOptions = {
    enable = mkEnableOption "secret";
    isUser = mkOption {
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
        ({ config, ... }: mkConfigIf config.isUser { owner = username; })
      ];
    }));
  };

  config = mkMerge [
    {
      age.identityPaths = [ "${config.users.users.${username}.home}/.ssh/id_ed25519" ];
      age.secrets = mapAttrValues (s: removeAttrs s (attrNames extraSecretOptions)) enabledSecrets;
      secrets = pipeValue [
        (readDir ../secrets)
        (mapAttrNames (filename: rec {
          inherit filename;
          parts = splitString "." filename;
          isShared = length parts == 2;
          name = elemAt parts (if isShared then 0 else 1);
          forMachine = if isShared then null else head parts;
        }))
        (filterAttrs (_: v: v.isShared || v.forMachine == machine.name))
        (mapAttrs' (_: v: nameValuePair v.name {
          enable = mkDefault true;
          file = ../secrets/${v.filename};
        }))
      ];
    }
    (mkConfigIf isLinux {
      systemd.services = pipeValue [
        enabledSecrets
        (filterAttrs (_: v: v.isEnvironment))
        (mapAttrValues (v: { serviceConfig.EnvironmentFile = mkForce v.path; }))
      ];
    })
  ];
}
