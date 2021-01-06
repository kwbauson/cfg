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
            "pur"
            "emborg"
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
      then self.nixUnstable
      else buildEnv {
        name = "nix-wrapped";
        paths = [
          self.nixUnstable
          (hiPrio (alias "nix" "${exe self.nixUnstable} ${self.nix-wrapped.flags}"))
        ];
      }
    ) // rec {
      options = [
        [ "max-jobs" "auto" ]
        "keep-going"
        "builders-use-substitutes"
        [ "extra-experimental-features" "nix-command flakes ca-references" ]
        [ "extra-substituters" "https://kwbauson.cachix.org" ]
        [ "extra-trusted-public-keys" "kwbauson.cachix.org-1:vwR1JZD436rg3cA/AeE6uUbVosNT4zCXqAmmsVLW8ro=" ]
      ];
      flags = joinStrings " " (x: "--${x}") (x: y: "--${x} '${y}'") options;
      conf = joinLines (x: "${x} = true") (x: y: "${x} = ${y}") options;
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
    inherit (self.nle-cfg-pkgs) fordir;
    inherit (self.nle-cfg-pkgs.python-env.python.pkgs) pur emborg;
    pinned-if-darwin = if isDarwin then nixos-unstable-channel else prev;
    inherit (self.pinned-if-darwin) nix nixUnstable;
    selfpkgs = buildDir ([
      ./pkgs
      ./config.nix
      ./flake-compat.nix
      ./mylib.nix
      ./overlays.nix
    ] ++ self.nle.lib.build-paths ./.);
    desc = pkg: (x: trace "\n${concatStringsSep "\n" x}" null) [
      "  name: ${pkg.name or pkg.pname or "null"}"
      "  description: ${pkg.meta.description or "null"}"
      "  homepage: ${pkg.meta.homepage or "null"}"
    ];
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
