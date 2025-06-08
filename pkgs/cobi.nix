scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d90f00f297fa4d02253780901da304c2dbf71966";
    hash = "sha256-OXXLfzQ2om/r9jLemr/DZrWhWcEc5a4tugD/LGHnIm0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
