{ config, scope, machine-name, isNixOS, isGraphical, ... }: with scope;
{
  home = {
    stateVersion = "22.11";
    keyboard.options = words "ctrl:nocaps ctrl:swap_rwin_rctl";
    sessionVariables = {
      BROWSER = "firefox";
      BUGSNAG_RELEASE_STAGE = "local";
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
    ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPersist = "1m";
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
      fonts = [ "xft:DejaVuSansMNerdFontMono:size=12" ];
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
        ${readFile "${ranger}/share/doc/ranger/config/rc.conf"}
        set vcs_aware true
        map D delete
        map Q quit!
        map ! shell bash
      '';
      "ranger/rifle.conf".text = replaceStrings
        [ "xdg-open --" "has sxiv" "sxiv --" ]
        [ "xdg-open" "has nsxiv" "nsxiv -a --" ]
        (readFile "${ranger}/share/doc/ranger/config/rifle.conf");
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
