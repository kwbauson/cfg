scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "259017b9ddd2840b88ca2ff6806a1b3a89b81cc0";
    hash = "sha256-BXPwvuHZhC0tpvoYyNZcVwE3Wondc+wkMYMRtAPEbCs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
