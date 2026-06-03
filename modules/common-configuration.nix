{ config, scope, ... }: with scope;
{
  imports = [
    modules.machine
    modules.auto-update
    modules.grafana-data-sources
    "${agenix.src}/modules/age.nix"
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

  age.identityPaths = [ "${config.users.users.${username}.home}/.ssh/id_ed25519" ];
  age.secrets = pipeValue [
    (import ../secrets/secrets.nix { inherit scope; })
    (filterAttrs (_: v: elem machine.public-key v.publicKeys))
    (mapAttrs (_: v: if v.isUserSecret or false then v // { owner = username; } else v))
    (mapAttrs (_: v: removeAttrs v [ "publicKeys" "isUserSecret" ]))
    (mapAttrs' (n: v: nameValuePair (removeSuffix ".age" n) (v // { file = ../secrets/${n}; })))
  ];
}
