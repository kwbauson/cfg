scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "690a5ef508ceef7b936c4f2b9178b0ed4c570f69";
    hash = "sha256-n2vNI8QsAqNMe6kAVqJFxFEsb6yabdcBU/WTAI6hAEQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
