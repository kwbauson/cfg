{ config, scope, ... }: with scope;
let
  stripKeyComment = key: concatStringsSep " " (take 2 (splitString " " key));
  inherit (constants) cloudflare;
in
{
  plugins = ps: [ ps.integrations_github ps.cloudflare_cloudflare ];

  resource.github_user_ssh_key = genAttrs
    [ "keith-desktop" "keith-xps" "keith-server" ]
    (name: {
      title = name;
      key = stripKeyComment machines.${name}.public.key;
    });

  secret.cloudflare_api_token.enable = true;

  provider.cloudflare.api_token = config.secret.cloudflare_api_token.value;

  resource.cloudflare_r2_bucket.cached_refs_bucket = {
    inherit (cloudflare) account_id;
    name = "kwbauson-cached-refs";
  };

  resource.cloudflare_r2_managed_domain.cached_refs_bucket = {
    inherit (cloudflare) account_id;
    bucket_name = config.resource.cloudflare_r2_bucket.cached_refs_bucket.name;
    enabled = true;
  };

  resource.cloudflare_r2_bucket_lifecycle.cached_refs_bucket = {
    inherit (cloudflare) account_id;
    bucket_name = config.resource.cloudflare_r2_bucket.cached_refs_bucket.name;
    rules = [{
      id = "expiration";
      enabled = true;
      conditions.prefix = "";
      delete_objects_transition.condition = {
        max_age = 30 * 24 * 60 * 60;
        type = "Age";
      };
    }];
  };
}
