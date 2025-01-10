{ config, scope, machine-name, ... }: with scope;
let
  sync-machines = [ "keith-desktop" "keith-xps" ];
in
mkMerge [
  { home.packages = [ unison ]; }
  (mkIf (elem machine-name sync-machines) {
    services.unison = {
      enable = true;
      pairs.sync.roots = [
        "${config.home.homeDirectory}/sync"
        "ssh://keith-server/sync"
      ];
    };
    systemd.user.services = forAttrs' config.services.unison.pairs (name: _: {
      name = "unison-pair-${name}";
      value = {
        Unit.After = [ "network-online.target" ];
      };
    });
  })
]
