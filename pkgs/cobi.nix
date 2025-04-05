scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "83fa7a8165bf0bf32d5685d48548b368855166ea";
    hash = "sha256-81itDCsO2H8NUlVkCqac7YG4d2QDC68rL0CfH3Is6hE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
