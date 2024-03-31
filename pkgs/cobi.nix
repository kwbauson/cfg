scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0202dd4439ad66ae8748694d512e079eb22a8696";
    hash = "sha256-mkEh49od7WwClHuTnkobyu8AJ94PYrUh+tXJg4Cxwi8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
