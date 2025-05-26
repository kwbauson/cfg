{ scope, ... }: with scope;
{
  imports = [
    nixvim.flake.homeModules.nixvim
    { programs.nixvim = nixvim.configuration; }
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
  };
}
