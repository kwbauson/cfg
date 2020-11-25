{ pkgs, config, ... }:
with builtins; with pkgs; with pkgs.mylib; {
  home.packages = with pkgs;
    drvsExcept
      {
        core = {
          inherit
            acpi atool banner bashCompletion bashInteractive bc binutils
            borgbackup bvi bzip2 cacert cachix coreutils-full cowsay curl
            diffutils dos2unix ed fd file findutils gawk gnugrep gnused gnutar
            gzip htop inetutils iproute iputils ldns less libarchive libnotify
            loop lsof man-pages moreutils nano ncdu netcat-gnu niv nixUnstable
            nix-bash-completions nix-index nix-info nix-prefetch-github
            nix-prefetch-scripts nix-tree nmap openssh p7zip patch perl pigz
            procps progress pv ranger ripgrep rlwrap rsync sd socat strace time
            unzip usbutils watch wget which xdg_utils xxd xz zip manix
            better-comma nix-build-uncached
            ;
        };
        ${attrIf isGraphical "graphical"} = {
          graphical-core = {
            inherit
              arandr dzen2 graphviz i3-easyfocus i3lock imagemagick7 sway
              term sxiv xclip xdotool xsel xterm wine maim
              ;
            inherit (xorg) xdpyinfo xev xfontsel xmodmap;
          };
          multi-media = {
            inherit
              audacity chromium ffmpeg firefox libreoffice-fresh mediainfo
              obs-studio obs-v4l2sink pavucontrol pinta sox zathura qtbr spotify
              ;
          };
          misc = {
            inherit
              adoptopenjdk-bin breeze-icons networkmanagerapplet pandoc qemu qtile
              steam steam-run-native_18-09 signal-desktop discord zoom-us
              ;
            inherit evilhack;
          };
          ghcEnv = ghc.withPackages (pkgs: with pkgs; [ xmonad xmonad-contrib lens taggy-lens ]);
          fonts = { inherit dejavu_fonts dejavu_fonts_nerd; };
        };
        development = {
          inherit
            bat ccache colordiff ctags diffoscope dhall git-trim golint gron
            highlight httpie hyperfine icdiff jq lazydocker lazygit nim
            nixpkgs-fmt overmind rnix-lsp-unstable shellcheck shfmt solargraph
            watchexec yarn yarn-completion nle
            ;
          inherit (gitAndTools) diff-so-fancy gh git-ignore;
          inherit (nodePackages) npm-check-updates parcel-bundler prettier;
        };
        misc = {
          inherit bitwarden-cli libqalculate local-bin youtube-dl;
        };
        inherit (nixLocalEnv) packages;
        ${attrIf isDarwin "darwinpkgs"} = [ skhd amethyst ];
      } {
      ${attrIf isDarwin "darwin"} = {
        inherit
          audacity chromium dbeaver diffoscope i3-easyfocus iproute iputils
          libreoffice-fresh loop networkmanagerapplet pavucontrol pinta qtile
          steam steam-native steam-run-native_18-09 strace sway sxiv usbutils
          wine zathura obs-studio obs-v4l2sink breeze-icons ccache dzen2 zoom-us
          maim
          ;
        inherit bl bh medctl runnim statusline vol;
        inherit dejavu_fonts_nerd;
      };
      ${attrIf (!isGraphical) "non-graphical"} = {
        inherit golint solargraph yarn medctl mpv-ytdl-format togpad togwin winlist;
      };
      broken = { inherit nix-prefetch-scripts; };
    };

  home = {
    stateVersion = "21.03";
    inherit username homeDirectory;
    keyboard.options = words "ctrl:nocaps ctrl:swap_rwin_rctl";
    sessionVariables = {
      BROWSER = "chromium";
      BUGSNAG_RELEASE_STAGE = "local";
      ${attrIf (pathExists ./secrets/bw-session) "BW_SESSION"} = readFile ./secrets/bw-session;
      ${attrIf (pathExists ./secrets/github-token) "GITHUB_TOKEN"} = readFile ./secrets/github-token;
      DBTUNNELUSER = "keith";
      EDITOR = "nvim";
      EMAIL = "${userName} <${userEmail}>";
      ESCDELAY = 25;
      LESS = "-iR";
      LESSHISTFILE = "$XDG_DATA_HOME/less_history";
      PAGER = "less";
      RANGER_LOAD_DEFAULT_RC = "FALSE";
      RXVT_SOCKET = "$XDG_RUNTIME_DIR/urxvtd";
      SSH_ASKPASS = null;
      VISUAL = config.home.sessionVariables.EDITOR;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      npm_config_audit = "false";
      npm_config_cache = "$HOME/.cache/npm";
      npm_config_package_lock_only = "true";
      npm_config_save_prefix = " ";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle";
      BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
      BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";
      RLWRAP_HOME = "$XDG_DATA_HOME/rlwrap";
      SOLARGRAPH_CACHE = "$XDG_CACHE_HOME/solargraph";
    };
  };

  nixpkgs = {
    config = import ./config.nix;
    overlays = import ./overlays.nix;
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    home-manager.path = cfg.inputs.home-manager.outPath;
    command-not-found.enable = true;
    bash = {
      enable = true;
      inherit (config.home) sessionVariables;
      historyFileSize = -1;
      historySize = -1;
      shellAliases = with { cfg-git = "git -C ${toString ./.}"; }; {
        l = "ls -lh";
        ll = "l -a";
        ls = "ls --color=auto";
        file = "file -s";
        sudo = "sudo ";
        su = "sudo su";
        grep = "grep --color -I";
        rg = "rg --color=always -S --hidden";
        ncdu = "ncdu --color dark -ex";
        wrun = "watchexec --debounce 50 --no-shell --clear --restart --signal SIGTERM -- ";
        noc = prefixIf isNixOS "sudo " "nix-channel --update";
        nod = prefixIf isNixOS "sudo " "nix-collect-garbage -d";
        ${attrIf isNixOS "nob"} = "sudo nixos-rebuild boot";
        ${attrIf isNixOS "nos"} = "sudo nixos-rebuild switch";
        ${attrIf isNixOS "noe"} = "nixos-rebuild edit && nos";
        hm = "home-manager --keep-going";
        hmb = "hm build";
        hms = "hm switch";
        hme = "hm edit && hms";
        hmg = "${cfg-git} g && ${cfg-git} df";
        hmp = "${cfg-git} cap";
        nou = "noc && hmg ${optionalString isNixOS "&& nob"} && hms";
        root-symlinks = with {
          paths = words ".bash_profile .bashrc .inputrc .nix-profile .profile .config .local";
        }; "sudo ln -sft /root ${homeDirectory}/{${concatStringsSep "," paths}}";
        qemu = "qemu-system-x86_64 -net nic,vlan=1,model=pcnet -net user,vlan=1 -m 3G -vga std -enable-kvm";
        lo = "local_ops";
        lo-early-talent = "lo start -s early-talent && lo logs -s early-talent; lo stop -s all";
      };
      initExtra =
        prefixIf
          isDarwin ''
          if command -v nix &> /dev/null;then
            NIX_LINK=$HOME/.nix-profile/bin
            export PATH=$(echo "$PATH" | sed "s#:$NIX_LINK##; s#\(/usr/local/bin\)#$NIX_LINK:\1#")
            unset NIX_LINK
          else
            source ~/.nix-profile/etc/profile.d/nix.sh
            export NIX_PATH=nixpkgs=$HOME/.nix-defexpr/channels/nixos:$HOME/.nix-defexpr/channels
            export XDG_DATA_DIRS="$HOME/.nix-profile/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
          fi
          source ~/.nix-profile/etc/profile.d/bash_completion.sh
          export GPG_TTY=$(tty)
        '' ''
          ${readFile ./bashrc}
          source ${sources.complete-alias}/complete_alias
          for a in $(alias | sed 's/=/ /' | cut -d' ' -f2);do complete -F _complete_alias $a;done
        '';
    };
    readline = {
      enable = true;
      variables = {
        editing-mode = "vi";
        completion-query-items = -1;
        expand-tilde = false;
        match-hidden-files = false;
        mark-symlinked-directories = true;
        page-completions = false;
        skip-completed-text = true;
        colored-stats = true;
        keyseq-timeout = 0;
        bell-style = false;
        show-mode-in-prompt = true;
        revert-all-at-newline = true;
        vi-ins-mode-string = "\\1\\e[6 q\\2";
        vi-cmd-mode-string = "\\1\\e[2 q\\2";
      };
      bindings = {
        "\\C-p" = "history-search-backward";
        "\\C-n" = "history-search-forward";
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
        "\\C-d" = "possible-completions";
        "\\C-l" = "complete";
        "\\C-f" = "complete-filename";
        "\\C-a" = "insert-completions";
        "\\C-k" = "kill-whole-line";
        "\\C-w" = ''" \edba\b"'';
        "\\t" = "menu-complete";
        "\\e[Z" = "menu-complete-backward";
      };
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
    };
    tmux = {
      enable = true;
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      historyLimit = 65535;
      keyMode = "vi";
      reverseSplit = true;
      secureSocket = false;
      sensibleOnTop = false;
      shortcut = "s";
      baseIndex = 1;
      extraConfig = ''
        bind -n M-C-k send-keys -R \; clear-history
        set -g set-titles on
        set -ga terminal-overrides ",*-256color:RGB"
        set -g status off
        set -g status-position top
        set -g window-status-current-format "#[fg=black]#[bg=green] #I #[bg=blue]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"
        set -g window-status-format "#[fg=black]#[bg=yellow] #I #[bg=brightblack]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"
        set -g status-fg colour1
        set -g status-bg colour0
        set -g window-status-separator ""
        set -g status-left ""
        set -g status-right ""
      '';
    };
    neovim = {
      enable = true;
      withNodeJs = true;
      extraConfig = readFile ./init.vim;
      plugins = with rec {
        plugins = with vimPlugins; {
          inherit
            direnv-vim fzf-vim quick-scope tcomment_vim vim-airline
            vim-better-whitespace vim-bufkill vim-easymotion vim-fugitive
            vim-lastplace vim-multiple-cursors vim-peekaboo vim-polyglot
            vim-sensible vim-startify vim-vinegar

            coc-nvim coc-eslint coc-git coc-json coc-lists coc-prettier
            coc-solargraph coc-tsserver
            node-env-coc-explorer node-env-coc-pyright
            ;
        };
        makeExtraPlugins = map (name: vimUtils.buildVimPlugin {
          inherit name;
          src = sources.${name};
        });
      }; attrValues plugins
        ++ makeExtraPlugins [ "vim-code-dark" "jsonc.vim" "any-jump.vim" "context.vim" "vim-anyfold" ]
        ++ optional (!isDarwin) vimPlugins.vim-devicons;
    };
    htop = {
      enable = true;
      accountGuestInCpuMeter = true;
      fields = words "PID USER STATE PERCENT_CPU PERCENT_MEM M_RESIDENT STARTTIME COMM";
      headerMargin = false;
      hideThreads = true;
      hideUserlandThreads = true;
      meters.left = words "LeftCPUs Blank Memory Swap";
      meters.right = words "RightCPUs Tasks Uptime LoadAverage";
      showProgramPath = false;
      treeView = true;
      updateProcessNames = true;
      vimMode = true;
    };
    alacritty = {
      enable = true;
    };
    urxvt = {
      enable = isGraphical;
      extraConfig.reverseVideo = true;
      extraConfig.termName = "xterm-256color";
      fonts = [ "xft:DejaVuSansMono Nerd Font Mono:size=12" ];
      scroll.bar.enable = false;
      scroll.lines = 0;
    };
    git = {
      enable = true;
      package = gitAndTools.gitFull;
      aliases = {
        a = "add -A";
        br = "branch";
        branch-name = "rev-parse --abbrev-ref HEAD";
        cap = "! git a; git ci; git p";
        ci = "commit -v";
        co = "checkout";
        df = "! git a -N && git -c core.pager='${exe gitAndTools.delta} --dark' diff HEAD";
        g = "! git pull origin `git branch-name` --rebase --autostash";
        get = "! git pull origin `git branch-name` --ff-only";
        gm = "fetch origin master:master";
        hidden = "! git ls-files -v | grep '^S' | cut -c3-";
        hide = "update-index --skip-worktree";
        p = "put";
        pf = "put --force-with-lease";
        put = "! git push origin `git branch-name`";
        rt = "reset .";
        ro = "! git reset --hard origin/`git branch-name`";
        ru = "remote update";
        st = "status";
        unhide = "update-index --no-skip-worktree";
      };
      inherit userName userEmail;
      extraConfig = {
        checkout.defaultRemote = "origin";
        core.autocrlf = "input";
        fetch.prune = true;
        pager.branch = false;
        push.default = "simple";
        pull.rebase = false;
        rebase.instructionFormat = "(%an) %s";
      };
    };
    direnv.enable = true;
    direnv.enableNixDirenvIntegration = true;
    fzf = {
      enable = true;
      enableBashIntegration = false;
      defaultCommand = "fd -tf -c always -H --ignore-file ${./ignore} -E .git";
      defaultOptions = words "--ansi --reverse --multi --filepath-word";
    };
    lesspipe.enable = true;
    rofi = {
      enable = isNixOS && isGraphical;
      theme = "solarized";
      location = "top";
      extraConfig = ''
        rofi.show-icons: true
        rofi.scroll-method: 1
        rofi.kb-row-tab:
        rofi.kb-row-select: Tab
        rofi.monitor:-1
      '';
    };
    vscode.enable = isGraphical;
    mpv.enable = isGraphical;
    qutebrowser = {
      enable = isGraphical;
      extraConfig = readFile ./qutebrowser-config.py;
    };
  };
  xdg = {
    enable = true;
    ${attrIf isNixOS "mimeApps"}.enable = true;
    ${attrIf isNixOS "userDirs"} = {
      enable = true;
      desktop = "$HOME";
      documents = "$HOME";
      download = "$HOME";
      music = "$HOME";
      pictures = "$HOME";
      templates = "$HOME";
      videos = "$HOME";
    };
    configFile = {
      "ranger/rc.conf".text = ''
        source ${homeDirectory}/.nix-profile/share/doc/ranger/config/rc.conf
        set vcs_aware true
        set preview_images_method urxvt
        map D delete
        map Q quit!
        map ! shell bash
      '';
      "ranger/plugins/ranger_devicons".source = sources.ranger_devicons;
      ${attrIf isDarwin "nix/nix.conf"}.text = ''
        max-jobs = auto
        experimental-features = nix-command flakes
        builders-use-substitutes = true
        builders = ssh://keith@kwbauson.com x86_64-linux
      '';
      "emborg/settings".text = ''
        configurations = "default"
        encryption = "none"
        compression = "auto,zstd"
        repository = "keith@kwbauson.com:bak/{host_name}"
        archive = "{host_name}-{{now}}"
        one_file_system = False
        exclude_caches = True
        prune_after_create = True
        keep_within = "1d"
        keep_daily = 1
        keep_weekly = 1
        keep_monthly = 1
        keep_yearly = 1
      '';
      "emborg/default".text = ''
        src_dirs = "${optionalString isNixOS "/etc/nixos"} ~".split()
        excludes = """
        ${mapLines (l: prefixIf (!hasPrefix "*" l) "~/" l) (readFile ./ignore)}
        """
      '';
    };
    dataFile = {
      "qutebrowser/userscripts/login-fill" = {
        executable = true;
        source = writeShellScript "login-fill" ''
          set -e
          items=$(bw list items --url "$QUTE_URL" | jq 'map(.login) | map({ username, password, url: .uris[0].uri })')
          count=$(echo "$items" | jq length)
          if [[ $count -eq 1 ]];then
            choice=1
          elif [[ $count -gt 1 ]];then
            choices=$(echo "$items" | jq -r 'map([.username, .url]) | map(join(" | ")) | join("\n")' | nl)
            choice=$(echo "$choices" | rofi -dmenu | awk '{ print $1 }')
          else
            echo no matching logins
            exit 1
          fi
          if [[ -n $choice ]];then
            item=$(echo "$items" | jq ".[$choice - 1]")
            username=$(echo "$item" | jq -r '.username')
            password=$(echo "$item" | jq -r '.password')
            echo "jseval -q document.querySelectorAll('input[type=password]')[0].focus()" > "$QUTE_FIFO"
            echo "fake-key $password<shift-tab>$username<tab>" > "$QUTE_FIFO"
          fi
        '';
      };
      "xmonad/.keep".text = "";
    };
  };

  xsession = {
    enable = isNixOS && isGraphical;
    initExtra = ''
      xmodmap ${./Xmodmap}
      xsetroot -solid black
      xsetroot -cursor_name left_ptr
      urxvtd -q -o -f
      [[ $(hostname) = keith-vm ]] && xrandr --output Virtual-1 --mode 1920x1200
    '';
    windowManager = {
      i3 = {
        enable = isNixOS && isGraphical;
        config = null;
        extraConfig = readFile ./i3-config;
      };
      xmonad = {
        enable = false;
        enableContribAndExtras = true;
      };
    };
  };
}
