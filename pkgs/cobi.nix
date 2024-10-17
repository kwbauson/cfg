scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7115e5c49be919413a3e942a92934d15d2d85b80";
    hash = "sha256-9YDHlKuyPyM+BR2gInFL1Lpf6kip5EuBqxIdnaEd9G8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
