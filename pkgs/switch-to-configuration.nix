pkgs: with pkgs; with mylib;
let
  hosts = concatMap attrNames [ cfg.nixosConfigurations cfg.homeConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeScript = text: writeShellScriptBin "switch" text;
  inherit (cfg) nixosConfigurations homeConfigurations;
  profile = name: "/nix/var/nix/profiles/${name}";
  scripts = eachHost (host: rec {
    nos = let conf = nixosConfigurations.${host}; in
      makeScript ''
        if [[ $(realpath ${profile "system"}) != ${conf} ]];then
          sudo nix-env -p ${profile "system"} --set ${conf}
          sudo ${conf}/bin/switch-to-configuration switch
        fi
      '';
    nob = makeScript "sudo ${nixosConfigurations.${host}}/bin/switch-to-configuration boot";
    hms = let conf = homeConfigurations.${host}; in
      makeScript ''
        if [[ $(realpath ${profile "per-user/$USER/home-manager"}) != ${conf} ]];then
          ${conf}/activate
        fi
      '';
    nos-hms = makeScript ''
      ${optionalString (host != "keith-mac") (exe nos)}
      ${exe hms}
    '';
  });
  makeBin = name: writeShellScriptBin name ''
    ${pathAdd [ nix-wrapped inetutils git ]}
    git -C ~/cfg add --intent-to-add .
    exec nix run ~/cfg#switch-to-configuration.scripts.$(hostname -s).${name}
  '';
in
buildEnv {
  inherit name;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
}
