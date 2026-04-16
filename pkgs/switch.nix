scope: with scope;
let
  hosts = concatMap attrNames [ nixosConfigurations darwinConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeNamedScript = name: text: stdenvNoCC.mkDerivation {
    inherit name;
    preferLocalBuild = true;
    allowSubstitutes = false;
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
            sudo ${nix-darwin-system}/activate
          '';
          noa = (makeScript (exe (if isNixOS then nos else if isNixDarwin then nds else hms))).overrideAttrs (_: { name = "${host}-noa"; });
        };
      in
      switchers.noa.overrideAttrs (_: { passthru = switchers // { inherit switchers; }; }));
  makeBin = name: makeNamedScript name /* bash */ ''
    cd ~/cfg
    git add --all -N
    ${getExe cached-refs} kwbauson checks.${system} shell . "switch.scripts.$(machine-name).${name}" -c switch
  '';
in
buildEnv {
  name = pname;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)}.switchers);
  passthru = scripts // { inherit scripts; };
  meta.includePackage = true;
}
