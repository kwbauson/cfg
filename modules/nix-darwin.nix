{ scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.common-system
    machines.${machine-name}.darwin-configuration
    inputs.home-manager.darwinModules.default
  ];
  nix.settings.extra-platforms = [ "x86_64-darwin" ];
  nix.settings.trusted-users = [ username ];
  system.darwinLabel = "${machine-name}-${flakeLastModifiedDateString}";
  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };
  homebrew.enable = true;
  homebrew.global.autoUpdate = false;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.casks = map (name: { inherit name; }) [ "tailscale-app" "firefox" "google-chrome" "docker-desktop" ];
  services.auto-update.enable = true;
  system.stateVersion = 5;
}
