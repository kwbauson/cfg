scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7491f2eeba893ef6016cba900130ea990412e077";
    hash = "sha256-TTEP6f0FxVFfisCzaH1kV3IQbD6fWgGUTIXDew4fx6I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
