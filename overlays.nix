[
  (_: prev: {
    mylib = import ./mylib.nix prev;
    isNixOS = prev.isNixOS or false;
  })
  (self: super: with super; with mylib; mapAttrValues importNixpkgs {
    inherit (sources) nixos-unstable nixos-21_05 nixos-20_09;
  })
  (self: super: with super; with mylib; {
    nix-wrapped = let nix = nixUnstable; in
      if isNixOS then nix else
      wrapBins nix ''
        mkdir -p ~/.local/share/nix
        export NIX_CONFIG=$(< ${writeText "nix.conf" cfg.nixConfBase})$'\n'$NIX_CONFIG
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
        LATEST=1 exec nix --tarball-ttl 3600 shell github:kwbauson/cfg#${name} -c "$exe" "$@"
      fi
    '';
    nix-index-list = stdenv.mkDerivation {
      name = "nix-index-list";
      src = fetchurl { inherit (sources.nix-index-database) url sha256; };
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
        mkdir db
        cp $src db/files
        nix-locate  \
          --db db \
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
    jitsi-meet = override jitsi-meet { src = ./jitsi-meet.tar.bz2; };
    rnix-lsp-unstable = inputs.rnix-lsp.defaultPackage.${system};
    nle-cfg = self.nle.build { path = ./.; };
    inherit (self.nle-cfg.pkgs) fordir;
    inherit (self.nle-cfg.pkgs.poetry-env.python.pkgs) pur emborg git-remote-codecommit;
    inherit (self.nle-cfg.pkgs.bundler-env.gems) fakes3;
    nix-prefetch-git = nix-prefetch-git.override { nix = nix-wrapped; };
    bundix = bundix.override { nix = nix-wrapped; };
    nix-index = nix-index.override { nix = nix-wrapped; };
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
    inherit (nixos-21_05);
    inherit (self.pinned-if-darwin);
    switch = self.switch-to-configuration.scripts.${builtAsHost}.noa;
    npmlock2nix = import sources.npmlock2nix { inherit pkgs; };
    pynixify = let python = python3.override {
      packageOverrides = self: super: {
        pynixify = self.callPackage "${sources.pynixify}/nix/packages/pynixify" { };
      };
    }; in python.pkgs.toPythonApplication python.pkgs.pynixify;
    nle-config = (import ./nle).withConfig {
      nixpkgs = { inherit system; };
      flake = { inherit inputs; };
      sources = ./.;
    };
    nixosModules = imported-nixpkgs.nixos.modules;
    bin-aliases = alias {
      built-as-host = "echo ${builtAsHost}";
      nixpkgs-rev = "echo ${inputs.nixpkgs.rev}";
      nixpkgs-path = "echo ${pkgs.path}";
      nixpkgs-branch = "echo ${nixpkgs-branch}";
      undup = ''tac "$@" | awk '!x[$0]++' | tac'';
      hmg = "cd ~/cfg && git dfo && git rebase --autostash origin/$(git branch-name)";
      hmp = "git -C ~/cfg cap";
      nou = "hmg && noa";
      noc = "cd ~/cfg && gh workflow run check-for-updates.yml";
      nod = "delete-old-generations && nix store gc -v ${optionalString isNixOS "&& sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot"}";
      noe = "nvim ~/cfg/hosts/$(built-as-host)/configuration.nix && nos";
      hme = "nvim ~/cfg/home.nix && hms";
      nb = ''pkg=$1 && shift; nix build $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
      ns = ''pkg=$1 && shift; nix shell $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
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
        if [[ ! -z $dirs && ! -z $1 && $1 != 'clone' ]] && ! git rev-parse --git-dir &> /dev/null;then
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
  } // mapAttrs dmgOverride { inherit firefox signal-desktop; })
]
