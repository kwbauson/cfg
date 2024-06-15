scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b2c232a856cf60ab3302fbcf92b44c5342306d4f";
    hash = "sha256-a4NH+Wmv5+mZhK0sDr8Z09OZOLTThMeySa17mtjyEro=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
