scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-05";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "4eccee9a19ad9be42a7859211b456b281d704313";
    hash = "sha256-X8tp7nYunRZds8GdSEp+ZBMPf3ym9e6VjZWN8fmzBrc=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
