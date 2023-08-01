scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-01";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "9580bea0b3053cd328935d2a5ef17468bfcecb0f";
    hash = "sha256-k/EjdPBzndms0Znak2iZ3w7OjRzL6x2nsYrRpocgNCo=";
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
