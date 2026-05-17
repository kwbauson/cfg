{ config, osConfig, scope, ... }: with scope;
{
  systemd.user.services.keyd-application-mapper = mkIf
    (
      osConfig.services.keyd.enable &&
      elem
        osConfig.systemd.services.keyd.serviceConfig.Group
        osConfig.users.users.${username}.extraGroups
    )
    {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        X-Restart-Triggers = [ config.xdg.configFile."keyd/app.conf".source ];
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Service.Environment = [ "PATH=${makeBinPath [ keyd ]}" "PYTHONUNBUFFERED=1" ];
      Service.Type = "exec";
      Service.ExecStart = "${keyd}/bin/keyd-application-mapper -v";
    };
  xdg.configFile."keyd/app.conf".text =
    let
      mkSection = name: keys: ''
        [${name}]
        ${concatMapAttrsStringSep "\n" (from: to: if hasPrefix "_raw" from then to else "main.${from} = ${to}") keys}

        ${concatMapAttrsStringSep "\n" (from: _: "meta.${from} = M-${from}") (filterAttrs (n: _: !hasPrefix "_raw" n) keys)}
      '';
      mkSections = concatMapAttrsStringSep "\n" mkSection;
      viNav = {
        h = "left";
        j = "down";
        k = "up";
        l = "right";
      };
      viActions = {
        d = "z";
        f = "x";
        s = "c";
        w = "escape";
        e = "tab";
      };
      noEscape._raw_ne = ''
        main.leftalt = leftalt
        meta.leftalt = M-escape
      '';
    in
    mkSections {
      "steam-app-418530|spelunky-2" = viNav // viActions // {
        a = "d";
        g = "a";
      };
      "steam-app-3041230|windrose" = noEscape;
    };
}

