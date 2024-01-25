scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-24";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "ca8a2addaf309b85c9a0a72d22aea059fc2bc449";
    hash = "sha256-3htyxD1V1aoH7PL3+YaAIeXRKWb5h+0uH7q+/9EzjV8=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
