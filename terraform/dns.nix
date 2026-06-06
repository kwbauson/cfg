{ config, ... }:
{
  terraform.required_providers.porkbun.source = "cullenmcdermott/porkbun";

  secret.porkbun_api_key.enable = true;
  secret.porkbun_secret_key.enable = true;

  provider.porkbun = {
    api_key = config.secret.porkbun_api_key.value;
    secret_key = config.secret.porkbun_secret_key.value;
  };

  resource.porkbun_dns_record = {
    kwbauson_com = {
      domain = "kwbauson.com";
      type = "A";
      content = "137.220.57.226";
    };

    wildcard_kwbauson_com = {
      domain = "kwbauson.com";
      type = "A";
      name = "*";
      content = "137.220.57.226";
    };

    home_kwbauson_com = {
      domain = "kwbauson.com";
      type = "A";
      name = "home";
      content = "127.0.0.1"; # dynamic
      lifecycle.ignore_changes = [ "content" ];
    };

    kwbauson_com_txt = {
      domain = "kwbauson.com";
      type = "TXT";
      content = "v=spf1 mx include:_spf.porkbun.com ~all";
    };
  };
}
