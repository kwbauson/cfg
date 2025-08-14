scope: with scope;
addMetaAttrs { skipBuild = isDarwin; }
  (
    cobi.pkgs.zaddy.overrideAttrs {
      postInstall = caddy.postInstall;
      passthru = { };
    }
  )
