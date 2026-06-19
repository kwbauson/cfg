{ scope, ... }: with scope;
let
  nixPkgAlias = cmd: extra: /* bash */ ''
    set -euo pipefail
    pkg=$1
    shift

    cd ~/cfg
    changes=()
    while read _ path;do
      changes+=("$path")
    done < <(git status --short)
    submodules=()
    while read _ path _;do
      submodules+=("$path")
    done < <(git submodule status)

    markerName=.__submodule_change_marker__

    cleanup() {
      cd ~/cfg
      rm -f "$markerName"
      git rm --force --quiet "$markerName"
    }

    submoduleChanged=0
    for change in "''${changes[@]}";do
      for submodule in "''${submodules[@]}";do
        if [[ $change = $submodule ]];then
          submoduleChanged=1
          break
        fi
      done
      if [[ $submoduleChanged = 1 ]];then
        touch "$markerName"
        trap cleanup EXIT
        break
      fi
    done

    git add --all --intent-to-add
    cd "$OLDPWD"
    installableArgs=$(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")
    nix ${cmd} $installableArgs ${extra} "$@"
  '';
in
{
  included-packages = alias {
    undup = ''tac "$@" | awk '!x[$0]++' | tac'';
    machine-name = "echo ${machine.name}";
    check-hardware-config = /* bash */ ''
      set -euo pipefail
      cd ~/cfg/machines/"$(machine-name)"
      nixos-generate-config --show-hardware-config > hardware-configuration.nix
      git --no-pager diff hardware-configuration.nix
    '';
    cfgu = "git -C ~/cfg f && git -C ~/cfg g";
    nou = "cfgu && noa";
    nod = ''delete-old-generations "$@" && nix store gc -v ${optionalString isNixOS "&& sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot"}'';
    noc = "cd ~/cfg && gh workflow run updates.yml";
    nb = nixPkgAlias "build" "";
    ns = nixPkgAlias "shell" "";
    nr = nixPkgAlias "run" "--";
    batwhich = ''bat "$(which "$@")"'';
    realwhich = ''realpath "$(which "$@")"'';
    reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    lr = ''find "$@" -print0 | sort -z | xargs -0 ls --color=auto -lhd'';
    ${attrIf (isLinux && isGraphical) "nm-applet"} = getExe networkmanagerapplet;
  };
}
