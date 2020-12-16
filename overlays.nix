[
  (self: super: with super; with mylib;
  mapAttrValues importNixpkgs { inherit (sources) nixos-18_09 nixpkgs-bundler1; }
  )
  (self: super: with super; with mylib; {
    programs-sqlite = copyPath "${nixos-unstable-channel.path}/programs.sqlite";
    nix-wrapped = buildEnv {
      name = "nix-wrapped";
      paths = [
        nixUnstable
        (hiPrio (
          writeShellScriptBin "nix" ''
            ${pathAdd nixUnstable}
            exec nix \
              --keep-going \
              --extra-experimental-features 'nix-command flakes ca-references' \
              --extra-substituters https://kwbauson.cachix.org \
              --extra-trusted-public-keys 'kwbauson.cachix.org-1:vwR1JZD436rg3cA/AeE6uUbVosNT4zCXqAmmsVLW8ro=' \
              "$@"
          ''
        ))
      ];
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
    node-env-coc-explorer = vimUtils.buildVimPlugin rec {
      src = copyPath "${(import ./node-env.nix { inherit pkgs; path = ./.; }).node_modules}/coc-explorer";
      name = src.name;
    };
    node-env-coc-pyright = vimUtils.buildVimPlugin rec {
      src = copyPath "${(import ./node-env.nix { inherit pkgs; path = ./.; }).node_modules}/coc-pyright";
      name = src.name;
    };
    jitsi-meet = let path = ./jitsi-meet.tar.bz2; in
      override jitsi-meet { ${attrIf (pathExists path) "src"}._replace = path; };
    rnix-lsp-unstable = cfg.inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = cfg.inputs.mach-nix.lib.${system};
    spotify = dmgOverride "spotify" (spotify // { version = sources.dmg-spotify.version; });
    discord = dmgOverride "discord" (discord // { version = sources.dmg-discord.version; });
    nle-cfg-pkgs = (self.nle { path = ./.; }).pkgs;
    inherit (self.nle-cfg-pkgs) fordir;
    inherit (self.nle-cfg-pkgs.python-env.python.pkgs) pur emborg;
    selfpkgs = buildDir ([
      ./pkgs
      ./config.nix
      ./default.nix
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
  (self: super: with super; with mylib; (fn:
    (listToAttrs (mapAttrsToList fn (readDir ./pkgs)))
  ) (n: _: rec {
    name = removeSuffix ".nix" n;
    value = import (./pkgs + ("/" + n)) (pkgs // {
      inherit name;
      src = sources.${name};
    });
  }))
]
