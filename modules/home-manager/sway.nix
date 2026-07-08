{ scope, ... }: with scope;
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
    };
    extraConfig = readFile ./sway-config;
  };
  programs.sway-easyfocus = {
    enable = true;
    settings = let bg = "ffff00"; fg = "000000"; in {
      chars = "asdfghjkl;";
      window_background_opacity = 0;
      label_background_color = bg;
      label_text_color = fg;
      focused_background_color = bg;
      focused_text_color = fg;
    };
  };
  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 300;
      command = "${sway}/bin/swaymsg 'output * power off'";
      resumeCommand = "${sway}/bin/swaymsg 'output * power on'";
    }];
  };
  programs.swayr.enable = true;
  programs.swayr.systemd.enable = true;
}
