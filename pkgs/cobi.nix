scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cc95653c2502e4266bc3f008e52cd8c4d5d87dc9";
    hash = "sha256-BZ5Qye2AkuCj9gveKtNbX6cSIBaKqcmqNp52uY++/9A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
