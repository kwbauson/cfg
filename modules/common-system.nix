{ scope, username, ... }: with scope;
{
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
}
