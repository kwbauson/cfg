{ config, scope, ... }: with scope;
let
  cfg = config.services.caddy;
  authSubmodule = types.submodule {
    options = {
      role = mkOption { type = types.str; };
      port = mkOption { type = types.port; };
    };
  };
in
{
  options.services.caddy = {
    subdomainsOf = mkOption {
      type = types.str;
      default = "localhost";
    };
    subdomains = mkOption {
      type = with types; attrsOf (oneOf [ authSubmodule lines port ]);
      default = { };
    };
  };

  config.services.caddy = {
    package = cobi.pkgs.zaddy.overrideAttrs (_: { postInstall = caddy.postInstall; });
    globalConfig = ''
      order authenticate before respond
      order authorize before basicauth

      security {
        oauth identity provider google {env.GOOGLE_CLIENT_ID} {env.GOOGLE_CLIENT_SECRET}

        authentication portal default {
          ui {
            links {
              ${pipe cfg.subdomains [
                attrNames
                (remove "")
                (remove "auth")
                (map (n: ''"${n}" https://${n}.${cfg.subdomainsOf}''))
                (concatStringsSep "\n")
              ]}
            }
          }

          transform user {
            match email kwbauson@gmail.com
            action add role authp/admin authp/user
          }
        }

        authorization policy admin {
          set auth url https://auth.${cfg.subdomainsOf}
          allow roles authp/admin
        }

        authorization policy user {
          set auth url https://auth.${cfg.subdomainsOf}
          allow roles authp/user
        }
      }
    '';

    virtualHosts = forAttrs' cfg.subdomains
      (subdomain: value: {
        name = "${subdomain}${optionalString (subdomain != "") "."}${cfg.subdomainsOf}:80";
        value.extraConfig =
          if isAttrs value then ''
            authorize with ${value.role}
            reverse_proxy localhost:${toString value.port}
          ''
          else if isString value then value
          else "reverse_proxy localhost:${toString value}";
      });
  };
}
