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
    lint-short-path-literals = "fatal";
    lint-url-literals = "fatal";
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit scope; };
    users.${username}.imports = [ modules.home-manager ];
  };

  users.users.${username}.openssh.authorizedKeys.keys =
    let
      names = [ "keith-desktop" "keith-xps" "keith-server" ];
      machineKeys = mapAttrsToList (_: m: m.public.key) (getAttrs names machines);
    in
    machineKeys ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXnCWxJTyJFiLPmxKuAiN12Tq8fTLshB4zhfX2Zx7gM keith-pixel"
    ];

  secrets.cachix.user = true;
}
