scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-08-06";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "fa3c9bbeb6f1a4bbf840ab28dbefd23c20112d48";
    hash = "sha256-9PKrRq3TFWzvfWFkJjGuvnvYT+W+3EraHJOdno89Lqg=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
