{ scope ? (import ../. { }).scope }: with scope;
let
  keys = mapAttrs (_: m: m.public-key) machines;
  mkRules = mapAttrs' (n: v: nameValuePair "${n}.age" (if isString v || isList v then { publicKeys = toList v; } else v));
in
with keys;
mkRules {
  cachix-dhall = {
    publicKeys = [ keith-desktop keith-xps keith-server readlee-mac-m1 ];
    isUserSecret = true;
  };
  keith-server-github-runner-token = keith-server;
  grafana-secret-key = { publicKeys = [ keith-server ]; owner = "grafana"; };
  harmonia-sign-key = keith-server;
  caddy-environment = keith-server;
  palworld-environment = keith-server;
  valheim-environment = keith-server;
  readlee-mac-m1-github-runner-token = { publicKeys = [ readlee-mac-m1 ]; owner = "_github-runner"; };
}
