{ scope, ... }: with scope;
let
  stripKeyComment = key: concatStringsSep " " (take 2 (splitString " " key));
in
{
  plugins = ps: ps.integrations_github;

  resource.github_user_ssh_key = genAttrs
    [ "keith-desktop" "keith-xps" "keith-server" ]
    (name: {
      title = name;
      key = stripKeyComment machines.${name}.public.key;
    });
}
