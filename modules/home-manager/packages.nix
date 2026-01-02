{ scope, isGraphical, isMinimal, ... }: with scope;
{
  included-packages = with pkgs; {
    core = {
      inherit
        acpi atool banner bash-completion bashInteractive bc binutils
        borgbackup bvi bzip2 cacert coreutils-full cowsay curl diffutils
        dos2unix ed fd file findutils gawk gnugrep gnused gnutar gzip inetutils
        iproute2 iputils ldns less libarchive libnotify lsof man-pages
        moreutils nano ncdu netcat-gnu nix-tree nmap openssh p7zip patch
        perl pigz procps progress pv ranger ripgrep rlwrap rsync sd socat
        strace time unzip usbutils watch wget which xdg-utils xxd xz zip
        bitwarden-cli libqalculate yt-dlp speedtest-cli tldr nix-top jless
        nixos-install-tools better-comma doggo dasel clip terraform;
    };
    ${attrIf isGraphical "graphical"} = {
      graphical-core = {
        inherit
          dzen2 graphviz imagemagick term nsxiv
          xclip xdotool xsel xterm maim w3m;
        inherit (xorg) xdpyinfo xev xfontsel xmodmap;
      };
      inherit
        ffmpeg mediainfo pavucontrol qtbr signal-desktop
        discord dejavu_fonts zathura steamtinkerlaunch
        headsetcontrol arduino remmina obsidian;
      sox = sox.override { enableLame = true; };
      linuxOnly = optionalAttrs isLinux {
        inherit (kdePackages) breeze-icons;
        inherit i3-easyfocus;
      };
    };
    development = {
      inherit bat colordiff gron highlight xh icdiff jq watchexec nix-index ast-grep;
      ruby = ruby.withPackages (ps: [ ps.rb-inotify ]);
      python3 = python3.withPackages (ps: [ ps.typer ps.fastapi ps.uvicorn ps.openai ]);
    };
    development-extra = optionalAttrs (!isMinimal) {
      inherit
        yarn yarn-bash-completion nodejs_latest concurrently google-cloud-sdk
        unison-ucm cachix;
      inherit (nodePackages) npm-check-updates prettier;
    };
    nle-cfg = nle-cfg.pkgs;
    meta-included = filterAttrs (_: pkg: pkg.meta.includePackage or false) extra-packages;
  };
  excluded-packages = optionalAttrs isDarwin
    {
      inherit iproute2 iputils pavucontrol strace time dzen2
        maim acpi usbutils xdotool qtbr signal-desktop discord zathura xdg-utils;
      inherit nixos-install-tools arduino util-linux steamtinkerlaunch gnutar;
      inherit man-pages ncdu bitwarden-cli remmina;
    }
  // optionalAttrs isMinimal {
    inherit imgloc yt-dlp;
    inherit (nle-cfg.pkgs) ytdl-format mpv-ytdl-format slopcast i3-move-top-right statusline vol;
  };
}
