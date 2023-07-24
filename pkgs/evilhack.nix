scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-07-18";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "bf482bb1020d2edc0e837f41f1c53fc8bf3cd675";
    hash = "sha256-dfmXTesLDCUfUe/4Ms7Bho1pNr7W42Dt03VfNgbxR60=";
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
