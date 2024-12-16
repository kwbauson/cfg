scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "1.55.3-unstable-2024-12-16";
  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = pname;
    rev = "d1124a736ce16f8549f69644882f134820626ef9";
    hash = "sha256-4m0ulBTOxpDY6EltqIxQs3v+kbulfUwW+c4lv5vn/g8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  migrated-src = stdenv.mkDerivation {
    name = "migrated-src";
    inherit (attrs) src;
    nativeBuildInputs = [ uv-migrator uv_050 ];
    installPhase = ''
      export HOME=/tmp/home
      uv-migrator .
      cp -r . $out
    '';
  };

  workspace = inputs.uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = attrs.migrated-src;
  };
})
