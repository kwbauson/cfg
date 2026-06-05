{ lib, ... }:
let scope = import ../scope.nix { inherit lib; }; in with scope;
{
  terraform.cloud = {
    hostname = "app.terraform.io";
    organization = "kwbauson";
    workspaces.name = "cfg";
  };

  provider.google = {
    project = "kwbauson";
    region = "us-east1";
    zone = "us-east1-a";
  };

  terraform.required_providers = {
    porkbun.source = "cullenmcdermott/porkbun";
  };

  module.porkbun_api_key = {
    source = "./modules/secret";
    id = "porkbun_api_key";
  };

  module.porkbun_secret_key = {
    source = "./modules/secret";
    id = "porkbun_secret_key";
  };

  provider.porkbun = {
    api_key = tf.ref "module.porkbun_api_key.secret_value";
    secret_key = tf.ref "module.porkbun_secret_key.secret_value";
  };

  resource.porkbun_dns_record.kwbauson_com = {
    domain = "kwbauson.com";
    type = "A";
    content = "137.220.57.226";
  };

  resource.porkbun_dns_record.wildcard_kwbauson_com = {
    domain = "kwbauson.com";
    type = "A";
    name = "*";
    content = "137.220.57.226";
  };

  resource.porkbun_dns_record.home_kwbauson_com = {
    domain = "kwbauson.com";
    type = "A";
    name = "home";
    content = "127.0.0.1"; # dynamic
    lifecycle.ignore_changes = [ "content" ];
  };

  resource.porkbun_dns_record.kwbauson_com_txt = {
    domain = "kwbauson.com";
    type = "TXT";
    content = "v=spf1 mx include:_spf.porkbun.com ~all";
  };
}
