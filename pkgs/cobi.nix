scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "adca3f38519f7b92fcf8e8eb6cceda89a77453b4";
    hash = "sha256-UouX9NBqOqRDgTxxLKo/+3vNokE5ZzRKANAv8VbGIro=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
