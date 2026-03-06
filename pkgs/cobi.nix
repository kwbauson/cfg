scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "df08780106f6e74056ddff4c4918a25be3d0ec58";
    hash = "sha256-tXZ2HARLgho34odn+5gnrhvgfG8g9DFxVPhj5sQT2t8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
