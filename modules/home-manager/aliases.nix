{ scope, ... }: with scope;
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
    # TODO make these less surprising with submodules
    nb = ''pkg=$1 && shift; git -C ~/cfg add --all -N && nix build $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
    ns = ''pkg=$1 && shift; git -C ~/cfg add --all -N && nix shell $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g")'';
    nr = ''pkg=$1 && shift; git -C ~/cfg add --all -N && nix run $(echo "$pkg" | sed -E "s@^|,@ $HOME/cfg#@g") --'';
    reboot-windows = "systemctl reboot --boot-loader-entry=auto-windows";
    lr = ''find "$@" -print0 | sort -z | xargs -0 ls --color=auto -lhd'';
    ${attrIf (isLinux && isGraphical) "nm-applet"} = getExe networkmanagerapplet;
  };
}
