{ scope, ... }: with scope;
{
  imports = attrValues (removeAttrs (importDir ./.) [ ".terraform" "config" ]);

  terraform.cloud = {
    hostname = "app.terraform.io";
    organization = "kwbauson";
    workspaces.name = "cfg";
  };
}
