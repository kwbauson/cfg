scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1d29ad984741dafca1eb87a11419c41e923b613e";
    hash = "sha256-0K4dDst22EOBUa8IrMqDU2YlW5gSdhBdInNcRXFLXXc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
