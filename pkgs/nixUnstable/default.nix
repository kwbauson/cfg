pkgs: with pkgs; mylib.override nixUnstable {
  doCheck = false;
  patches = [ ./traceContext-primop.patch ];
}
