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
          export NIX_CONFIG=$(< ${toFile "nix.conf" cfg.nixConf})$'\n'$NIX_CONFIG
          exec "$exePath" "$@"
        '';
    imported-nixpkgs = import' inputs.nixpkgs;
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
    vimPlugins = vimPlugins // { inherit (nixos-unstable.vimPlugins) vim-airline; };
    inherit (nixos-unstable);
    inherit (nixos-20_09);
    inherit (self.pinned-if-darwin) alacritty;
    switch = self.switch-to-configuration.scripts.${builtAsHost}.noa;
    pynixify = let python = python3.override {
      packageOverrides = self: super: {
        pynixify = self.callPackage "${sources.pynixify}/nix/packages/pynixify" { };
      };
    }; in python.pkgs.toPythonApplication python.pkgs.pynixify;
    nle-config = (import ./nle).withConfig { nixpkgs = { inherit (pkgs) system; }; flake = { inherit inputs; }; };
    nixosModules = imported-nixpkgs.nixos.modules;
    bin-aliases = alias {
      built-as-host = "echo ${builtAsHost}";
      nixpkgs-rev = "echo ${inputs.nixpkgs.rev}";
      nixpkgs-path = "echo ${pkgs.path}";
      nixpkgs-branch = "echo ${nixpkgs-branch}";
      lo = "local_ops --no-banner --skip-update";
      los = ''service=$1 && shift && lo start --always-reseed -s $service "$@" && lo logs -s all; lo stop -s $service'';
      hmg = "cd ~/cfg && git dfo && git rebase --autostash origin/$(git branch-name)";
      hmp = "git -C ~/cfg cap";
      nou = "hmg && noa";
      nod = "delete-old-generations && nix store gc -v";
      noe = "nvim ~/cfg/hosts/$(built-as-host)/configuration.nix && nos";
      hme = "nvim ~/cfg/home.nix && hms";
      nb = "pkg=$1 && shift; nix build ~/cfg#$pkg";
      ns = "pkg=$1 && shift; nix shell ~/cfg#$pkg";
      reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
      lr = ''find "$@" -print0 | sort -z | xargs -0 ls --color=auto -lhd'';
      delete-old-generations = ''
        find /nix/var/nix/profiles -not -type d |
          sed -E 's/-[0-9]+-link$//' |
          sort |
          uniq -c |
          while read count profile;do
            [[ $count -gt 2 ]] || continue
            [[ -O $profile ]] && prefix= || prefix=sudo
            echo deleting $(($count-2)) old generations for "$profile"
            $prefix nix-env --profile "$profile" --delete-generations old
          done
      '';
      g = ''
        dirs=$(for dir in *;do
          if [[ -d $dir/.git ]];then
            echo "$dir"
          fi
        done)
        length=$(echo "$dirs" | awk '{ print length }' | sort -V | tail -n1)
        if [[ ! -z $1 && $1 != 'clone' ]] && ! git rev-parse --git-dir &> /dev/null;then
          for dir in $dirs;do
            first=1
            git -C "$dir" "$@" 2>&1 | while IFS=$'\n' read -r line;do
              if [[ -n $first ]];then
                first=
                printf "%''${length}s ┤ %s\n" "$dir" "$line"
              else
                printf "%''${length}s │ %s\n" "" "$line"
              fi
            done
            git_exit=''${PIPESTATUS[0]}
            if [[ $git_exit != '0' ]];then
              exit "$git_exit"
            fi
          done
        elif [[ -z $1 ]];then
          exec g s
        else
          exec git "$@"
        fi
      '';
      nixbuild-shell = "rlwrap ssh eu.nixbuild.net shell";
      nixbuild-status = ''
        set -e
        esc=$'\e'
        reset=$esc[0m
        red=$esc[31m
        yellow=$esc[33m
        green=$esc[32m
        clear=$(clear)
        input=
        while :;do
          echo usage
          echo list builds --limit 10
          sleep 1
        done |
          ssh eu.nixbuild.net shell 2>&1 |
          sed -e '/^The usage metrics/d' -e '/^To find out/d' -e 's/^\s*nixbuild.net> //' |
          while read line;do
            if [[ $line = 'Free build'* ]];then
              echo -n "$clear$(printf '%(%F_%H:%M:%S)T\n')$input"
              input=
              running=
            fi
            input=$input$'\n'$line
          done | sed -E \
            -e "s/(\[(OutOfMemory|Failed|NixOutputRejected|NixPermanentFailure|ClientDisconnect|BackendError|Timeout)\])$/$red\1$reset/" \
            -e "s/(\[Built\])$/$green\1$reset/" \
            -e "s/(\[(Running|In queue)\])$/$yellow\1$reset/"
      '';
    };
  })
  (self: super: with super; with mylib;
  mapAttrs
    (name: f: callPackage f (pkgs // {
      inherit name;
      pname = name;
      src = sources.${name};
      ${name} = super.${name};
    }))
    (filterAttrs (_: v: !isPath v) (import' ./pkgs))
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
