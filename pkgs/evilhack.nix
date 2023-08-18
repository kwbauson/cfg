scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-18";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "e537fd00cc643881cd00f64fe9cb06dc499d02ef";
    hash = "sha256-J8ehg6sLmw1ukAiT0/+Fw84cdOynr2JdbHDZPmHGdh8=";
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
