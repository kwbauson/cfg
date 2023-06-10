{ scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.auto-update
  ];
  _module.args.username = lib.mkDefault "keith";
  environment.etc."nixpkgs-path".source = pkgs.path;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings.trusted-users = [ "@wheel" ];
  nix.extraOptions = nixConf;

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
