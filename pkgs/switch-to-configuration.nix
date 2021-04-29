pkgs: with pkgs; with mylib;
let
  inherit (cfg) nixosConfigurations homeConfigurations;
  hosts = concatMap attrNames [ nixosConfigurations homeConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeNamedScript = name: text: (writeBashBin name
    ''
      ${pathAdd [ nix-wrapped coreutils git ] }
      ${text}
    '').overrideAttrs
    (_: { meta.mainProgram = name; });
  makeScript = makeNamedScript "switch";
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
    nos-hms = (makeScript ''
      ${optionalString isNixOS (exe nos)}
      ${exe hms}
    '').overrideAttrs (_: { name = "${host}-nos-hms"; });
  });
  makeBin = name: makeNamedScript name ''
    git -C ~/cfg add --all
    exec nix run ~/cfg#switch-to-configuration.scripts.$(built-as-host).${name}
  '';
in
buildEnv {
  inherit name;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
}
