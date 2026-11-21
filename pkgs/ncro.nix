scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-11-16";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "f4f0f1e47388edb04fe5a31193c6f475b9662be6";
    hash = "sha256-GCzOJ0BG5VZQX129Q8MXXDBHAihfceV62AjL3JhVdaA=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
