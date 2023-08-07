scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "8a65ef4aab311867645b9e798941b8f032954f5f";
    hash = "sha256-Rl/9KxbnUf6HwhTNvyU6DO8/j4hgSATvCHaj0VFKU9M=";
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
