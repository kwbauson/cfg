{ pkgs
, config
, self
, username
, homeDirectory
, isNixOS
, isGraphical
, ...
}:
with builtins; with pkgs; with mylib; {
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
            which xdg_utils xxd xz zip bitwarden-cli libqalculate youtube-dl
            speedtest-cli tldr nix-top
            ;
          better-comma = better-comma.unwrapped;
        };
        ${attrIf isGraphical "graphical"} = {
          graphical-core = {
            inherit
              dzen2 graphviz i3-easyfocus i3lock imagemagick7 sway term sxiv
              xclip xdotool xsel xterm maim
              ;
            inherit (xorg) xdpyinfo xev xfontsel xmodmap;
          };
          inherit
            ffmpeg mediainfo pavucontrol sox qtbr breeze-icons
            signal-desktop discord zoom-us evilhack dejavu_fonts dejavu_fonts_nerd
            ;
        };
        development = {
          inherit
            bat colordiff ctags dhall git-trim gron highlight xh icdiff jq nim
            nimlsp nixpkgs-fmt rnix-lsp-unstable shellcheck shfmt solargraph
            watchexec yarn yarn-completion nodejs_latest gh git-ignore
            git-fuzzy black
            ;
          inherit (nodePackages) npm-check-updates prettier;
          nle = nle.unwrapped;
        };
        inherit nr switch-to-configuration;
        inherit nle-cfg;
        bin-aliases = attrValues bin-aliases;
      }
      {
        ${attrIf isDarwin "darwin"} = {
          inherit
            diffoscope i3-easyfocus iproute2 iputils loop pavucontrol
            steam strace sway sxiv usbutils breeze-icons dzen2 zoom-us maim
            acpi progress xdotool dejavu_fonts_nerd qtbr ffmpeg youtube-dl
            ;
        };
      };

  home = {
    stateVersion = "20.09";
    inherit username homeDirectory;
    keyboard.options = words "ctrl:nocaps ctrl:swap_rwin_rctl";
    sessionVariables = {
      LOCAL_OPS_USE_NIX = "true";
      BROWSER = "firefox";
      BUGSNAG_RELEASE_STAGE = "local";
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
      PBGOPY_SERVER = "http://kwbauson.com:9090/";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    home-manager.path = inputs.home-manager.outPath;
    command-not-found.enable = !isNixOS;
    command-not-found.dbPath = programs-sqlite;
    firefox.enable = true;
    bash = {
      enable = true;
      inherit (config.home) sessionVariables;
      historyFileSize = -1;
      historySize = -1;
      shellAliases = {
        l = "ls -lh";
        ll = "l -a";
        ls = "ls --color=auto --group-directories-first";
        file = "file -s";
        sudo = "sudo ";
        su = "sudo su";
        grep = "grep --color -I";
        rg = "rg --color=always -S --hidden --no-require-git --glob '!/.git/'";
        ncdu = "ncdu --color dark -ex";
        wrun = "watchexec --debounce 50 --no-shell --clear --restart --signal SIGTERM -- ";
        root-symlinks = with {
          paths = words ".bash_profile .bashrc .inputrc .nix-profile .profile .config .local";
        }; "sudo ln -sft /root ${homeDirectory}/{${concatStringsSep "," paths}}";
        qemu = ", qemu-system-x86_64 -net nic,vlan=1,model=pcnet -net user,vlan=1 -m 3G -vga std -enable-kvm";
      };
      initExtra = prefixIf (!isNixOS) ''
        if command -v nix &> /dev/null;then
          NIX_LINK=$HOME/.nix-profile/bin
          export PATH=$(echo "$PATH" | sed "s#:$NIX_LINK##; s#\(/usr/local/bin\)#$NIX_LINK:\1#")
          unset NIX_LINK
        else
          source ~/.nix-profile/etc/profile.d/nix.sh
          export XDG_DATA_DIRS="$HOME/.nix-profile/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
        fi
        source ~/.nix-profile/etc/profile.d/bash_completion.sh
        if [[ -d ~/.nix-profile/etc/bash_completion.d ]];then
          for script in ~/.nix-profile/etc/bash_completion.d/*;do
            source $script
          done
        fi
        export GPG_TTY=$(tty)
      '' ''
        [[ $UID -eq 0 ]] && _color=31 _prompt=# || _color=32 _prompt=$
        [[ -n $SSH_CLIENT ]] && _host="$(hostname --fqdn) " || _host=
        PS1="\[\e[1;32m\]''${_host}\[\e[s\e[\''${_place}C\e[1;31m\''${_status}\e[u\e[0;34m\]\w \[\e[0;''${_color}m\]''${_prompt}\[\e[m\] "

        set -o vi
        set +h
        _promptcmd() {
            ret=$?
            [[ $ret -eq 0 || $ret -eq 148 ]] && rstat= || rstat=$ret

            if [[ -z $rstat && -z $jstat ]];then
              _status=
            elif [[ -z $rstat ]];then
              _status=$jstat
            elif [[ -z $jstat ]];then
              _status=$rstat
            else
              _status="$rstat $jstat"
            fi

            _place=$(($COLUMNS - $((''${#_host} + ''${#_status}))))

            history -a
            tail -n1 ~/.bash_history >> ~/.bash_history-all
        }
        PROMPT_COMMAND='_promptcmd'

        source ${complete-alias}/bin/complete_alias
        complete -F _complete_alias $( alias | perl -lne 'print "$1" if /^alias ([^=]*)=/' )

        _completion_loader git
        ___git_complete g __git_main
      '';
      profileExtra = ''
        [[ -e ~/cfg/secrets/bw-session ]] && export BW_SESSION=$(< ~/cfg/secrets/bw-session)
        [[ -e ~/cfg/secrets/github-token ]] && export GITHUB_TOKEN=$(< ~/cfg/secrets/github-token)
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
        "\\C-e" = "complete-command";
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
      extraConfig = ''
        Host kwbauson.com
          User keith
      '' + optionalString isDarwin ''
        Host vm
          User hacker
          Hostname 127.0.0.1
          Port 24
      '';
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
        set -g default-command "''${SHELL}"
      '';
      plugins = with tmuxPlugins; [ jump ];
    };
    neovim = {
      enable = true;
      withNodeJs = true;
      extraConfig = readFile ./init.vim;
      plugins = with rec {
        plugins = with vimPlugins; {
          inherit
            direnv-vim fzf-vim quick-scope tcomment_vim vim-airline
            vim-better-whitespace vim-bbye vim-easymotion vim-fugitive
            vim-lastplace vim-multiple-cursors vim-peekaboo vim-polyglot
            vim-sensible vim-startify vim-vinegar nvim-scrollview vim-code-dark
            conflict-marker-vim

            coc-nvim coc-eslint coc-git coc-json coc-lists coc-prettier
            coc-solargraph coc-tsserver coc-pyright coc-explorer
            ;
        };
        makeExtraPlugins = map (name: vimUtils.buildVimPlugin {
          inherit name;
          src = sources.${name};
        });
      }; attrValues plugins
        ++ makeExtraPlugins [ "jsonc.vim" "any-jump.vim" "context.vim" "vim-anyfold" ]
        ++ optional (!isDarwin) vimPlugins.vim-devicons;
    };
    htop = {
      enable = true;
      settings = with config.lib.htop; {
        account_guest_in_cpu_meter = true;
        fields = with fields; [ PID USER STATE PERCENT_CPU PERCENT_MEM M_RESIDENT STARTTIME COMM ];
        header_margin = false;
        hide_userland_threads = true;
        hide_kernel_threads = true;
        left_meter_modes = with modes; [ Bar Text Bar Bar ];
        left_meters = words "LeftCPUs Blank Memory Swap";
        right_meter_modes = with modes; [ Bar Text Text Text ];
        right_meters = words "RightCPUs Tasks Uptime LoadAverage";
        show_program_path = false;
        show_thread_names = true;
        sort_key = fields.USER;
        tree_view = true;
        update_process_names = true;
        vim_mode = true;
      };
    };
    alacritty = {
      enable = true;
    };
    urxvt = {
      enable = !isDarwin && isGraphical;
      extraConfig.reverseVideo = true;
      extraConfig.termName = "xterm-256color";
      fonts = [ "xft:DejaVuSansMono Nerd Font Mono:size=12" ];
      scroll.bar.enable = false;
      scroll.lines = 0;
      iso14755 = false;
    };
    git = with {
      scriptAlias = text: "! ${writeBash "git-alias-script" text}";
      tmpGitIndex = ''
        export GIT_INDEX_FILE=$(mktemp)
        cp "$(git rev-parse --show-toplevel)"/.git/index "$GIT_INDEX_FILE"
        trap 'rm -f "$GIT_INDEX_FILE"' EXIT
      '';
    }; {
      enable = true;
      package = gitFull;
      aliases = {
        v = "! nvim '+ Git | only'";
        a = "add -A";
        br = scriptAlias ''
          esc=$'\e'
          reset=$esc[0m
          red=$esc[31m
          yellow=$esc[33m
          green=$esc[32m
          git -c color.ui=always branch -vv | sed -E \
            -e "s/: (gone)]/: $red\1$reset]/" \
            -e "s/[:,] (ahead [0-9]*)([],])/: $green\1$reset\2/g" \
            -e "s/[:,] (behind [0-9]*)([],])/: $yellow\1$reset\2/g"
          git --no-pager stash list
        '';
        brf = "!git f --quiet && git br";
        main = ''! [[ -f $(git rev-parse --show-toplevel)/.git/refs/heads/master ]] && echo master || echo main'';
        branch-name = "rev-parse --abbrev-ref HEAD";
        ca = "! git a && git ci";
        cap = "! git ca && git p";
        ci = "commit -v";
        co = "checkout";
        com = "! git co $(git main)";
        df = scriptAlias ''
          ${tmpGitIndex}
          git add -A
          git -c core.pager='${nr delta} --dark' diff "''${@:-HEAD}" || true
        '';
        dfo = scriptAlias ''git f && git df "origin/''${1:-$(git branch-name)}"'';
        f = "fetch --all";
        g = "! git f && git mo";
        gr = "! git pull origin $(git branch-name) --rebase --autostash";
        gm = "! git fetch origin $(git main):$(git main)";
        gmp = "! git gm && git mp";
        mm = "! git merge $(git main)";
        mo = "! git merge origin/$(git branch-name) --ff-only";
        mp = "! git mm && git ";
        hidden = "! git ls-files -v | grep '^S' | cut -c3-";
        hide = ''! git add -N "$@" && git update-index --skip-worktree "$@"'';
        unhide = "update-index --no-skip-worktree";
        l = "log";
        lg = "! git lfo && git mo";
        lfo = ''! git f && git log HEAD..origin/$(git branch-name) --no-merges --reverse'';
        p = "put";
        fp = scriptAlias ''
          set -e
          git fetch
          ${nr delta} <(git log origin/$(git branch-name)) <(git log) || true
          read -n1 -p "Continue? [y/n] " continue
          echo
          [[ $continue = y ]] && git put --force-with-lease
        '';
        put = "! git push --set-upstream origin $(git branch-name)";
        ro = "! git reset --hard origin/$(git branch-name)";
        ros = "! git stash && git ro && git stash pop";
        rt = ''! git reset --hard ''${1:-HEAD} && git clean -d'';
        s = "! git br && git -c color.status=always status | grep -E --color=never '^\\s\\S|:$' || true";
        sf = "!git f --quiet && git s";
      };
      inherit userName userEmail;
      extraConfig = {
        clean.requireForce = false;
        checkout.defaultRemote = "origin";
        core.autocrlf = "input";
        core.hooksPath = "/dev/null";
        fetch.prune = true;
        pager.branch = false;
        push.default = "simple";
        pull.rebase = false;
        rebase.instructionFormat = "(%an) %s";
        init.defaultBranch = "main";
      };
    };
    direnv.enable = true;
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
      extraConfig = {
        show-icons = true;
        scroll-method = 1;
        kb-row-tab = "";
        kb-row-select = "Tab";
        monitor = -1;
      };
    };
    vscode.enable = isGraphical;
    # vscode.extensions = with vscode-extensions; [ ms-vsliveshare.vsliveshare ];
    mpv.enable = isGraphical && isLinux;
    qutebrowser = {
      enable = isGraphical && isLinux;
      aliases = {
        h = "help";
        q = "quit";
        w = "session-save";
        wq = "quit --save";
      };
      searchEngines = {
        DEFAULT = "https://www.google.com/search?q={}";
        aur = "https://aur.archlinux.org/packages/?K={}";
        aw = "https://wiki.archlinux.org/index.php?search={}";
        g = "https://www.google.com/search?q={}";
        nw = "https://nixos.wiki/index.php?search={}&go=Go";
        tv = "https://www.google.com/search?q=site:tvtropes.org+{}";
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}";
        yt = "http://www.youtube.com/results?search_query={}";
        b = "https://www.biblegateway.com/passage/?version=NLT&search={}";
      };
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
        source = writeBash "login-fill" ''
          set -e
          if [[ -e ~/cfg/secrets/bw-session ]];then
            export BW_SESSION=$(< ~/cfg/secrets/bw-session)
          fi
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

  home.file.".irbrc".text = ''
    IRB.conf[:USE_READLINE] = true
    IRB.conf[:SAVE_HISTORY] = 2_000_000
    IRB.conf[:HISTORY_FILE] = "#{ENV['XDG_DATA_HOME']}/irb_history"
  '';

  gtk.enable = isLinux;
  gtk.theme.name = "Adwaita-dark";
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  qt.enable = isLinux;
  qt.platformTheme = "gtk";
  dconf.enable = false;

  xsession = {
    enable = isNixOS && isGraphical;
    initExtra = ''
      xmodmap ${toFile "Xmodmap" ''
        remove mod1 = Alt_L
        keycode 64 = Escape
        keycode 105 = Super_L
      ''}
      xsetroot -solid black
      xsetroot -cursor_name left_ptr
      urxvtd -q -o -f
    '';
    windowManager = {
      i3 = {
        enable = isNixOS && isGraphical;
        config = null;
        extraConfig = readFile ./i3-config;
      };
    };
  };
}


