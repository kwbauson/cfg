{ scope, ... }: with scope;
let
  devices = [ "keith-desktop" ];
  mkDevice = id: {
    inherit id;
    allowedNetworks = "100.0.0.0/8";
  };
  mkFolder = arg: if isString arg then { path = arg; inherit devices; } else arg;
in
{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-default-folder" ];
    settings = {
      devices = {
        keith-desktop = mkDevice "WLPCWRZ-SIRCUKK-2B2F6P6-XA5O7HI-DXZFMXI-UB4FAE4-6NPYQ7E-HPHSJAG";
      };
      folders = {
        notes = mkFolder "~/notes";
      };
    };
  };
}
