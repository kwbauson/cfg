scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "de9af404c2322c2c49fbab6c4ad6602fb86f2a44";
    hash = "sha256-TujsS+TDHqpqodsZ2CgtiRn8v9USCf95qD0LrAFNv9g=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
