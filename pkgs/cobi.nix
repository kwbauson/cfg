scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b001fa341c8fdb92d76d5cc21aba49f01086c1f5";
    hash = "sha256-ShauOhJV3D9QdZgEnvpxjr8sOsc2bfQrMZtNk5eEgzc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
