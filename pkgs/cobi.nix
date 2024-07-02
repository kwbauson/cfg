scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4e0abf9479b4234f89477f2f40b5b630fb899941";
    hash = "sha256-3e5D1uCohdtL5pfIrom1VFptwyzSdlff83RW4oiDhG8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
