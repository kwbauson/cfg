{ config, scope, machine-name, isNixOS, isGraphical, ... }: with scope;
{
  home = {
    stateVersion = "22.11";
    sessionVariables = {
      BROWSER = "firefox";
      EMAIL = "${userName} <${userEmail}>";
      ESCDELAY = 25;
      LESS = "-iR";
      LESSHISTFILE = "$XDG_DATA_HOME/less_history";
      PAGER = "less";
      RANGER_LOAD_DEFAULT_RC = "FALSE";
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
      ${attrIf isDarwin "LANG"} = "en_US.UTF-8";
    };
  };

  nix.package = lib.mkForce lixPackageSets.latest.lix;
  nix.settings = optionalAttrs isDarwin {
    max-jobs = "auto";
    extra-experimental-features = [ "nix-command" "flakes" ];
    extra-platforms = [ "x86_64-darwin" ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    home-manager.path = inputs.home-manager.outPath;
    dircolors.enable = true;
    firefox.enable = !isDarwin && isGraphical;
    chromium.enable = !isDarwin && isGraphical;
    autorandr.enable = isLinux && isGraphical;
    helix.enable = true;
    ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPersist = "1s";
      matchBlocks = {
        "kwbauson.com".user = "keith";
        "gitlab.com".extraOptions.UpdateHostKeys = "no";
        keith-desktop.user = "keith";
      };
      includes = [ "config.d/*" ];
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
    kitty = {
      enable = true;
      font.name = "DejaVu Sans Mono";
      font.size = 12;
      settings.scrollback_lines = 65535;
      settings.cursor_blink_interval = 0;
      settings.clipboard_control = "write-primary read-primary";
      settings.enable_audio_bell = false;
      settings.allow_remote_control = true;
      shellIntegration.mode = "disabled";
      extraConfig = ''
        mouse_map left click ungrabbed no-op
        mouse_map ctrl+left click ungrabbed mouse_handle_click selection link prompt

        # see https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
        # Nerd Fonts v3.2.0
        symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono
      '';
    };
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    direnv.nix-direnv.package = lixPackageSets.latest.nix-direnv;
    fzf = {
      enable = true;
      enableBashIntegration = false;
      defaultCommand = "fd -c always -H --ignore-file ${../../ignore} -E .git -tf | sort -V";
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
    mpv.bindings.M = ''cycle-values audio-channels "mono" "stereo"'';
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
      "ranger/rc.conf".source = runCommand "ranger-rc.conf" { } ''
        cat ${ranger}/share/doc/ranger/config/rc.conf > $out
        cat >> $out <<EOF
        set vcs_aware true
        map D delete
        map Q quit!
        map ! shell bash
        EOF
      '';
      "ranger/rifle.conf".source = runCommand "ranger-rifle.conf" { } ''
        cat ${ranger}/share/doc/ranger/config/rifle.conf > $out
        sed -i \
          -e 's/xdg-open --/xdg-open/' \
          -e 's/has sxiv/has nsxiv/' \
          -e 's/sxiv --/nsxiv -a --/' \
          $out
      '';
      "ranger/plugins/ranger_devicons".source = ranger_devicons;
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

  gtk.enable = isGraphical && isLinux;
  gtk.theme.name = "Adwaita-dark";
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  qt.enable = isGraphical && isLinux;
  qt.style.name = "adwaita-dark";
  dconf.enable = false;

  services.picom.enable = isGraphical && isLinux;

  services.flameshot = {
    enable = isGraphical && isLinux;
    settings.General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };

  services.clip.sync-primary.enable = isGraphical && isLinux;

  xsession = {
    enable = isNixOS && isGraphical;
    initExtra = ''
      ${exe hsetroot} -solid black &
      xsetroot -cursor_name left_ptr &
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

  systemd.user.startServices = "sd-switch";
}
