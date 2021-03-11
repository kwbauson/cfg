[
  (self: super: with super; with mylib; mapAttrValues importNixpkgs {
    inherit (sources) nixos-unstable nixos-20_09 nixos-18_09 nixpkgs-bundler1;
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
      extra-programs = toFile "extra-programs" (
        joinLines
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
          ]
      );
      installPhase = ''
        cp ${nixos-unstable.path}/programs.sqlite $out
        chmod +w $out
        sqlite3 $out <<EOF
        .mode csv
        .import ${extra-programs} Programs
        EOF
      '';
    };
    isNixOS = false;
    nix-wrapped =
      if self.isNixOS
      then self.nixUnstable
      else wrapBins self.nixUnstable ''NIX_USER_CONF_FILES=${writeText "nix.conf" cfg.nixConf} exec "$exePath" "$@"'';
    steam-native = steam.override { nativeOnly = true; };
    steam-run-native_18-09 = nixos-18_09.steam-run-native;
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    buildNpmVimPlugin = name: vimUtils.buildVimPlugin {
      inherit name;
      src = copyPath "${(import ./npm-env.nix { inherit pkgs; path = ./.; }).node_modules}/${name}";
    };
    npm-coc-explorer = self.buildNpmVimPlugin "coc-explorer";
    jitsi-meet = override jitsi-meet { src = ./jitsi-meet.tar.bz2; };
    rnix-lsp-unstable = cfg.inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = import cfg.inputs.mach-nix {
      inherit pkgs;
      pypiDataRev = cfg.inputs.pypi-deps-db.rev;
      pypiDataSha256 = cfg.inputs.pypi-deps-db.narHash;
    };
    nle-cfg = self.nle { path = ./.; };
    inherit (self.nle-cfg.pkgs) fordir;
    inherit (self.nle-cfg.pkgs.poetry-env.python.pkgs) pur emborg git-remote-codecommit;
    inherit (self.nle-cfg.pkgs.bundler-env.gems) pry fakes3;
    selfpkgs = buildDir ([
      ./mylib.nix
    ] ++ self.nle.lib.build-paths ./.);
    desc = pkg: (x: trace "\n${concatStringsSep "\n" x}" null) [
      "  name: ${pkg.name or pkg.pname or "null"}"
      "  description: ${pkg.meta.description or "null"}"
      "  homepage: ${pkg.meta.homepage or "null"}"
    ];
    inherit (nixos-unstable) chromium diffoscope;
    inherit (nixos-20_09) saml2aws postgresql_10 nodejs-10_x;
    nix-prefetch-git = nix-prefetch-git.override { nix = self.nixUnstable; };
    bundix = bundix.override { nix = self.nixUnstable; };
    pinned-if-darwin = if isDarwin then nixos-unstable else super;
    inherit (self.pinned-if-darwin) wget;
    allowUnsupportedSystem = import pkgs.path {
      inherit system;
      config = cfg.config // { allowUnsupportedSystem = true; };
    };
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
  } // mapAttrs dmgOverride { inherit alacritty qutebrowser firefox signal-desktop brave; })
]
