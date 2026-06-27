{ scope, ... }: with scope;
{
  imports = [
    modules.machine
    modules.auto-update
    modules.grafana-data-sources
    modules.secrets
    modules.ncro
  ];
  nixpkgs.pkgs = scope.pkgs;
  environment.etc.cfg-path.source = cfg.outPath;
  environment.etc.nixpkgs-path.source = nixpkgsPath;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings = {
    max-jobs = "auto";
    keep-going = true;
    fallback = true;
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [ "nix-command" "flakes" ];
    narinfo-cache-negative-ttl = 10;
    warn-dirty = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit scope; };
    users.${username}.imports = [ modules.home-manager ];
  };

  users.users.${username}.openssh.authorizedKeys.keys =
    let names = [ "keith-desktop" "keith-xps" "keith-server" ]; in
    mapAttrsToList (_: m: m.public.key) (getAttrs names machines);

  secrets.cachix.user = true;
}
