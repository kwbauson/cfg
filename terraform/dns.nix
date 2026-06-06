{ config, scope, ... }: with scope;
{
  terraform.required_providers.porkbun.source = "cullenmcdermott/porkbun";

  secret.porkbun_api_key.enable = true;
  secret.porkbun_secret_key.enable = true;

  provider.porkbun = {
    api_key = config.secret.porkbun_api_key.value;
    secret_key = config.secret.porkbun_secret_key.value;
  };

  resource.porkbun_dns_record = mapAttrValues
    (r: {
      domain = machines.kwbauson.public-fqdn;
      content = machines.kwbauson.public-ip;
    } // r)
    {
      kwbauson_com = {
        type = "A";
      };

      wildcard_kwbauson_com = {
        type = "A";
        name = "*";
      };

      home_kwbauson_com = {
        type = "A";
        name = "home";
        content = constants.localhost.ip; # dynamic
        lifecycle.ignore_changes = [ "content" ];
      };

      kwbauson_com_txt = {
        type = "TXT";
        content = "v=spf1 mx include:_spf.porkbun.com ~all";
      };
    };
}
