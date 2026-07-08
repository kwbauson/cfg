{ scope, ... }: with scope;
let
  nixPkgAlias = cmd: extra: /* bash */ ''
    set -euo pipefail
    pkg=$1
    shift
    cd ~/cfg

    markerName=__submodule_changed_marker__
    cleanup() {
      cd ~/cfg
      rm -f "$markerName"
      git rm --force --quiet "$markerName"
    }
    if [[ -n $(git submodule-changed) ]];then
      > "$markerName"
      trap cleanup EXIT
    fi

    git add --all --intent-to-add
    cd "$OLDPWD"
    installableArgs=$(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")
    nix ${cmd} $installableArgs ${extra} "$@"
  '';
in
{
  included-packages = alias {
    undup = ''tac "$@" | awk '!x[$0]++' | tac'';
    machine-name = "machine name";
    check-hardware-config = /* bash */ ''
      set -euo pipefail
      cd ~/cfg/machines/"$(machine-name)"
      nixos-generate-config --show-hardware-config > hardware-configuration.nix
      git --no-pager diff hardware-configuration.nix
    '';
    nou = "git -C ~/cfg g && noa";
    nod = ''delete-old-generations "$@" && nix store gc -v ${optionalString isNixOS "&& sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot"}'';
    noc = "cd ~/cfg && gh workflow run updates.yml";
    remote-noa = /* bash */ ''
      set -euo pipefail
      machine=$1
      outPath=$(nix build --no-link --print-out-paths ~/cfg#switch.scripts."$machine".noa)
      nix copy --no-check-sigs "$outPath" --to ssh-ng://"$machine"
      ssh "$machine" -t "$outPath"/bin/switch
    '';
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
