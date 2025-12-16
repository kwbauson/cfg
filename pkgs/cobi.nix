scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4b4d45ddc9b7a89b0fa772e963d6227707b9bdb2";
    hash = "sha256-kDj2KiK/w9K6cZxex8AnEX7eT2rE7d6zzlhQeUOu2iI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
