scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9f652a1867e50d63cd7d66bcc8879346bfc90287";
    hash = "sha256-Jt8Fc/tSJW9EbIge0mvWFzWvnMaMz439w0/V90OoWgU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
