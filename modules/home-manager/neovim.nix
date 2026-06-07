{ scope, ... }: with scope;
{
  imports = [
    inputs.nixvim.homeModules.default
    { programs.nixvim = nixvim.configuration; }
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
  };
}
