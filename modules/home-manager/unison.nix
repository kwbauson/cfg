{ config, scope, machine-name, ... }: with scope;
let
  sync-machines = [ "keith-desktop" "keith-xps" ];
in
{
  home.packages = [ unison ];
  services.unison = {
    enable = elem machine-name sync-machines;
    pairs.sync.roots = [
      "${config.home.homeDirectory}/sync"
      "ssh://keith-server/sync"
    ];
  };
}
