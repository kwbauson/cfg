{ scope, isGraphical, ... }: with scope;
{
  included-packages = with pkgs; {
    core = {
      inherit
        acpi atool banner bash-completion bashInteractive bc binutils
        borgbackup bvi bzip2 cacert coreutils-full cowsay curl diffutils
        dos2unix ed fd file findutils gawk gnugrep gnused gnutar gzip inetutils
        iproute2 iputils ldns less libarchive libnotify loop lsof man-pages
        moreutils nano ncdu netcat-gnu nix-tree nmap openssh p7zip patch
        perl pigz procps progress pv ranger ripgrep rlwrap rsync sd socat
        strace time unzip usbutils watch wget which xdg-utils xxd xz zip
        bitwarden-cli bws libqalculate yt-dlp speedtest-cli tldr nix-top
        nixos-install-tools better-comma dogdns dasel emborg clip
        ;
    };
    ${attrIf isGraphical "graphical"} = {
      graphical-core = {
        inherit
          dzen2 graphviz i3-easyfocus i3lock imagemagick sway term nsxiv
          xclip xdotool xsel xterm maim imgloc w3m
          ;
        inherit (xorg) xdpyinfo xev xfontsel xmodmap;
      };
      inherit
        ffmpeg_6-full mediainfo pavucontrol qtbr breeze-icons
        signal-desktop discord zoom-us dejavu_fonts dejavu_fonts_nerd
        zathura
        ;
      sox = sox.override { enableLame = true; };
      ruby = ruby.withPackages (ps: [ ps.rb-inotify ]);
    };
    development = {
      inherit
        bat colordiff gron highlight xh icdiff jq watchexec yarn
        yarn-bash-completion nodejs_latest cachix nle concurrently arduino
        tasknix devenv google-cloud-sdk nix-index
        ;
      inherit (nodePackages) npm-check-updates prettier;
    };
    inherit nrs switch;
    inherit nle-cfg;
  };
  excluded-packages = optionalAttrs isDarwin {
    inherit i3-easyfocus iproute2 iputils pavucontrol strace sway dzen2
      maim zoom-us acpi usbutils xdotool qtbr signal-desktop discord;
    inherit breeze-icons nixos-install-tools arduino util-linux;
    inherit nim nimlsp crystal emborg;
  };
}
