scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-07";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "7a8e6a91510efe89d8dcb8e43233f93e86f6b189";
    hash = "sha256-gQmBjjxeSyySjbh0yQVBKApo2KWIFqqbRUvG+Fa+QpM=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
