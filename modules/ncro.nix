{ config, scope, ... }: with scope;
{
  imports = [
    "${ncro.src}/nix/module.nix"
  ];
  services.ncro = {
    enable = true;
    settings.server.listen = "localhost:9180";
    settings.cache.negative_ttl = "${toString config.nix.settings.narinfo-cache-negative-ttl}s";
    settings.upstreams = imap (i: a: { priority = i; } // a) [
      {
        url = "http://${machines.keith-server.tailscale.fqdn}:5000";
        public_key = "${machines.keith-server.tailscale.fqdn}:amORAvA0d0VWxUnZyLPJXEY7QEKebU4SqURpe1CbsDY=";
      }
      {
        url = "http://${machines.readlee-mac-m1.tailscale.fqdn}:5000";
        public_key = "${machines.readlee-mac-m1.tailscale.fqdn}:dHyGth5OeFh3Tg2OFAQHFwtvOLJbOB/tYEzJIuogWcc=";
      }
      {
        url = "https://cache.nixos.org";
        public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
      }
      {
        url = "https://nix-community.cachix.org";
        public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      }
      {
        url = "https://kwbauson.cachix.org";
        public_key = "kwbauson.cachix.org-1:a6RuFyeJKSShV8LAUw3Jx8z48luiCU755DkweAAkwX0=";
      }
      {
        url = "https://benaduggan.cachix.org";
        public_key = "benaduggan.cachix.org-1:BY2tmi++VqJD6My4kB/dXGfxT7nJqrOtRVNn9UhgrHE=";
      }
      {
        url = "https://cache.g7c.us";
        public_key = "cache.g7c.us:dSWpE2B5zK/Fahd7npIQWM4izRnVL+a4LiCAnrjdoFY=";
      }
      {
        url = "https://devenv.cachix.org";
        public_key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
      }
    ];
  };
  nix.settings.substituters = mkForce [ "http://localhost:9180" ];
}
