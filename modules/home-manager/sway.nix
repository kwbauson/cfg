{ config, scope, ... }: with scope;
let swayConfig = config.wayland.windowManager.sway.config; in
optionalAttrs (isLinux && isGraphical) {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      input."type:touchpad".tap = "enabled";
      output = {
        keith-desktop = {
          DP-1.position = "0,0";
          DP-2.position = "3440,0";
        };
      }.${machine.name} or { };
      workspaceLayout = "tabbed";
      workspaceAutoBackAndForth = true;
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        size = "11";
      };
      focus = {
        wrapping = "no";
        followMouse = false;
        mouseWarping = false;
      };
      window = {
        titlebar = true;
        hideEdgeBorders = "both";
      };
      floating.modifier = "Mod4";
      modes = { };
      bars = [ ];
      keybindings = { };
      workspaceOutputAssign =
        concatMap (i: map (d: { output = d; workspace = toString i; }) [ "DP-1" "eDP-1" ]) [ 1 3 4 10 ]
        ++ [{ output = "DP-2"; workspace = "2"; }];
    };
    extraConfig = readFile ./sway-config;
  };
  programs.sway-easyfocus = {
    enable = true;
    settings = let bg = "ffff00"; fg = "000000"; in {
      chars = "asdfghjklqwertyuipzxcbvnm1234567890";
      window_background_opacity = 0;
      label_background_color = bg;
      label_text_color = fg;
      focused_background_color = bg;
      focused_text_color = fg;
      show_confirmation = false;
    };
  };
  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 900;
      command = "${sway}/bin/swaymsg 'output * power off'";
      resumeCommand = "${sway}/bin/swaymsg 'output * power on'";
    }];
  };
  services.swaync.enable = true;
  programs.swayr.enable = true;
  programs.swayr.systemd.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "bottom";
    height = 24;
    modules-left = [ "sway/workspaces" "sway/mode" ];
    modules-right = [ "tray" "custom/statusline" ];
    "custom/statusline" = {
      exec = "${getExe bin.statusline} watch";
      return-type = "json";
    };
    tray.icon-size = 20;
  };
  programs.waybar.style = /* css */ ''
    * {
        border: none;
        border-radius: 0px;
        min-height: 0px;
        margin: 0px;
        padding: 0px;
    }

    #waybar {
        background: black;
        color: white;
        font-family: ${head swayConfig.fonts.names};
        font-size: ${swayConfig.fonts.size}pt;
    }

    #workspaces button {
        border: 1px solid transparent;
        padding-left: 2px;
        padding-right: 1px;
        color: white;
        background: #285577;
        border-color: #4c7899;
    }

    #workspaces button:not(.focused) {
        color: #888888;
        background: #222222;
        border-color: #333333;
    }

    #workspaces button.visible:not(.focused) {
        color: white;
        background: #5f676a;
    }

    #workspaces button.urgent {
        color: white;
        background: #900000;
    }

    #mode {
        background: #900000;
    }
  '';
  systemd.user.services.statusline = {
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${getExe bin.statusline} sway";
  };
  home.sessionVariables.NIXOS_OZONE_WL = 1;
}
