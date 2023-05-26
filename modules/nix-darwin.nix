{ scope, machine-name, darwin-username, ... }: with scope;
{
  imports = [
    machines.${machine-name}.darwin-configuration
    inputs.home-manager.darwinModule
  ];
  users.users.${darwin-username}.home = "/Users/${darwin-username}";
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit scope machine-name; };
    users.${darwin-username}.imports = [ modules.home-manager ];
  };
  services.nix-daemon.enable = true;
  environment.etc."nixpkgs-path".source = pkgs.path;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs-path" ];
  nix.settings.trusted-users = [ "@wheel" ];
  nix.extraOptions = nixConf;
  system.defaults.finder.AppleShowAllExtensions = true;
  homebrew.enable = true;
  homebrew.taps = [ "homebrew/cask" ];
  homebrew.global.autoUpdate = false;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.casks = map (name: { inherit name; greedy = true; }) [ "tailscale" "firefox" "google-chrome" "docker" ];
}
