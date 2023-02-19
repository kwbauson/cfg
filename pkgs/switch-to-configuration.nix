scope: with scope;
let
  inherit (flake) nixosConfigurations homeConfigurations;
  hosts = concatMap attrNames [ nixosConfigurations homeConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeNamedScript = name: text: stdenv.mkDerivation {
    inherit name;
    dontUnpack = true;
    script = ''
      #!${bash}/bin/bash
      set -e
      ${pathAdd [ nix-wrapped coreutils git nvd ] }
      ${text}
    '';
    passAsFile = "script";
    installPhase = ''
      mkdir -p $out/bin
      cp $scriptPath $out/bin/${name}
      chmod +x $out/bin/${name}
    '';
    meta.mainProgram = name;
  };
  makeScript = makeNamedScript "switch";
  scripts = eachHost
    (host:
      let
        isNixOS = elem host [ "keith-desktop" "kwbauson" "keith-xps" ];
        nixos-toplevel = nixosConfigurations.${host}.config.system.build.toplevel;
        home-conf = homeConfigurations.${host};
      in
      rec {
        nob = makeScript ''
          sudo nix-env -p /nix/var/nix/profiles/system --set ${nixos-toplevel}
          sudo ${conf}/bin/switch-to-configuration boot
        '';
        nos = makeScript ''
          if [[ $(realpath /run/current-system) != ${nixos-toplevel} ]];then
            nvd diff /run/current-system ${nixos-toplevel}
            sudo nix-env -p /nix/var/nix/profiles/system --set ${nixos-toplevel}
            sudo ${nixos-toplevel}/bin/switch-to-configuration switch
          fi
        '';
        hms = makeScript ''
          hm_path=$(nix-env -q home-manager-path --out-path --no-name 2> /dev/null || true)
          if [[ $hm_path != ${home-conf.config.home.path} ]];then
            if [[ -n $hm_path ]];then
              nvd diff $hm_path ${home-conf.config.home.path}
            fi
            ${home-conf.activationPackage}/activate
          fi
        '';
        noa = (makeScript (if isNixOS then exe nos else exe hms)).overrideAttrs (_: { name = "${host}-noa"; });
      }) // { unknown.noa = null; };
  makeBin = name: makeNamedScript name ''
    cd ~/cfg
    git add --all
    exec nix run .#switch-to-configuration.scripts.$(built-as-host).${name} "$@"
  '';
in
buildEnv {
  name = pname;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
}
