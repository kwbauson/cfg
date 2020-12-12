pkgs: with pkgs; with mylib;
let
  script = writeShellScriptBin name ''
    ${pathAdd [ nix-wrapped inetutils ]}
    exec nix run ~/cfg#switch-to-configuration.switch.$(hostname -s)
  '';
  hosts = words "keith-xps kwbauson keith-vm keith-mac";
  switchToHost = hostname: writeShellScriptBin "switch-${hostname}" ''
    ${optionalString (hostname != "keith-mac")
      "sudo ${cfg.nixosConfigurations.${hostname}}/bin/switch-to-configuration switch"
    }
    ${cfg.homeConfigurations.${hostname}}/activate
  '';
  switch = listToAttrs (map (name: { inherit name; value = switchToHost name; }) hosts);
in
script // { inherit switch; }
