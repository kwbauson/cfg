[
  (self: super: with super; with mylib; mapAttrValues importNixpkgs {
    inherit (sources) nixos-unstable nixos-20_09 nixos-18_09;
  })
  (_: super: with super; with mylib; {
    nix-wrapped =
      if isNixOS
      then nixUnstable
      else wrapBins nixUnstable ''NIX_CONFIG=$(< ${toFile "nix.conf" cfg.nixConf}) exec "$exePath" "$@"'';
  })
  (self: super: with super; with mylib; {
    latestWrapper = pkg: wrapBins pkg ''
      ${pathAdd self.nix-wrapped}
      if [[ $LATEST = 1 ]];then
        exec "$exePath" "$@"
      else
        LATEST=1 exec nix shell github:kwbauson/cfg#${pkg.name} -c "$exe" "$@"
      fi
    '';
    programs-sqlite = stdenv.mkDerivation rec {
      name = "programs-sqlite";
      buildInputs = [ sqlite ];
      dontUnpack = true;
      extraPrograms = joinLines
        (x: "${x},x86_64-linux,${x}")
        (x: y: "${x},x86_64-linux,${y}")
        [
          "nle"
          [ "nix-local-env" "nle" ]
          "nr"
          "evilhack"
          "git-trim"
          "fordir"
          "inlets"
          "juicefs"
          "pur"
          "emborg"
        ];
      passAsFile = "extraPrograms";
      installPhase = ''
        cp ${sources.nixos-unstable}/programs.sqlite $out
        chmod +w $out
        sqlite3 $out <<EOF
        .mode csv
        .import $extraProgramsPath Programs
        EOF
      '';
    };
    steam-native = steam.override { nativeOnly = true; };
    steam-run-native_18-09 = nixos-18_09.steam-run-native;
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    buildNpmVimPlugin = name: vimUtils.buildVimPlugin {
      inherit name;
      src = copyPath "${(import ./npm-env.nix { inherit pkgs; path = ./.; }).node_modules}/${name}";
    };
    npm-coc-explorer = self.buildNpmVimPlugin "coc-explorer";
    jitsi-meet = override jitsi-meet { src = ./jitsi-meet.tar.bz2; };
    rnix-lsp-unstable = inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = import inputs.mach-nix {
      inherit pkgs;
      pypiDataRev = inputs.pypi-deps-db.rev;
      pypiDataSha256 = inputs.pypi-deps-db.narHash;
    };
    nle-cfg = self.nle { path = ./.; };
    inherit (self.nle-cfg.pkgs) fordir;
    inherit (self.nle-cfg.pkgs.poetry-env.python.pkgs) pur emborg git-remote-codecommit;
    inherit (self.nle-cfg.pkgs.bundler-env.gems) pry fakes3;
    desc = pkg: (x: trace "\n${concatStringsSep "\n" x}" null) [
      "  name: ${pkg.name or pkg.pname or "null"}"
      "  description: ${pkg.meta.description or "null"}"
      "  homepage: ${pkg.meta.homepage or "null"}"
    ];
    nix-prefetch-git = nix-prefetch-git.override { nix = nixUnstable; };
    bundix = bundix.override { nix = nixUnstable; };
    pinned-if-darwin = if isDarwin then nixos-20_09 else super;
    allowUnsupportedSystem = import pkgs.path {
      inherit system;
      config = cfg.config // { allowUnsupportedSystem = true; };
    };
    inherit (nixos-unstable);
    inherit (nixos-20_09);
    inherit (self.pinned-if-darwin);
  })
  (self: super: with super; with mylib;
  mapAttrs (name: f: callPackage f (pkgs // { inherit name; pname = name; src = sources.${name}; })) (importDir ./pkgs)
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
