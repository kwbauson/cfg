scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "87481ce314d8a8c024fe9cf0d37e5feb8d12ba8f";
    hash = "sha256-wiUC6niSzJxt+Dxivgj6Mzqik5Xp465Kw0MfsbKW/Tk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
