scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5152ae6afb71be07a5efb737f4157e2ceb778151";
    hash = "sha256-3Z5FGITZP9K6MiNgGH6ocgljUYeD7bEE32s/IlRIQl8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
