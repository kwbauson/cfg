scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b2fa212caa418b03c37c4d14f680ddad0fd9b384";
    hash = "sha256-j4nJjhgHvjTbtCGSJaPG8NCqPCRTwlp2u3VwIXlUtHs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
