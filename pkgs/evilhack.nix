scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-2023-08-11";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "76bdfbde6c8595c85df3fc5e3a2d73f610c585eb";
    hash = "sha256-bemwMqNxNXkeZzWVSADDmOniu1fjncmhO63Jy4zmStw=";
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
