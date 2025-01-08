{ config, username, scope, machine-name, ... }: with scope;
let
  devices = [ "keith-desktop" "keith-xps" ];
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
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = elem machine-name (attrNames config.services.syncthing.settings.devices);
    settings = {
      options = {
        listenAddresses = [ "tcp://${constants.${machine-name}.ip}:22000" ];
        relaysEnabled = false;
        globalAnnounceEnabled = false;
        urAccepted = -1;
      };
      devices = mkDevices {
        keith-desktop = mkDevice "WLPCWRZ-SIRCUKK-2B2F6P6-XA5O7HI-DXZFMXI-UB4FAE4-6NPYQ7E-HPHSJAG";
        keith-xps = mkDevice "TLPHMKL-SMTBB6W-OODSBGW-DXQ36UB-ILKK67U-2ZKPIKI-G4TZNSP-UMWXNAH";
      };
      folders = {
        notes = mkFolder "${home}/notes";
      };
    };
  };
}