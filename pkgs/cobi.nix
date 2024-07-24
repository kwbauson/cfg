scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "03f0ed42f8cac12cdd1dc4ed3c63edfbdc33b197";
    hash = "sha256-Ut/t0/DeixfvP1Uvyt7MiMX623KdiQs0Jz9GvrBawxI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
