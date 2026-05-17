{ config, osConfig, scope, ... }: with scope;
let
  enable = (
    osConfig.services.keyd.enable &&
    elem
      osConfig.systemd.services.keyd.serviceConfig.Group
      osConfig.users.users.${username}.extraGroups
  );
  keyd-generate-config = writeBash "keyd-generate-config" ''
    set -euo pipefail
    ${pathAdd [ gawk gnused ]}
    cd ~/.config/keyd
    conf=$(< base.conf)
    if [[ -e extra.conf ]];then
      conf+=$'\n'
      conf+=$(< extra.conf)
    fi
    ${toShellVars vars}
    echo -n "$conf" \
      | awk \
        ${awkVars} \
        '{${awkSubs}}1' \
      | sed -E '/^[^.] =/s/^(\w+) = (.*)$/main.\1 = \2\nmeta.\1 = M-\1/' \
      > app.conf
  '';
  awkVars = concatMapStringsSep " " (n: ''-v ${n}="''$${n}"'') (attrNames vars);
  awkSubs = concatMapStringsSep ";" (n: ''gsub(/^\''$${n}$/,${n})'') (attrNames vars);
  vars = {
    viNav = ''
      h = left
      j = down
      k = up
      l = right
    '';
    viActions = ''
      d = z
      f = x
      s = c
      w = escape
      e = tab
    '';
    noEscape = ''
      main.leftalt = leftalt
      meta.leftalt = M-escape
    '';
  };
in
{
  systemd.user.services.keyd-application-mapper = mkIf enable {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      X-Restart-Triggers = [ config.xdg.configFile."keyd/base.conf".source ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
      Environment = [ "PATH=${makeBinPath [ keyd ]}" "PYTHONUNBUFFERED=1" ];
      Type = "exec";
      ExecStartPre = keyd-generate-config;
      ExecStart = "${keyd}/bin/keyd-application-mapper -v";
    };
  };
  xdg.configFile."keyd/base.conf".text = ''
    [steam-app-418530|spelunky-2]
    $viNav
    $viActions
    a = d
    g = a
    [steam-app-3041230|windrose]
    $noEscape
  '';
}
