{ scope, ... }: with scope;
{
  imports = attrValues (removeAttrs (importDir ./.) [ ".terraform" "config" ]);

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
}
