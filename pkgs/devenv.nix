scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-23";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "fa9a708e240c6174f9fc4c6eefbc6a89ce01c350";
    hash = "sha256-OvpkuB5Lx8eomwUgUT4s10fzbrDnPCtCsxOlZ63hYFI=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
