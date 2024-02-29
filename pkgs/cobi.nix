scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "228028b3710aad9d15abb30df9edc683581002b3";
    hash = "sha256-iYUaXnxrxaxjMdA/my8C+BE+75m/uvdq1QhmtzOxvjs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
