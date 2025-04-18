scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "696af1d9240a28ab32590ab5c7a57a8f07375a76";
    hash = "sha256-+LczHwZoMyhPt64YvvAxcnz7SlqopSMOIxxwdGx/E4M=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
