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
    devenv = (import sources.devenv).defaultPackage.${system};
    bin-aliases = alias {
      nixpkgs-rev = "echo ${scope.inputs.nixpkgs.rev}";
      nixpkgs-path = "echo ${pkgs.path}";
      nixpkgs-branch = "echo ${nixpkgs-branch}";
      undup = ''tac "$@" | awk '!x[$0]++' | tac'';
      cfgu = "cd ~/cfg && git dfo && git rebase --autostash origin/$(git branch-name)";
      cfgp = "git -C ~/cfg cap";
      nou = "cfgu && noa";
      noc = "cd ~/cfg && gh workflow run updates.yml";
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
      batwhich = ''bat "$(which "$@")"'';
    };
    self-flake-lock = runCommand "self-flake-lock" { nativeBuildInputs = [ jq moreutils ]; } ''
      cp ${scope.self-source}/flake.lock $out
      chmod +w $out
      entries=$(jq '.nodes.root.inputs | to_entries' $out)
      inputs_keys=$(jq -r '.[].key' <<<"$entries")
      inputs_values=$(jq -r '.[].value' <<<"$entries")
      if [[ $inputs_keys != $inputs_values ]];then
        echo invalid input mapping
        jq '.nodes.root.inputs' $out
        echo generated flake.lock of self does not support nested inputs
        exit 1
      fi
      self_inputs="${concatStringsSep "\n" (attrNames scope.inputs)}"
      self_inputs=$(echo "$self_inputs" | sort)
      lock_inputs=$(jq -r '.nodes | keys | sort[]' $out | grep -vFx root)
      if [[ $inputs_keys != $lock_inputs ]];then
        echo self_inputs: $self_inputs
        echo lock_inputs: $lock_inputs
        echo inputs of self do not match flake.lock nodes
        exit 1
      fi
      self_inputs="${concatStringsSep "\n" (mapAttrsToList (n: v: "${n} ${v.outPath} ${v.narHash}") scope.inputs)}"
      echo "$self_inputs" | while read input outPath narHash;do
        jq ".nodes.\"$input\".locked = { type: \"path\", path: \"$outPath\", narHash: \"$narHash\" }" $out | sponge $out
      done
    '';
    self-flake = runCommand "self-flake" { } ''
      cp -r ${scope.self-source} $out
      chmod -R +w $out
      cp ${scope.self-flake-lock} $out/flake.lock
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
