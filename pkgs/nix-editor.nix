scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0.3.0-unstable-2026-02-26";
  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = pname;
    rev = "a72c7d695d5568fe19ff34d161a22c716ffbdc07";
    hash = "sha256-9CP5NPGPNEJZCAIUytdXrvDXUBaOKaw6uAKJwvonJBI=";
  };
  package = callPackage attrs.src { };
  passthru.updateScript = unstableGitUpdater { };
})
