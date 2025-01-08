{ scope, ... }: with scope;
let
  devices = [ "keith-desktop" "keith-xps" ];
  mkDevices = mapAttrs (name: value: {
    addresses = [ "tcp://${name}" ];
    autoAcceptFolders = true;
  } // value);
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
      options = {
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        urAccepted = -1;
      };
      devices = mkDevices {
        keith-desktop = mkDevice "WLPCWRZ-SIRCUKK-2B2F6P6-XA5O7HI-DXZFMXI-UB4FAE4-6NPYQ7E-HPHSJAG";
        keith-xps = mkDevice "TLPHMKL-SMTBB6W-OODSBGW-DXQ36UB-ILKK67U-2ZKPIKI-G4TZNSP-UMWXNAH";
      };
      folders = {
        notes = mkFolder "~/notes";
      };
    };
  };
}
