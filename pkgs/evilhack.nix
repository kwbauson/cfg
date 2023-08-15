scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-15";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "7253753eb1c3242a05e21c5ba8bd9590c8859b94";
    hash = "sha256-e+9Qarrt/nL36o9RrFdlmtCc7he17LYkwmio/LH7fYU=";
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
