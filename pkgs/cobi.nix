scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b572457758dc0260c0d7fec92534707a93c1dd74";
    hash = "sha256-/5ibBJ1pLz0XTMqj/Ih4N4/nkC2emO0GPOtA2FO7ZyQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
