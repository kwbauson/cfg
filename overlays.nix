[
  (self: super: {
    cfg = super.cfg or (import ./flake-compat.nix);
  })
  (self: super: with super; rec {
    mylib = with lib; with builtins; lib // rec {
      mapAttrValues = f: mapAttrs (n: v: f v);
      inherit (stdenv) isLinux isDarwin;
      sources = import ./nix/sources.nix;
      exe = pkg: with {
        binName =
          if hasAttr "pname" pkg then pkg.pname
          else if hasAttr "version" pkg then removeSuffix "-${pkg.version}" pkg.name
          else pkg.name;
      }; "${pkg}/bin/${binName}";
      isNixOS = !pathExists ./var/non-nixos;
      isGraphical = !pathExists ./var/non-graphical;
      prefixIf = b: x: y: if b then x + y else y;
      mapLines = f: s: concatMapStringsSep "\n"
        (l: if l != "" then f l else l)
        (splitString "\n" s);
      words = splitString " ";
      attrIf = check: name: if check then name else null;
      drvs = x: if isDerivation x || isList x then flatten x else flatten (mapAttrsToList (_: v: drvs v) x);
      drvsExcept = x: e: with {
        excludeNames = concatMap attrNames (attrValues e);
      }; drvs (filterAttrsRecursive (n: _: !elem n excludeNames) x);
      userName = "Keith Bauson";
      userEmail = "kwbauson@gmail.com";
      username = if isNixOS then "keith" else "keithbauson";
      homeDirectory = "/${if isDarwin then "Users" else "home"}/${username}";
      nixpkgs-rev = cfg.inputs.nixpkgs.rev;
      fakePlatform = x: x.overrideAttrs (attrs:
        { meta = attrs.meta or { } // { platforms = stdenv.lib.platforms.all; }; }
      );
      unpack = src: stdenv.mkDerivation {
        inherit src;
        inherit (src) name;
        installPhase = ''
          mkdir $out
          mv * $out
        '';
      };
      runBin = name: script: runCommand
        name
        { } ''
        mkdir -p $out/bin
        ${exe (writeShellScriptBin "script" script)} > $out/bin/${name}
        chmod +x $out/bin/${name}
      '';
      desc = pkg: (x: trace "\n${concatStringsSep "\n" x}" null) [
        "  name: ${pkg.name or pkg.pname or "null"}"
        "  description: ${pkg.meta.description or "null"}"
        "  homepage: ${pkg.meta.homepage or "null"}"
      ];
      mkDmgPackage = pname: src: stdenv.mkDerivation {
        name = pname + (if src ? version then "-${src.version}" else "");
        inherit pname src;
        ${attrIf (src ? version) "version"} = src.version;
        dontUnpack = true;
        nativeBuildInputs = [ undmg ];
        installPhase = ''
          mkdir -p $out/{Applications,bin}
          undmg "$src"
          mv *.app $out/Applications
          appdir=$(echo $out/Applications/*.app)
          [[ -d $appdir ]] || exit 1
          exe=$appdir/Contents/MacOS/${pname}
          if [[ -e $exe ]];then
            echo '#!/bin/sh' > $out/bin/${pname}
            echo "exec \"$exe\" \"\$@\"" >> $out/bin/${pname}
            chmod +x $out/bin/${pname}
          fi
        '';
      };
      dmgOverride = name: pkg: with rec {
        src = sources."dmg-${name}";
        msg = "${name}: src ${src.version} != pkg ${pkg.version}";
        checkVersion = lib.assertMsg (pkg.version == src.version) msg;
      }; if isDarwin then assert checkVersion; (mkDmgPackage name src) // { originalPackage = pkg; } else pkg;
    } // builtins;
  })
  (self: super: with super; with mylib; rec {
    homeManager = cfg.inputs.home-manager;
    homeManagerConfiguration = homeManager.lib.homeManagerConfiguration rec {
      configuration = import ./home.nix { inherit pkgs; config = configuration; };
      inherit system pkgs username homeDirectory;
    };
    defaultPackage = homeManagerConfiguration.activationPackage;
  })
  (self: super: with super; with mylib;
  mapAttrValues (src: import src { inherit system; overlays = [ ]; }) {
    inherit (sources) nixos-18_09 nixpkgs-bundler1 nixpkgs-pinned;
  })
  (self: super: with super; with mylib; rec { })
  (
    self: super: with super; with mylib; {
      # overrides
      factorio = factorio.override {
        username = "kwbauson";
        token = readFile ./secrets/factorio-token;
      };
      qutebrowser = qutebrowser.overrideAttrs (
        attrs: {
          patches = attrs.patches or [ ] ++ [ ./qutebrowser-background.patch ];
          propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ python3Packages.colorama ];
        }
      )
      ;
      chromium = chromium.override { enableWideVine = true; };
      steam-native = steam.override { nativeOnly = true; };
      steam-run-native_18-09 = nixos-18_09.steam-run-native;
      dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
      # bin
      local-bin = buildEnv {
        name = "local-bin";
        paths = flatten [
          (writeShellScriptBin "nixpkgs-rev" "echo ${nixpkgs-rev}")
          (writeShellScriptBin "nixpkgs-path" "echo ${pkgs.path}")
          (
            with rec {
              urxvt-term = ''
                urxvtc "$@"
                if [ $? -eq 2 ]; then
                   urxvtd -q -o -f
                   urxvtc "$@"
                fi
              '';
              init-file = writeText "init-file" ''
                [[ -e ~/.bash_profile ]] && . ~/.bash_profile
                PROMPT_COMMAND="$PROMPT_COMMAND; trap 'history -a; bash -c \"\$BASH_COMMAND\" < /dev/null & exit' DEBUG"
              '';
              term = writeShellScriptBin "term" ''
                [[ -n $1 ]] && set -- -e "$@"
                ${urxvt-term}
              '';
              termbar = writeShellScriptBin "termbar" ''
                set -- -name termbar -e bash --init-file ${init-file}
                ${urxvt-term}
              '';
            }; [ term termbar ]
          )
        ];
      };
      node-env-coc-explorer = vimUtils.buildVimPlugin {
        name = "coc-explorer";
        src = runCommand "coc-explorer-src" { } "cp -Lr ${(import ./node-env.nix { inherit pkgs; path = cfg.outPath; }).node_modules}/coc-explorer $out";
      };
      rnix-lsp-unstable = (callPackage sources.naersk { }).buildPackage sources.rnix-lsp-unstable;
      mach-nix = import sources.mach-nix { inherit pkgs; };
      spotify = dmgOverride "spotify" (spotify // { version = sources.dmg-spotify.version; });
      discord = dmgOverride "discord" (discord // { version = sources.dmg-discord.version; });
      inherit (nixpkgs-pinned) awscli2;
    }
  )
  (self: super: with super; with mylib; mapAttrValues fakePlatform { inherit xvfb_run acpi scrot xdotool progress; })
  (self: super: with super; with mylib; mapAttrs dmgOverride { inherit alacritty qutebrowser firefox signal-desktop; })
  (self: super: with super; with mylib; (fn: optionalAttrs
    (pathExists ./pkgs)
    (listToAttrs (mapAttrsToList fn (readDir ./pkgs)))
  ) (n: _: rec {
    name = removeSuffix ".nix" n;
    value = import (./pkgs + ("/" + n)) (pkgs // {
      inherit name;
      src = sources.${name};
    });
  }))
]
