{ scope, machine-name, isNixOS, ... }: with scope;
{
  included-packages = alias {
    nixpkgs-rev = "echo ${inputs.nixpkgs.rev}";
    nixpkgs-path = "echo ${nixpkgsPath}";
    nixpkgs-branch = "echo ${nixpkgs-branch}";
    undup = ''tac "$@" | awk '!x[$0]++' | tac'';
    cfgu = "cd ~/cfg && git fetch && git rebase --autostash $(git tracking)";
    cfgp = "git -C ~/cfg cap";
    machine-name = "echo ${machine-name}";
    nou = "cfgu && noa";
    nod = "delete-old-generations && nix store gc -v ${optionalString isNixOS "&& sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot"}";
    noc = "cd ~/cfg && gh workflow run updates.yml";
    noe = "nvim ~/cfg/hosts/$(machine-name)/configuration.nix && nos";
    hme = "nvim ~/cfg/home.nix && hms";
    nb = ''pkg=$1 && shift; git -C ~/cfg add --all && nix build $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
    ns = ''pkg=$1 && shift; git -C ~/cfg add --all && nix shell $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
    nr = ''pkg=$1 && shift; git -C ~/cfg add --all && nix run $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g") --'';
    reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    lr = ''find "$@" -print0 | sort -z | xargs -0 ls --color=auto -lhd'';
    delete-old-generations = ''
      find {/nix/var,~/.local/state}/nix/profiles -not -type d |
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
    cnix = ''
      set -u
      cachename=$1
      shift
      args=$(
        curl -s app.cachix.org/api/v1/cache/"$cachename" | jq -r \
        '"--extra-substituters \(.uri) --extra-trusted-public-keys \(.publicSigningKeys[0])"'
      )
      exec nix ''${args[@]} "$@"
    '';
    build-for-cachix = ''
      set -euo pipefail
      cachename=$1
      shift
      cmd=
      if [[ $1 = -c ]];then
        shift
        cmd=$1
        shift
      fi
      args=$(
        curl -s app.cachix.org/api/v1/cache/"$cachename" | jq -r \
        '"--extra-substituters \(.uri) --extra-trusted-public-keys \(.publicSigningKeys[0])"'
      )
      outPaths=$(nix build --no-link --print-out-paths "$@")
      cachix push kwbauson "$outPaths" 1>&2
      realize="nix-store ''${args[@]} --realize $outPaths"
      if [[ -z $cmd ]];then
        echo "$realize"
      else
        echo "$realize && $outPaths/bin/$cmd"
      fi
    '';
    slime = "tmux -L vim-slime new";
  };
}
