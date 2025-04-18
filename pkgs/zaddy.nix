scope: with scope;
cobi.pkgs.zaddy.overrideAttrs {
  postInstall = caddy.postInstall;
  passthru = { };
}
