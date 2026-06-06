{ config, scope, ... }: with scope;
{
  terraform.required_providers.porkbun.source = "cullenmcdermott/porkbun";

  secret.porkbun_api_key.enable = true;
  secret.porkbun_secret_key.enable = true;

  provider.porkbun = {
    api_key = config.secret.porkbun_api_key.value;
    secret_key = config.secret.porkbun_secret_key.value;
  };

  resource.porkbun_dns_record =
    let
      machine = machines.kwbauson;
      domain = machine.public-fqdn;
      ip = machine.public-ip;
    in
    {
      kwbauson_com = {
        inherit domain;
        type = "A";
        content = ip;
      };

      wildcard_kwbauson_com = {
        inherit domain;
        type = "A";
        name = "*";
        content = ip;
      };

      home_kwbauson_com = {
        inherit domain;
        type = "A";
        name = "home";
        content = constants.localhost.ip; # dynamic
        lifecycle.ignore_changes = [ "content" ];
      };

      kwbauson_com_txt = {
        domain = "kwbauson.com";
        type = "TXT";
        content = "v=spf1 mx include:_spf.porkbun.com ~all";
      };
    };
}
