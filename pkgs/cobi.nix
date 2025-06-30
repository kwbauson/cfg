scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b2a2dc10916bbb05216b9db0cfdaa5dbbe6bf2a9";
    hash = "sha256-6s4xMkmB6ohvke2M9e11lbkm04M8qxXNS309M51IBKU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
