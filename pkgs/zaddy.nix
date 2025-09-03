scope: with scope;
addMetaAttrs { skipBuild = isDarwin; }
  (
    cobi.pkgs.zaddy.overrideAttrs (old: {
      postInstall = caddy.postInstall;
      passthru = removeAttrs old.passthru [ "tests" ];
    })
  )
