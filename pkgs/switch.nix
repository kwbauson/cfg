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
      ${pathAdd [ coreutils git nvd ] }
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
        isNixOS = hasAttr host nixosConfigurations;
        isNixDarwin = hasAttr host darwinConfigurations;
        nixos-toplevel = nixosConfigurations.${host}.config.system.build.toplevel;
        nix-darwin-system = darwinConfigurations.${host}.system;
        home-conf = homeConfigurations.${host};
        switchers = rec {
          nob = makeScript ''
            sudo nix-env -p /nix/var/nix/profiles/system --set ${nixos-toplevel}
            sudo ${nixos-toplevel}/bin/switch-to-configuration boot
          '';
          nos = makeScript ''
            profile=/nix/var/nix/profiles/system
            nvd diff "$profile" ${nixos-toplevel}
            sudo -H nix-env -p "$profile" --set ${nixos-toplevel}
            sudo ${nixos-toplevel}/bin/switch-to-configuration switch
          '';
          nds = makeScript ''
            profile=/nix/var/nix/profiles/system
            nvd diff "$profile" ${nix-darwin-system}
            sudo -H nix-env -p "$profile" --set ${nix-darwin-system}
            ${nix-darwin-system}/activate-user
            sudo ${nix-darwin-system}/activate
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
          noa = (makeScript (exe (if isNixOS then nos else if isNixDarwin then nds else hms))).overrideAttrs (_: { name = "${host}-noa"; });
        };
      in
      switchers.noa.overrideAttrs (_: { passthru = switchers // { inherit switchers; }; }));
  makeBin = name: makeNamedScript name /* bash */ ''
    cd ~/cfg
    git add --all
    ${getExe create-cached-refs} nix shell . "switch.scripts.$(machine-name).${name}" -c switch
  '';
in
buildEnv {
  name = pname;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)}.switchers);
  passthru = scripts // { inherit scripts; };
  meta.includePackage = true;
}
