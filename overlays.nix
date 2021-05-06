[
  (self: super: with super; with mylib; mapAttrValues importNixpkgs {
    inherit (sources) nixos-unstable nixos-20_09 nixos-18_09 nixpkgs-bundler1;
  })
  (self: super: with super; with mylib; {
    nix-wrapped =
      if isNixOS
      then self.nixUnstable
      else
        wrapBins self.nixUnstable ''
          export NIX_USER_CONF_FILES=${toFile "nix.conf" cfg.nixConf}:$NIX_USER_CONF_FILES
          exec "$exePath" "$@"
        '';
  })
  (self: super: with super; with mylib; {
    latestWrapper = name: pkg: wrapBins pkg ''
      ${pathAdd self.nix-wrapped}
      if [[ $LATEST = 1 ]];then
        exec "$exePath" "$@"
      else
        LATEST=1 exec nix shell github:kwbauson/cfg#${name} -c "$exe" "$@"
      fi
    '';
    programs-sqlite = stdenv.mkDerivation rec {
      name = "programs-sqlite";
      buildInputs = [ sqlite ];
      dontUnpack = true;
      extraPrograms =
        let
          subPackages = name: map (x: "${name}.${x}") (attrNames self.${name});
        in
        joinLines
          (x: "${x},x86_64-linux,${x}")
          (x: y: "${x},x86_64-linux,${y}")
          (
            [
              [ "nix-local-env" "nle" ]
              [ "termbar" "term" ]
            ]
            ++ (attrNames (readDir ./bin))
            ++ (attrNames self)
            ++ (subPackages "nodePackages")
            ++ (subPackages "python3Packages")
            ++ (subPackages "rubyPackages")
          );
      passAsFile = "extraPrograms";
      installPhase = ''
        cp ${sources.nixos-unstable}/programs.sqlite $out
        sqlite3 $out --csv 'select * from Programs' > current
        grep -vFf current $extraProgramsPath > extra
        chmod +w $out
        sqlite3 $out <<EOF
        .mode csv
        .import extra Programs
        EOF
      '';
    };
    steam-native = self.steam.override { nativeOnly = true; };
    steam-run-native_18-09 = nixos-18_09.steam-run-native;
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    jitsi-meet = override jitsi-meet { src = ./jitsi-meet.tar.bz2; };
    rnix-lsp-unstable = inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = inputs.mach-nix // import inputs.mach-nix {
      inherit pkgs;
      pypiDataRev = inputs.pypi-deps-db.rev;
      pypiDataSha256 = inputs.pypi-deps-db.narHash;
    };
    nle-cfg = self.nle.build { path = ./.; };
    inherit (self.nle-cfg.pkgs) fordir;
    inherit (self.nle-cfg.pkgs.poetry-env.python.pkgs) pur emborg git-remote-codecommit;
    inherit (self.nle-cfg.pkgs.bundler-env.gems) fakes3;
    nix-prefetch-git = nix-prefetch-git.override { nix = nixUnstable; };
    bundix = bundix.override { nix = nixUnstable; };
    pinned-if-darwin = if isDarwin then nixos-20_09 else super;
    allowUnsupportedSystem = import pkgs.path {
      inherit system;
      config = cfg.config // { allowUnsupportedSystem = true; };
    };
    contentAddressedByDefault = import pkgs.path {
      inherit system;
      config = cfg.config // { contentAddressedByDefault = true; };
    };
    contentAddressed = mapAttrs (_: pkg: if pkg ? overrideAttrs then pkg.overrideAttrs (_: { __contentAddressed = true; }) else pkg) pkgs;
    inherit (nixos-unstable);
    inherit (nixos-20_09);
    inherit (self.pinned-if-darwin);
    switch = self.switch-to-configuration.scripts.${builtAsHost}.noa;
    pynixify = let python = python3.override {
      packageOverrides = self: super: {
        pynixify = self.callPackage "${sources.pynixify}/nix/packages/pynixify" { };
      };
    }; in python.pkgs.toPythonApplication python.pkgs.pynixify;
    nle-config = (import ./nle).withConfig { nixpkgs = { inherit (pkgs) system path; }; };
    nixosModules = importDir "${inputs.nixpkgs}/nixos/modules";
  })
  (self: super: with super; with mylib;
  mapAttrs
    (name: f: callPackage f (pkgs // {
      inherit name;
      pname = name;
      src = sources.${name};
      ${name} = super.${name};
    }))
    (importDir ./pkgs)
  )
  (self: super: with super; with mylib;
  mapDirEntries
    (n: value:
      optionalAttrs (hasSuffix ".patch" n) rec {
        name = removeSuffix ".patch" n;
        value = override super.${name} { patches = [ (./pkgs + ("/" + n)) ]; };
      }
    ) ./pkgs
  )
  (self: super: with super; with mylib; {
    spotify = dmgOverride "spotify" (spotify // { version = sources.dmg-spotify.version; });
    discord = dmgOverride "discord" (discord // { version = sources.dmg-discord.version; });
  } // mapAttrs dmgOverride { inherit firefox signal-desktop brave; })
]
