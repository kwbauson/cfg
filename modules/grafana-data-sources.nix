{ scope, ... }: with scope; {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = optionals isLinux [ "systemd" "processes" ];
    port = constants.prometheus.exporters.node.port;
    listenAddress = machine.tailscale-ip;
  };
  imports = [
    (optionalAttrs isLinux {
      systemd.services.prometheus-node-exporter.after = [ "tailscaled.service" ];

      services.alloy.enable = true;
      systemd.services.alloy.serviceConfig.SupplementaryGroups = [ "adm" "systemd-journal" ];
      environment.etc."alloy/config.alloy".text = ''
        loki.source.journal "systemd_journal" {
          format_as_json = true
          forward_to = [loki.write.grafana_loki.receiver]
          labels = {
            instance = "${machine.name}",
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
