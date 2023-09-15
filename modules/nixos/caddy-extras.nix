{ config, scope, ... }: with scope;
let cfg = config.services.caddy; in
{
  options.services.caddy = {
    subdomainsOf = mkOption {
      type = types.str;
      default = "localhost:80";
    };
    subdomains = mkOption {
      type = with types; attrsOf (oneOf [ port lines ]);
      default = { };
    };
  };
  config.services.caddy.virtualHosts = forAttrs' cfg.subdomains
    (subdomain: value: {
      name = "${subdomain}${optionalString (subdomain != "") "."}${cfg.subdomainsOf}";
      value.extraConfig =
        if isString value
        then value
        else "reverse_proxy localhost:${toString value}";
    });
}
