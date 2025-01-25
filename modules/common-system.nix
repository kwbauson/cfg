{ scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.args
    modules.auto-update
  ];
  environment.etc."nixpkgs-path".source = pkgs.path;
  nix.package = lix;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings = {
    max-jobs = "auto";
    keep-going = true;
    fallback = true;
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [ "nix-command" "flakes" ];
    narinfo-cache-negative-ttl = 10;
    extra-substituters = [ "https://kwbauson.cachix.org" ];
    extra-trusted-public-keys = [ "kwbauson.cachix.org-1:a6RuFyeJKSShV8LAUw3Jx8z48luiCU755DkweAAkwX0=" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit scope machine-name; };
    users.${username}.imports = [ modules.home-manager ];
  };

  users.users.${username}.openssh.authorizedKeys.keys = pipe ../authorized_keys [
    readFile
    (splitString "\n")
    (filter (x: x != ""))
  ];
}
