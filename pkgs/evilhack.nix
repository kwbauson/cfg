scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-02";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "9bf0cf437a6447d4fb46e2e541f484366a41362d";
    hash = "sha256-QgJzmdiWtD15OL1ZmnOfeTSoiB7pYFZWCMJJtQj5628=";
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
