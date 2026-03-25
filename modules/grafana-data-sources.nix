{ scope, machine-name, ... }: with scope; {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = optionals isLinux [ "systemd" ];
    port = constants.prometheus.exporters.node.port;
    listenAddress = constants.${machine-name}.tailscale-ip;
  };
  imports = [
    (mkIf isLinux {
      services.alloy.enable = true;
      environment.etc."alloy/config.alloy".text = ''
        loki.source.journal "systemd_journal" {
          forward_to = [loki.write.grafana_loki.receiver]
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
