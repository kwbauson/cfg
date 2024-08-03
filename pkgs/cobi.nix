scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "50b5fc2fb1d85bd37d346d42f8dfdac84d66d535";
    hash = "sha256-61mGb9jzJcmmuiHqIkVkORs8QT1d3LzJ1z8y7TVomxw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
