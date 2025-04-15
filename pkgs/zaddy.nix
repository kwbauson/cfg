scope: with scope;
cobi.pkgs.zaddy.overrideAttrs {
  postInstall = caddy.postInstall;
  vendorHash = "sha256-7k5KobsresXiTLL5d9W6Q9yJ9Pi+cTIR1eqsfxL5MoQ=";
}
