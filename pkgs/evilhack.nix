scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-12";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "01d8e38c8a2b362287ff8a5a58c2e92d156df7fa";
    hash = "sha256-d9qqSNHDA55zw6/JyvQYJZaXPgelO4ZLQdKvc78+IDw=";
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
