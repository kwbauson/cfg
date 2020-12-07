[
  (self: super: { cfg = super.cfg or (import ./flake-compat.nix); })
  (self: super: (x: { mylib = x; }) (with super; with lib; with builtins; lib // rec {
    mapAttrValues = f: mapAttrs (n: v: f v);
    inherit (stdenv) isLinux isDarwin;
    sources = import ./nix/sources.nix;
    exe = pkg: with {
      binName =
        if hasAttr "pname" pkg then pkg.pname
        else if hasAttr "version" pkg then removeSuffix "-${pkg.version}" pkg.name
        else pkg.name;
    }; "${pkg}/bin/${binName}";
    prefixIf = b: x: y: if b then x + y else y;
    mapLines = f: s: concatMapStringsSep "\n"
      (l: if l != "" then f l else l)
      (splitString "\n" s);
    words = splitString " ";
    attrIf = check: name: if check then name else null;
    drvs = x: if isDerivation x || isList x then flatten x else flatten (mapAttrsToList (_: v: drvs v) x);
    drvsExcept = x: e: with {
      excludeNames = concatMap attrNames (attrValues e);
    }; flatten (drvs (filterAttrsRecursive (n: _: !elem n excludeNames) x));
    userName = "Keith Bauson";
    userEmail = "kwbauson@gmail.com";
    nixpkgs-rev = cfg.inputs.nixpkgs.rev;
    nixpkgs-branch = let urlParts = splitString "/" (import ./flake.nix).inputs.nixpkgs.url; in
      if length urlParts == 3 then elemAt urlParts 2 else "master";
    fakePlatform = x: x.overrideAttrs (attrs:
      { meta = attrs.meta or { } // { platforms = stdenv.lib.platforms.all; }; }
    );
    excludeLines = f: text: concatStringsSep "\n" (filter (x: !f x) (splitString "\n" text));
    unpack = src: stdenv.mkDerivation {
      src = if src ? url && src ? sha256 then fetchurl { inherit (src) url sha256; } else src;
      name = src.name or "source";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mv $PWD $out
      '';
    };
    nixLocalEnv = import ./nix-local-env.nix { path = ./.; inherit pkgs; };
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
    alias = name: x: writeShellScriptBin name ''exec ${if isDerivation x then exe x else x} "$@"'';
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
    importNixpkgs = src: import src { inherit system; overlays = [ ]; };
    buildDir = paths:
      let cmds = concatMapStringsSep "\n" (p: "cp -r ${p} $out/${baseNameOf p}") (toList paths);
      in runCommand "build-dir" { } "mkdir $out\n${cmds}";
    copyPath = path: runCommand (baseNameOf path) { } "cp -Lr ${path} $out && chmod -R +rw $out";
    nodeEnv = callPackage "${sources.node2nix}/nix/node-env.nix" { nodejs = nodejs_latest; };
    pathAdd = pkgs: "PATH=${concatMapStringsSep ":" (pkg: "${pkg}/bin") (toList pkgs)}:$PATH";
    nixos-unstable-channel = importNixpkgs (unpack sources.nixos-unstable-channel);
  } // builtins))
  (self: super: with super; with mylib; mapAttrValues importNixpkgs {
    inherit (sources) nixos-18_09 nixpkgs-bundler1;
  })
  (self: super: with super; { nixMaster = cfg.inputs.nix.defaultPackage.${system}; })
  (self: super: with super; with mylib; {
    programs-sqlite = copyPath "${nixos-unstable-channel.path}/programs.sqlite";
    nix-wrapped = buildEnv {
      name = "nix-wrapped";
      paths = [
        nixMaster
        (hiPrio (
          writeShellScriptBin "nix" ''
            ${pathAdd nixMaster}
            exec nix \
              --keep-going \
              --extra-experimental-features 'nix-command flakes' \
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
    qutebrowser = qutebrowser.overrideAttrs (
      attrs: {
        patches = attrs.patches or [ ] ++ [ ./qutebrowser-background.patch ];
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ python3Packages.colorama ];
      }
    );
    i3 = i3.overrideAttrs (attrs: { patches = attrs.patches or [ ] ++ [ ./i3-icons.patch ]; });
    steam-native = steam.override { nativeOnly = true; };
    steam-run-native_18-09 = nixos-18_09.steam-run-native;
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    node-env-coc-explorer = vimUtils.buildVimPlugin rec {
      src = copyPath "${(import ./node-env.nix { inherit pkgs; path = cfg.outPath; }).node_modules}/coc-explorer";
      name = src.name;
    };
    node-env-coc-pyright = vimUtils.buildVimPlugin rec {
      src = copyPath "${(import ./node-env.nix { inherit pkgs; path = cfg.outPath; }).node_modules}/coc-pyright";
      name = src.name;
    };
    rnix-lsp-unstable = cfg.inputs.rnix-lsp.defaultPackage.${system};
    mach-nix = cfg.inputs.mach-nix.lib.${system};
    spotify = dmgOverride "spotify" (spotify // { version = sources.dmg-spotify.version; });
    discord = dmgOverride "discord" (discord // { version = sources.dmg-discord.version; });
    inherit (nixLocalEnv.pkgs) fordir;
  })
  (self: super: with super;
  with mylib; mapAttrValues fakePlatform { inherit xvfb_run acpi scrot xdotool progress; }
  )
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
