scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4e3e0e39462ee2edfce034a91ad2023657860431";
    hash = "sha256-zOAtCnj9Junzh8yRZNCImn8EEsdsuMfNRyQzHqYXYEg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
