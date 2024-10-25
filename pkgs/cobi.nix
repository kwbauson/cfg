scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c198f7c415c83f8e5b8ae9582d59650b615daf88";
    hash = "sha256-/Rvn5eIDs5eb7BQIRaq8ggG8p7nHmhCj3p+zqNlH6a4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
