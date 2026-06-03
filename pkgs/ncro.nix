scope: with scope;
importPackage {
  inherit pname;
  version = "2.2.0-unstable-2026-06-02";
  src = fetchFromGitHub {
    owner = "feel-co";
    repo = pname;
    rev = "8cb77a1eedab7355801c0a9f976b7551fdf2e998";
    hash = "sha256-NqXI6uSi3r9JtKK03GjWNcKou/BHbBfP1kWECYu+G14=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
}
