{ scope, machine-name, isGraphical, ... }: with scope;
{
  home.packages = with pkgs;
    drvsExcept
      {
        core = {
          inherit
            acpi atool banner bash-completion bashInteractive bc binutils
            borgbackup bvi bzip2 cacert coreutils-full cowsay curl diffutils
            dos2unix ed fd file findutils gawk gnugrep gnused gnutar gzip
            inetutils iproute2 iputils ldns less libarchive libnotify loop lsof
            man-pages moreutils nano ncdu netcat-gnu niv nix-wrapped nix-tree
            nmap openssh p7zip patch perl pigz procps progress pv ranger
            ripgrep rlwrap rsync sd socat strace time unzip usbutils watch wget
            which xdg-utils xxd xz zip bitwarden-cli libqalculate yt-dlp
            speedtest-cli tldr nix-top nixos-install-tools better-comma q
            dasel emborg
            ;
        };
        ${attrIf isGraphical "graphical"} = {
          graphical-core = {
            inherit
              dzen2 graphviz i3-easyfocus i3lock imagemagick sway term nsxiv
              xclip xdotool xsel xterm maim imgloc
              ;
            inherit (xorg) xdpyinfo xev xfontsel xmodmap;
          };
          inherit
            ffmpeg_6-full mediainfo pavucontrol qtbr breeze-icons
            signal-desktop discord zoom-us dejavu_fonts dejavu_fonts_nerd
            zathura
            ;
          sox = sox.override { enableLame = true; };
        };
        development = {
          inherit
            bat colordiff ctags dhall git-trim gron highlight xh icdiff jq
            crystal nim nimlsp nixpkgs-fmt nil shellcheck shfmt
            solargraph watchexec yarn yarn-bash-completion nodejs_latest gh
            git-ignore git-fuzzy black terraform-ls cachix nle concurrently
            arduino tasknix devenv google-cloud-sdk nix-index
            ;
          inherit (nodePackages) npm-check-updates prettier;
        };
        inherit nr switch;
        inherit nle-cfg;
        bin-aliases = attrValues (bin-aliases // alias {
          built-as-host = "echo ${machine-name}";
        });
      }
      {
        ${attrIf isDarwin "darwin"} = {
          inherit i3-easyfocus iproute2 iputils pavucontrol strace sway dzen2
            maim zoom-us acpi usbutils xdotool qtbr signal-desktop discord;
          inherit breeze-icons nixos-install-tools arduino;
          inherit nim nimlsp crystal;
        };
      };
}