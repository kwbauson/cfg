scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3f25a4a872cff8898e218553e6253078b0918b48";
    hash = "sha256-63FPgiIR5zNcX8hSdBfyIFSX5rbhP1k/7SCZmJggoho=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
