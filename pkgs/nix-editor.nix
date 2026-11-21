scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0.3.0-unstable-2026-11-19";
  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = pname;
    rev = "48e614712adbaaf8c33d5bc8c818514fe9bb44b2";
    hash = "sha256-ESQ+O7azbafzqntDlqePoWUcKse2IArabmxXVjA9tm4=";
  };
  package = callPackage attrs.src { };
  passthru.updateScript = unstableGitUpdater { };
})
