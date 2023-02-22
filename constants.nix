rec {
  kwbauson.ip = "208.87.134.252";
  kwbauson.ip6 = "2602:ff16:3:0:1:10d:0:1";
  kwbauson.gateway = "208.87.134.1";
  kwbauson.fqdn = "kwbauson.${kwbauson.domain}";
  kwbauson.domain = "com";
  keith-server.ip = "100.107.6.112";
  cloudflare-dns.ips = [ "1.1.1.1" "1.0.0.1" ];
  olivetin.port = 1337;
  olivetin.authed-port = 11337;
  file-server.port = 18080;
  netdata.port = 19999;
  http.port = 80;
  https.port = 443;
  jitsi.caddy-port = 15280;
  jitsi.tcp-port = 4443;
  jitsi.udp-port = 10000;
  valheim.ports = [ 2456 2457 ];
  ssh.port = 22;
}
