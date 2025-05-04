scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "96a9919c48ebdf8d58db118a6fc114c03d1969ef";
    hash = "sha256-uxPQa6ETW15NALziVYMXXCdWatW011XGNImU3LXo3ns=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
