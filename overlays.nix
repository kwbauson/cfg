[
  (self: super: with super; with mylib;
  mapAttrValues importNixpkgs { inherit (sources) nixos-18_09 nixpkgs-bundler1; }
  )
  (self: super: with super; with mylib; {
    programs-sqlite = stdenv.mkDerivation rec {
      name = "programs-sqlite";
      buildInputs = [ sqlite ];
      dontUnpack = true;
      extra-programs = toFile "extra-programs" (
        concatMapStringsSep ","
          (s: if isString s then "${s},x86_64-linux,${s}" else "${head s},x86_64-linux,${lib.last s}")
          [
            "nle"
            [ "nix-local-env" "nle" ]
            "nr"
            "evilhack"
            "git-trim"
            "fordir"
            "inlets"
          ]
      );
      installPhase = ''
        cp ${nixos-unstable-channel.path}/programs.sqlite $out
        chmod +w $out
        sqlite3 $out <<EOF
        .mode csv
        .import ${extra-programs} Programs
        EOF
      '';
    };
    isNixOS = false;
    nix-wrapped = (
      if self.isNixOS
      then nixUnstable
      else buildEnv {
        name = "nix-wrapped";
        paths = [
          nixUnstable
          (hiPrio (writeShellScriptBin "nix" '' exec ${exe nixUnstable} ${self.nix-wrapped.flags} "$@" ''))
        ];
      }
    ) // rec {
      options = [
        "keep-going"
        "builders-use-substitutes"
        [ "extra-experimental-features" "nix-command flakes ca-references" ]
        [ "extra-substituters" "https://kwbauson.cachix.org" ]
        [ "extra-trusted-public-keys" "kwbauson.cachix.org-1:vwR1JZD436rg3cA/AeE6uUbVosNT4zCXqAmmsVLW8ro=" ]
      ];
      flags = concatMapStringsSep " " (s: if isString s then "--${s}" else "--${head s} '${lib.last s}'") options;
      conf = concatMapStringsSep "\n" (s: if isString s then "${s} = true" else concatStringsSep " = " s) options;
    };
    factorio = factorio.override {
      username = "kwbauson";
      token = readFile ./secrets/factorio-token;
    };
    qutebrowser = override qutebrowser { patches = [ ./qutebrowser-background.patch ]; };
    i3 = override i3 { patches = [ ./i3-icons.patch ]; };
    steam-native = steam.override { nativeOnly = true; };
    steam-run-native_18-09 = nixos-18_09.steam-run-native;
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    buildNpmVimPlugin = name: vimUtils.buildVimPlugin {
      inherit name;
      src = copyPath "${(import ./node-env.nix { inherit pkgs; path = ./.; }).node_modules}/${name}";
    };
    npm-coc-explorer = self.buildNpmVimPlugin "coc-explorer";
    npm-coc-pyright = self.buildNpmVimPlugin "coc-pyright";
    npm-coc-deno = self.buildNpmVimPlugin "coc-deno";
    jitsi-meet = override jitsi-meet { src = ./jitsi-meet.tar.bz2; };
    rnix-lsp-unstable = cfg.inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = cfg.inputs.mach-nix.lib.${system};
    spotify = dmgOverride "spotify" (spotify // { version = sources.dmg-spotify.version; });
    discord = dmgOverride "discord" (discord // { version = sources.dmg-discord.version; });
    nle-cfg-pkgs = (self.nle { path = ./.; }).pkgs;
    yarn2nix = import sources.yarn2nix { pkgs = import "${sources.yarn2nix}/nixpkgs-pinned.nix" { inherit system; }; };
    inherit (self.nle-cfg-pkgs) fordir;
    inherit (self.nle-cfg-pkgs.python-env.python.pkgs) pur emborg;
    selfpkgs = buildDir ([
      ./pkgs
      ./config.nix
      ./flake-compat.nix
      ./mylib.nix
      ./overlays.nix
    ] ++ self.nle.lib.build-paths ./.);
  })
  (self: super: with super; with mylib;
  mapAttrValues fakePlatform { inherit xvfb_run acpi scrot xdotool progress; }
  )
  (self: super: with super; with mylib;
  mapAttrs dmgOverride { inherit alacritty qutebrowser firefox signal-desktop; }
  )
  (self: super: with super; with mylib;
  mapAttrs (name: f: f (pkgs // { inherit name; src = sources.${name}; })) (importDir ./pkgs)
  )
]
