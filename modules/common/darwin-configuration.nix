{ scope, machine-name, ... }: with scope;
{
  imports = [
    machines.${machine-name}.darwin-configuration
    inputs.home-manager.darwinModule
  ];
  users.users.keithbauson = {
    home = mkDefault "/Users/keithbauson";
  };
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit machine-name pkgs; inherit (pkgs) scope; };
    users.keithbauson.imports = [ modules.common.home ];
  };
}
