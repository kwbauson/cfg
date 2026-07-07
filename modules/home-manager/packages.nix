{ scope, ... }: with scope;
{
  included-packages = with pkgs; {
    core = {
      inherit
        acpi atool banner bash-completion bashInteractive bc binutils
        borgbackup bvi bzip2 cacert coreutils-full cowsay curl diffutils
        dos2unix ed fd file findutils gawk gnugrep gnused gnutar gzip inetutils
        iproute2 iputils ldns libarchive libnotify lsof man-pages
        moreutils nano ncdu netcat-gnu nix-tree nmap openssh p7zip patch
        perl pigz procps progress pv ranger ripgrep rlwrap rsync sd socat
        strace time unzip usbutils watch wget which xdg-utils xxd xz zip
        bitwarden-cli libqalculate yt-dlp speedtest-cli tldr nix-top jless
        doggo dasel configdiff;
      inherit bin;
    };
    graphical = optionalAttrs isGraphical {
      graphical-core = {
        inherit
          dzen2 graphviz imagemagick nsxiv
          xclip xdotool xsel xterm maim w3m
          xdpyinfo xev xfontsel xmodmap;
      };
      inherit
        ffmpeg mediainfo pavucontrol qtbr
        discord zathura steamtinkerlaunch
        headsetcontrol arduino remmina;
      sox = sox.override { enableLame = true; };
      linuxOnly = optionalAttrs isLinux {
        inherit (kdePackages) breeze-icons;
        inherit i3-easyfocus keyd;
      };
    };
    development = {
      inherit colordiff gron highlight xh icdiff jq watchexec nix-index ast-grep;
      ruby = ruby.withPackages (ps: [ ps.rb-inotify ]);
      python3 = python3.withPackages (ps: [ ps.typer ps.fastapi ps.uvicorn ps.openai ps.termcolor ]);
      inherit (nixvim) nixvim-extended;
    };
    development-extra = optionalAttrs (!isMinimal) {
      inherit
        yarn yarn-bash-completion nodejs_latest concurrently
        unison-ucm cachix npm-check-updates prettier;
      inherit tfn;
    };
    meta-included = filterAttrs
      (_: pkg:
        let i = pkg.meta.includePackage or false; in
        if isFunction i then i machine else i
      )
      extra-packages;
    machine-info = machine-info { inherit machine; };
  };
  excluded-packages = optionalAttrs isDarwin
    {
      inherit iproute2 iputils pavucontrol strace time dzen2
        maim acpi usbutils xdotool qtbr discord zathura xdg-utils;
      inherit nixos-install-tools arduino util-linux steamtinkerlaunch gnutar;
      inherit man-pages ncdu bitwarden-cli remmina ffmpeg yt-dlp procps;
    }
  // optionalAttrs isMinimal {
    inherit imgloc yt-dlp;
    inherit (bin) ytdl-format mpv-ytdl-format slopcast i3-move-top-right statusline vol;
  };
}
