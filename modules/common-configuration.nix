{ scope, ... }: with scope;
{
  imports = [
    modules.machine
    modules.auto-update
    modules.grafana-data-sources
    modules.secrets
  ];
  nixpkgs.pkgs = scope.pkgs;
  environment.etc."nixpkgs-path".source = nixpkgsPath;
  nix.package = lixPackageSets.latest.lix;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings = {
    max-jobs = "auto";
    keep-going = true;
    fallback = true;
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [ "nix-command" "flakes" ];
    extra-deprecated-features = [ "shadow-internal-symbols" "broken-string-escape" ];
    narinfo-cache-negative-ttl = 10;
    extra-substituters = [ "https://kwbauson.cachix.org" ];
    extra-trusted-public-keys = [ "kwbauson.cachix.org-1:a6RuFyeJKSShV8LAUw3Jx8z48luiCU755DkweAAkwX0=" ];
    warn-dirty = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit scope; };
    users.${username}.imports = [ modules.home-manager ];
  };

  users.users.${username}.openssh.authorizedKeys.keys =
    let names = [ "keith-desktop" "keith-xps" "keith-server" ]; in
    mapAttrsToList (_: m: m.public-key) (getAttrs names machines);

  secrets.cachix-dhall = {
    enable = elem machine.name [ "keith-desktop" "keith-xps" "keith-server" "readlee-mac-m1" ];
    isShared = true;
    isUser = true;
  };
}
