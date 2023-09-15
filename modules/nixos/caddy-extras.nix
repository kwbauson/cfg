{ config, scope, ... }: with scope;
let cfg = config.services.caddy; in
{
  options.services.caddy = {
    subdomainsOf = mkOption {
      type = types.str;
      default = "localhost:80";
    };
    subdomains = mkOption {
      type = with types; attrsOf (oneOf [ attrs lines port ]);
      default = { };
    };
  };
  config.services.caddy.virtualHosts = forAttrs' cfg.subdomains
    (subdomain: value: {
      name = "${subdomain}${optionalString (subdomain != "") "."}${cfg.subdomainsOf}";
      value =
        if isAttrs value then value
        else if isString value then { extraConfig = value; }
        else { extraConfig = "reverse_proxy localhost:${toString value}"; };
    });
}
