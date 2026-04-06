scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "68519b988106ca128f0e0adff3aef7ce7fde1e14";
    hash = "sha256-xDd6wIo72zzbCdYt6oAYD6Z7QUS4XIcrvlD/Yyy0TWA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
