{ scope, machine-name, ... }: with scope; {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = optionals isLinux [ "systemd" ];
    port = constants.prometheus.exporters.node.port;
    listenAddress = constants.${machine-name}.tailscale-ip;
  };
  imports = [
    (optionalAttrs isLinux {
      services.alloy.enable = true;
      systemd.services.alloy.serviceConfig.SupplementaryGroups = [ "adm" "systemd-journal" ];
      environment.etc."alloy/config.alloy".text = ''
        loki.source.journal "systemd_journal" {
          forward_to = [loki.write.grafana_loki.receiver]
          format_as_json = true
          labels = {
            instance = "${machine-name}",
          }
        }

        loki.write "grafana_loki" {
          endpoint {
            url = "http://keith-server:${toString constants.loki.port}/loki/api/v1/push"
          }
        }
      '';
    })
  ];
}
