{ scope, machine-name, ... }: with scope; {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = constants.prometheus.exporters.node.port;
    listenAddress = constants.${machine-name}.tailscale-ip;
  };
}
