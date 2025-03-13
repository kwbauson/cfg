rec {
  kwbauson.ip = "208.87.134.252";
  kwbauson.ip6 = "2602:ff16:3:0:1:10d:0:1";
  kwbauson.tailscale-ip = "100.89.245.93";
  kwbauson.gateway = "208.87.134.1";
  kwbauson.fqdn = "kwbauson.${kwbauson.domain}";
  kwbauson.domain = "com";
  keith-server.ip = "100.107.6.112";
  keith-server.tailscale-ip = keith-server.ip;
  cloudflare-dns.ips = [ "1.1.1.1" "1.0.0.1" ];
  personal-api.port = 13000;
  olivetin.port = 1337;
  file-server.port = 18080;
  netdata.port = 19999;
  http.port = 80;
  https.port = 443;
  ssh.port = 22;
  scribblers.port = 8100;
  on-demand-tls.port = 5555;
  temp-http.port = 8000;
  valheim.start-port = 2456;
  valheim.end-port = 2457;
  valheim.ports = [ valheim.start-port valheim.end-port ];
}
