scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-07-30";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "a9ad34efe10cc6bac8180c2c2e6780875822ccbc";
    hash = "sha256-hSiCdvXS1rsKIGvNGYgQoDZZmcC1FphCRf8Wuc94QBk=";
  };
  postPatch = ''
    ${attrs.postPatch}
    sed \
      -e '/LIVELOG=/d' \
      -e '/GDBPATH=/d' \
      -e '/GREPPATH=/d' \
      -i sys/unix/sysconf
  '';
  postInstall = lib.replaceStrings [ "nethack" ] [ pname ] attrs.postInstall;
  meta.broken = true;
  passthru.updateScript = unstableGitUpdater { };
})
