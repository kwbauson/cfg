scope: with scope;
nethack.overrideAttrs (attrs: {
  inherit pname;
  version = "unstable-TODO";
  src = fetchFromGitHub {
    owner = "k21971";
    repo = "EvilHack";
    rev = "3beb033895fbff91b8cd07775764d779305f7625";
    hash = "sha256-0g9gWKmbia2kHAd8VlGYoHjyuiZ9jqNfySk0gBuzyCU=";
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
  passthru.updateScript = unstableGitUpdater { };
})
