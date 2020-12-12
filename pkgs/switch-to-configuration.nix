pkgs: with pkgs; with mylib;
let
  hosts = words "keith-xps kwbauson keith-vm keith-mac";
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeScript = text: writeShellScriptBin "switch" text;
  inherit (cfg) nixosConfigurations homeConfigurations;
  scripts = eachHost (host: rec {
    hms = let conf = homeConfigurations.${host}; in
      makeScript ''
        [[ $(realpath /nix/var/nix/profiles/per-user/$USER/home-manager) != ${conf} ]] &&
          ${conf}/activate'';
    nos = let conf = nixosConfigurations.${host}; in
      makeScript ''
        [[ $(realpath /run/current-system) != ${conf} ]] &&
          sudo ${conf}/bin/switch-to-configuration switch
      '';
    nos-hms = makeScript ''
      ${optionalString (host != "keith-mac") (exe nos)}
      ${exe hms}
    '';
  });
  makeBin = name: writeShellScriptBin name ''
    ${pathAdd [ nix-wrapped inetutils ]}
    exec nix run ~/cfg#switch-to-configuration.scripts.$(hostname -s).${name}
  '';
in
buildEnv {
  inherit name;
  paths = map makeBin (words "hms nos nos-hms");
} // { inherit scripts; }
