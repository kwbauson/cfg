{ scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.common-system
    machines.${machine-name}.darwin-configuration
    inputs.home-manager.darwinModule
  ];
  documentation.enable = false;
  users.users.${username}.home = "/Users/${username}";
  services.nix-daemon.enable = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  homebrew.enable = true;
  homebrew.taps = [ "homebrew/cask" ];
  homebrew.global.autoUpdate = false;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.casks = map (name: { inherit name; }) [ "tailscale" "firefox" "google-chrome" "docker" ];
  services.auto-update.enable = true;
  home-manager.users.${username}.manual.manpages.enable = false;
}
