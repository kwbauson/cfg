{ config, username, scope, machine-name, ... }: with scope;
let
  devices = [ "keith-server" "keith-desktop" "keith-xps" ];
  mkDevices = mapAttrs (name: value: {
    addresses = [ "tcp://${constants.${name}.ip}" ];
    autoAcceptFolders = true;
  } // value);
  mkDevice = id: {
    inherit id;
    # allowedNetworks = "100.0.0.0/8";
  };
  mkFolder = arg: if isString arg then { path = arg; inherit devices; } else arg;
  inherit (config.users.users.${username}) home;
in
{
  services.syncthing = {
    enable = elem machine-name (attrNames config.services.syncthing.settings.devices);
    extraFlags = [ "--no-default-folder" ];
    settings = {
      options = {
        listenAddresses = [ "tcp://${constants.${machine-name}.ip}:22000" ];
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        urAccepted = -1;
      };
      devices = mkDevices {
        keith-server = mkDevice "4UZWH3Y-YRO6MCJ-XNOQEYI-M2LK4OK-LZETKPQ-5Q5MSVT-WGKELCY-5KCWQQV";
        keith-desktop = mkDevice "WLPCWRZ-SIRCUKK-2B2F6P6-XA5O7HI-DXZFMXI-UB4FAE4-6NPYQ7E-HPHSJAG";
        keith-xps = mkDevice "TLPHMKL-SMTBB6W-OODSBGW-DXQ36UB-ILKK67U-2ZKPIKI-G4TZNSP-UMWXNAH";
      };
      folders = {
        notes = mkFolder "${home}/notes";
      };
    };
  };
}
