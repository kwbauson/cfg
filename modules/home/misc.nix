{ config, scope, machine-name, isNixOS, isGraphical, ... }: with scope;
{
  home = {
    stateVersion = "22.11";
    keyboard.options = words "ctrl:nocaps ctrl:swap_rwin_rctl";
    sessionVariables = {
      BROWSER = "firefox";
      BUGSNAG_RELEASE_STAGE = "local";
      EDITOR = "nvim";
      EMAIL = "${userName} <${userEmail}>";
      ESCDELAY = 25;
      LESS = "-iR";
      LESSHISTFILE = "$XDG_DATA_HOME/less_history";
      PAGER = "less";
      RANGER_LOAD_DEFAULT_RC = "FALSE";
      RXVT_SOCKET = "$XDG_RUNTIME_DIR/urxvtd";
      SSH_ASKPASS = "";
      VISUAL = config.home.sessionVariables.EDITOR;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      npm_config_audit = "false";
      npm_config_cache = "$HOME/.cache/npm";
      npm_config_save_prefix = " ";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle";
      BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
      BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";
      RLWRAP_HOME = "$XDG_DATA_HOME/rlwrap";
      SOLARGRAPH_CACHE = "$XDG_CACHE_HOME/solargraph";
      PBGOPY_SERVER = "http://kwbauson.com:9090/";
      ${attrIf isDarwin "LANG"} = "en_US.UTF-8";
    };
  };

  nix.package = lib.mkForce nix;
  nix.settings =
    optionalAttrs isDarwin
      {
        max-jobs = "auto";
        extra-experimental-features = [ "nix-command" "flakes" ];
        extra-platforms = [ "x86_64-darwin" ];
      }
    // optionalAttrs (machine-name == "keith-mac")
      {
        builders-use-substitutes = "true";
        builders = [ "ssh-ng://keith-desktop x86_64-linux,i686-linux,x86_64-v1-linux,x86_64-v2-linux,x86_64-v3-linux - 24 - benchmark,big-parallel,kvm,nixos-test" ];
      };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    home-manager.path = inputs.home-manager.outPath;
    firefox.enable = !isDarwin;
    chromium.enable = !isDarwin;
    autorandr.enable = isLinux && isGraphical;
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
      controlMaster = "auto";
      matchBlocks = {
        "kwbauson.com".user = "keith";
        "gitlab.com".extraOptions.UpdateHostKeys = "no";
        keith-mac = {
          user = "keithbauson";
          localForwards =
            map
              (port: { bind.port = port; host.address = "localhost"; host.port = port; })
              [ 1234 3000 3001 3306 4000 4306 5432 8000 8025 4002 ]
            ++ [
              { bind.port = 8080; host.address = "api"; host.port = 8080; }
            ];
        };
        keith-desktop.user = "keith";
      };
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
        bind r source-file ~/.config/tmux/tmux.conf
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
        ${optionalString (isLinux && isGraphical) ''bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xsel"''}
      '';
      plugins = with tmuxPlugins; [ jump ];
    };
    neovim = {
      enable = true;
      withNodeJs = true;
      extraConfig = readFile ./init.vim;
      coc.enable = true;
      plugins = with {
        plugins = with vimPlugins; {
          inherit
            conflict-marker-vim fzf-vim nvim-scrollview quick-scope
            tcomment_vim vim-airline
            # vim-better-whitespace
            vim-code-dark vim-easymotion vim-fugitive vim-lastplace
            vim-multiple-cursors vim-peekaboo vim-polyglot vim-sensible
            vim-startify vim-vinegar barbar-nvim nvim-web-devicons

            coc-eslint coc-git coc-json coc-lists coc-prettier
            coc-solargraph coc-tsserver coc-pyright coc-explorer
            coc-vetur
            ;
        };
        makeExtraPlugins = map (n: vimUtils.buildVimPlugin { inherit (sources.${n}) pname version src; });
      }; attrValues plugins
        ++ makeExtraPlugins [ "jsonc.vim" "vim-anyfold" ]
        ++ optional (!isDarwin) vimPlugins.vim-devicons;
      extraLuaConfig = ''
        require'barbar'.setup {
          animation = false,
          auto_hide = false,
          tabpages = true,
          icons = {
            filetype = {custom_colors = true},
            button = false,
            modified = { button = false},
          },
          insert_at_end = true,
          maximum_padding = 0,
        }
      '';
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
    direnv.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = false;
      defaultCommand = "fd -tf -c always -H --ignore-file ${../../ignore} -E .git";
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
        monitor = "-1";
      };
    };
    vscode.enable = isGraphical;
    # vscode.extensions = with vscode-extensions; [ ms-vsliveshare.vsliveshare ];
    mpv.enable = isGraphical && isLinux;
    qutebrowser = {
      enable = isGraphical && isLinux;
      loadAutoconfig = true;
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
      settings = {
        confirm_quit = [ "downloads" ];
        new_instance_open_target = "window";
        session.default_name = "default";
        auto_save.session = true;
        content.cache.size = null;
        content.fullscreen.window = true;
        content.geolocation = false;
        content.pdfjs = true;
        completion.cmd_history_max_items = -1;
        completion.height = "25%";
        completion.show = "auto";
        completion.web_history.exclude = [ "about:blank" ];
        completion.open_categories = [ "bookmarks" "history" ];
        downloads.remove_finished = 1000;
        hints.chars = "asdfghjkl;qwertyuiopzxcvbnm";
        hints.scatter = false;
        hints.uppercase = true;
        input.forward_unbound_keys = "none";
        spellcheck.languages = [ "en-US" ];
        statusbar.position = "top";
        statusbar.widgets = [ "keypress" "url" "scroll" "history" "progress" ];
        tabs.show = "multiple";
        tabs.tabs_are_windows = true;
        url.default_page = "about:blank";
        url.open_base_url = true;
        url.start_pages = [ "about:blank" ];
        window.title_format = "{perc}{current_title}";
        colors.webpage.preferred_color_scheme = "dark";
      };
      keyBindings.normal = {
        ";d" = "hint all delete";
        ";e" = "hint inputs";
        ";f" = "hint all tab-fg";
        ";r" = "hint --rapid all tab-bg";
        ";y" = "hint links yank-primary";
        "<Alt+h>" = "scroll left";
        "<Alt+j>" = "scroll down";
        "<Alt+k>" = "scroll up";
        "<Alt+l>" = "scroll right";
        "<Ctrl+e>" = "scroll-px 0 40";
        "<Ctrl+y>" = "scroll-px 0 -40";
        "<Down>" = "scroll down";
        "<Shift+Space>" = "scroll-page 0 -1";
        "<Space>" = "scroll-page 0 1";
        "<Up>" = "scroll up";
        F = "hint all tab-bg";
        O = "set-cmd-text :open {url:pretty}";
        P = "open -t {primary}";
        T = "set-cmd-text :open -t {url:pretty}";
        Y = "yank";
        b = "set-cmd-text -s :open -b";
        c = "tab-clone";
        gb = "open qute:bookmarks";
        gp = "spawn -u login-fill";
        gq = "open https://github.com/qutebrowser/qutebrowser/commits/master";
        gc = "open https://github.com/kwbauson/cfg";
        gn = "open https://github.com/NixOS/nix/commits/master";
        gN = "open https://github.com/NixOS/nixpkgs/commits/master";
        gs = "set";
        gv = "open qute:version";
        h = "scroll-px -40 0";
        j = "scroll-px 0 40";
        k = "scroll-px 0 -40";
        l = "scroll-px 40 0";
        p = "open {primary}";
        s = "stop";
        t = "set-cmd-text -s :open -t";
        w = "open -t";
        y = "yank --sel";
        u = "undo --window";
      };
      keyBindings.insert = {
        "<Ctrl+h>" = "fake-key <backspace>";
        "<Ctrl+j>" = "fake-key <enter>";
        "<Ctrl+m>" = "fake-key <enter>";
        "<Ctrl+u>" = "fake-key <shift-home><backspace>";
        "<Ctrl+w>" = "fake-key <ctrl-backspace>";
      };
      extraConfig = ''
        config.unbind("<Ctrl+w>")
      '';
    };
  };
  xdg = {
    enable = true;
    ${attrIf isNixOS "mimeApps"} =
      let
        firefox-associations = listToAttrs (
          map (mime: nameValuePair mime "firefox.desktop")
            [
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "x-scheme-handler/chrome"
              "text/html"
              "application/x-extension-htm"
              "application/x-extension-html"
              "application/x-extension-shtml"
              "application/xhtml+xml"
              "application/x-extension-xhtml"
              "application/x-extension-xht"
            ]
        );
      in
      {
        enable = true;
        associations.added = firefox-associations;
        defaultApplications = firefox-associations;
      };
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
        source ${config.home.homeDirectory}/.nix-profile/share/doc/ranger/config/rc.conf
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
        ${mapLines (l: prefixIf (!hasPrefix "*" l) "~/" l) (readFile ../../ignore)}
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
  home.file.".cache/nix-index".source = nix-index-database;

  gtk.enable = isLinux;
  gtk.theme.name = "Adwaita-dark";
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  qt.enable = isLinux;
  qt.style.name = "adwaita-dark";
  dconf.enable = false;

  services.picom.enable = isGraphical && isLinux;
  services.flameshot = {
    enable = isLinux && isGraphical;
    settings.General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };

  xsession = {
    enable = isNixOS && isGraphical;
    initExtra = ''
      xmodmap ${writeText "Xmodmap" ''
        remove mod1 = Alt_L
        keycode 64 = Escape
        ${optionalString (machine-name == "keith-xps") "keycode 105 = Super_R"}
        ${optionalString (machine-name == "keith-desktop") ''
          keycode 134 = Super_R
          keycode 105 = Control_R
        ''}
      ''}
      xmodmap ${writeText "Xmodmap-fix-modifiers" ''
        remove control = Super_R
        remove mod4 = Control_R
        add control = Control_R
        add mod4 = Super_R
      ''} &
      ${exe hsetroot} -solid black &
      xsetroot -cursor_name left_ptr &
      urxvtd -q -o -f &
      togpad off &
      autorandr --change &
      ${optionalString (machine-name == "keith-desktop") "(sleep 5; openrgb --profile default) &"}
    '';
    windowManager = {
      i3 = {
        enable = isNixOS && isGraphical;
        config = null;
        extraConfig = readFile ./i3-config + { }.${machine-name} or "";
      };
    };
  };
}
