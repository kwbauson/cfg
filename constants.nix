rec {
  localhost.ip = "127.0.0.1";
  http.port = 80;
  https.port = 443;
  ssh.port = 22;

  tailnet = "tail6a226.ts.net";

  kwbauson.ip = "208.87.134.252";
  kwbauson.ip6 = "2602:ff16:3:0:1:10d:0:1";
  kwbauson.gateway = "208.87.134.1";
  kwbauson.fqdn = "kwbauson.${kwbauson.domain}";
  kwbauson.domain = "com";

  personal-api.port = 13000;
  olivetin.port = 1337;
  file-server.port = 18080;
  netdata.port = 19999;
  scribblers.port = 8100;
  on-demand-tls.port = 5555;
  temp-http.port = 8000;
  valheim.start-port = 2456;
  valheim.end-port = 2457;
  valheim.ports = [ valheim.start-port valheim.end-port ];
  prometheus = {
    port = 9090;
    exporters.node.port = 9002;
  };
  loki.port = 9091;
}
