scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-27";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "148c4a21e50428728e97f3cdf59166b6007db8a7";
    hash = "sha256-CPR3WcnrrIiDZJiMo4RlyZB0M3576pHmtlTUnMUTugA=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
