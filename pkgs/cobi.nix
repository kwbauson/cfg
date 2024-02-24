scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7d7df757c04ef055a2eab739780412b3f8500962";
    hash = "sha256-5aWitcDAg5iKdsD24Q6rbh2SvgGZD8zw8pyxgNiL948=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
