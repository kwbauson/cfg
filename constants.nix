rec {
  localhost.ip = "127.0.0.1";
  http.port = 80;
  https.port = 443;
  ssh.port = 22;

  personal-api.port = 13000;
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
  cloudflare.account_id = "8f363d22bedef7fc30df7bfac405283f";
}
