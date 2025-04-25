{ config, scope, isMinimal, ... }: with scope;
{
  imports = [
    nixvim.flake.homeManagerModules.nixvim
    { programs.nixvim = nixvim.configuration; }
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
  };
}
