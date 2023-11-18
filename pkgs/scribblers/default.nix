scope: with scope;
buildGoModule {
  inherit pname;
  version = "unstable-2023-11-18";
  src = fetchFromGitHub {
    owner = "dataisbaye";
    repo = "scribble.rs";
    rev = "8aba83bcb8cf2bc0a6a3d2b517ff8f4781f98b39";
    hash = "sha256-jnUsIrzoucvW8UyNy0D3lWKgGvaieiUiW+aJnOENdkM=";
  };
  vendorHash = "sha256-8v1EHgBeme5PQ98b9uJoq3t7XWMu12ooF9LmnWDBiDc=";
  patches = [ ./choose-ten.patch ];
  doCheck = false;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { branch = "add-gifs"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
