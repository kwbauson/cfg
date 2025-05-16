scope: with scope;
cobi.pkgs.zaddy.overrideAttrs {
  postInstall = caddy.postInstall;
  vendorHash = "sha256-EUJqeo6sWT5N334MQ73iNVcOMVEalu31vescu9ckm5g=";
  passthru = { };
  meta.skipBuild = isDarwin;
}
