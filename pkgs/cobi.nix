scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e487fb2a0a80746f034cf66a9764dc657c96ce49";
    hash = "sha256-DM1OwiG+RKLyEJOEWu9mQ0ICmEfBADUV3tZMbIv+n9A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
