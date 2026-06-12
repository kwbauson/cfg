{ config, scope, ... }: with scope;
{
  xsession.windowManager.i3 = {
    enable = config.xsession.enable;
    config = {
      keybindings = { };
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
      floating = {
        modifier = "$mod";
      };
      modes = { };
      bars = [ ];
    };
    extraConfig = readFile ./i3-config;
  };
}
