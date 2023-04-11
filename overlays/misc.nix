[
  (final: prev: {
    mylib = import ../scope.nix final;
    scope-lib = import ../scope.nix { inherit (prev) lib; };
    isNixOS = prev.isNixOS or false;
    cfg = final.scope.flake;
  })
  (self: super: with super; with mylib; {
    nix-wrapped =
      if isNixOS then nix else
      wrapBins nix ''
        mkdir -p ~/.local/share/nix
        export NIX_CONFIG=$(< ${writeText "nix.conf" cfg.nixConfBase})$'\n'$NIX_CONFIG
        exec "$exePath" "$@"
      '';
  })
  (self: super: with super; with mylib; {
    nix-index-database = stdenv.mkDerivation {
      name = "nix-index-database";
      src = fetchurl { inherit (sources.nix-index-database) url sha256; };
      dontUnpack = true;
      installPhase = ''
        mkdir $out
        cp $src $out/files
      '';
    };
    nix-index-list = stdenv.mkDerivation {
      name = "nix-index-list";
      extra =
        let
          extraPackages = set: concatMapStringsSep "\n" (n: "${set}.${n} ${n}") (attrNames (pkgs.${set}));
          extra-set-list = concatMapStringsSep "\n" extraPackages
            [ "nodePackages" "python3Packages" "rubyPackages" ];
          base-list = concatMapStringsSep "\n" (n: "${n} ${n}") (attrNames pkgs);
        in
        base-list + extra-set-list;
      passAsFile = "extra";
      dontUnpack = true;
      buildInputs = [ nix-index ];
      installPhase = ''
        nix-locate  \
          --db ${nix-index-database} \
          --at-root \
          --type x --type s \
          --regex '/bin/[^.][^/]*' |
          grep -v '^(' |
          awk '{ print $1, $4 }' |
          sed -E 's#^(.*)\.\w+ .*/([^/]+)$#\1 \2#' > list
        sort list $extraPath | uniq > $out
      '';
    };
    steam-native = self.steam.override { nativeOnly = true; };
    dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    nle-cfg = self.nle.build { path = ../.; };
    inherit (self.nle-cfg.pkgs) fordir;
    inherit (self.nle-cfg.pkgs.poetry-env.python.pkgs) emborg git-remote-codecommit;
    inherit (self.nle-cfg.pkgs.bundler-env.gems) fakes3;
    allowUnsupportedSystem = import pkgs.path {
      inherit system;
      config = cfg.config // { allowUnsupportedSystem = true; };
    };
    contentAddressedByDefault = import pkgs.path {
      inherit system;
      config = cfg.config // { contentAddressedByDefault = true; };
    };
    contentAddressed = mapAttrs (_: pkg: if pkg ? overrideAttrs then pkg.overrideAttrs (_: { __contentAddressed = true; }) else pkg) pkgs;
    npmlock2nix = import sources.npmlock2nix { inherit pkgs; };
    devenv = (import sources.devenv).packages.${system}.default;
    selfFlakeLock = {
      version = 7;
      root = "root";
      nodes = {
        root = {
          inputs = genAttrs (remove "root" (attrNames scope.selfFlakeLock.nodes)) id;
        };
      } // (
        let
          toName = parents: input: concatStringsSep "_" (parents ++ [ input ]);
          gen = parents: concatMapAttrs (name: value:
            let
              newParents = parents ++ [ name ];
              isFlake = (value.type or null) == "_flake";
              hasInputs = (value.inputs or { }) != { };
            in
            {
              ${toName parents name} = {
                locked = {
                  type = "path";
                  path = value.outPath;
                  inherit (value) narHash;
                };
                original = {
                  id = toName parents name;
                  type = "indirect";
                };
              }
              // optionalAttrs isFlake { flake = false; }
              // optionalAttrs hasInputs { inputs = genAttrs (attrNames value.inputs) (toName newParents); };
            } // gen newParents (value.inputs or { }));
        in
        gen [ ] scope.inputs
      );
    };
    self-flake = runCommand "self-flake"
      {
        selfFlakeLock = toJSON scope.selfFlakeLock;
        passAsFile = [ "selfFlakeLock" ];
      } ''
      cp -r ${scope.self-source} $out
      chmod -R +w $out
      cp $selfFlakeLockPath $out/flake.lock
    '';
    iso = with scope.packages.x86_64-linux; (nixos ({ modulesPath, ... }: {
      imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
      nixpkgs.config.allowUnfree = true;
      hardware.enableRedistributableFirmware = true;
      hardware.enableAllFirmware = true;
    })).config.system.build.isoImage;
  })
  (final: prev: with prev.scope-lib; {
    extra-packages = mapAttrs
      (n: f: prev.scope.callPackage f (prev.scope // rec {
        name = "${pname}-${version}";
        pname = n;
        version = src.version or src.rev or "unversioned";
        src = prev.scope.sources.${n} or null;
        ${n} = prev.${n};
      }))
      (filterAttrs (_: v: !isPath v) (import' ../pkgs));
  })
  (final: prev: prev.extra-packages)
  (final: prev: with prev.scope-lib; mapDirEntries
    (n: value:
      optionalAttrs (hasSuffix ".patch" n) rec {
        name = removeSuffix ".patch" n;
        value = override prev.${name} { patches = [ (../pkgs + ("/" + n)) ]; };
      }
    ) ../pkgs
  )
  (final: prev: with prev; with mylib; {
    checks = linkFarmFromDrvs "checks" (flatten [
      slapper
      better-comma
      nle
      (optionals stdenv.isLinux [
        waterfox
        r2modman
        bundix
        poetry
        dasel
        pur
        (nle.build { path = writeTextDir "meme" ''meme''; })
      ])
    ]);
  })
]
