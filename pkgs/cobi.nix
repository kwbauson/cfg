scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7d7f5497eb97037cf240fc88f92c51a0d1e993f6";
    hash = "sha256-WlnUGSYtCSprmD8k3Erd+dKsRIhkA8zmVUYik/uc9t8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
