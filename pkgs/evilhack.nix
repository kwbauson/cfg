scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-14";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "e1a077c1111ebfc64fc20d5d336f74cee830f001";
    hash = "sha256-bDzkCQstLu+iZIqmuMVRdmneZBICPWdPMccK3pwnoQk=";
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
