{ scope, ... }: with scope;
let
  stripKeyComment = key: concatStringsSep " " (take 2 (splitString " " key));
in
{
  terraform.required_providers.github.source = "integrations/github";

  resource.github_user_ssh_key = genAttrs
    [ "keith-desktop" "keith-xps" "keith-server" ]
    (name: {
      title = name;
      key = stripKeyComment machines.${name}.public.key;
    });
}
