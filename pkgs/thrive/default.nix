scope: with scope;
let version = "0.6.3"; in
buildDotnetModule {
  inherit pname version;
  src = fetchgit {
    url = "https://github.com/Revolutionary-Games/Thrive.git";
    rev = "v${version}";
    fetchLFS = true;
    hash = "sha256-kr9X3wSPzx7FSEy3vKJIBcYbCAhdiUpYmLfSxpHl3m4=";
  };
  nugetDeps = "";
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
}
