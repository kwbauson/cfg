scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "42d4a649deac138a2f13133ba6cb39269666aab6";
    hash = "sha256-lUiKgBY/jpKVI5XaHat3miLBFWP9slYrYNudsZQ99AE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
