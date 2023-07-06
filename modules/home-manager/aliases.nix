{ scope, machine-name, isNixOS, ... }: with scope;
{
  included-packages = alias {
    nixpkgs-rev = "echo ${inputs.nixpkgs.rev}";
    nixpkgs-path = "echo ${pkgs.path}";
    nixpkgs-branch = "echo ${nixpkgs-branch}";
    undup = ''tac "$@" | awk '!x[$0]++' | tac'';
    cfgu = "cd ~/cfg && git dfo && git rebase --autostash origin/$(git branch-name)";
    cfgp = "git -C ~/cfg cap";
    built-as-host = "echo ${machine-name}";
    nou = "cfgu && noa";
    nod = "delete-old-generations && nix store gc -v ${optionalString isNixOS "&& sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot"}";
    noc = "cd ~/cfg && gh workflow run updates.yml";
    noe = "nvim ~/cfg/hosts/$(built-as-host)/configuration.nix && nos";
    hme = "nvim ~/cfg/home.nix && hms";
    nb = ''pkg=$1 && shift; nix build $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
    ns = ''pkg=$1 && shift; nix shell $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
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
    tge = ''
      set -euo pipefail
      env=$1
      shift
      modules=infra-terraform-modules
      envs=infra-terragrunt-envs
      ref=$(echo $PWD | sed -E "s@.*($modules)/@@")
      cd "$(echo $PWD | sed "s@$modules.*@$envs@")"
      file=$(rg -lg terragrunt.hcl "$modules//$ref" | grep "/$env/" | sed 's@^/@@p')
      if [[ $(echo "$file" | wc -l) != 1 ]];then
        echo need exactly one match
        exit 1
      fi
      cd "$(dirname "$file")"
      original=$(mktemp)
      cp terragrunt.hcl "$original"
      on_exit() {
        mv "$original" terragrunt.hcl
      }
      trap on_exit EXIT
      sed -i -e "\@$modules//$ref@s/^.*#//" -e "\@$modules.git//$ref@s/^/#/" terragrunt.hcl
      terragrunt "$@"
    '';
  };
}
