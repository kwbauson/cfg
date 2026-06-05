{ config, lib, ... }:
let scope = import ../scope.nix { inherit lib; }; in with scope;
let
  stripKeyComment = key: concatStringsSep " " (take 2 (splitString " " key));
in
{
  _module.args = { inherit scope; };
  imports = [
    ./secret.nix
  ];

  terraform.cloud = {
    hostname = "app.terraform.io";
    organization = "kwbauson";
    workspaces.name = "cfg";
  };

  terraform.required_providers = {
    porkbun.source = "cullenmcdermott/porkbun";
    github.source = "integrations/github";
  };

  provider.google = {
    project = "kwbauson";
    region = "us-east1";
    zone = "us-east1-a";
  };

  resource.github_user_ssh_key = genAttrs
    [ "keith-desktop" "keith-xps" "keith-server" ]
    (name: {
      title = name;
      key = stripKeyComment machines.${name}.public-key;
    });

  secret.porkbun_api_key.enable = true;
  secret.porkbun_secret_key.enable = true;

  provider.porkbun = {
    api_key = config.secret.porkbun_api_key.value;
    secret_key = config.secret.porkbun_secret_key.value;
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
