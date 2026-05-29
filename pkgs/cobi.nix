scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1c90200a7b862667dba4337bc5df9e8da9e5c680";
    hash = "sha256-2nSX2NSGQNcJYmxAXIb0tz5bRJ87kxEKKIu/ZMsBEKo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
