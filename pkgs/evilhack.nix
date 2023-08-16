scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-16";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "738d7b1fcc8439532de495320e8aeec6771cd096";
    hash = "sha256-sWuxRG7tXdvnHImM8C6C81c3j5XjdFW9KZ9kVaI2Ox0=";
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
