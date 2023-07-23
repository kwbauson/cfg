scope: with scope; clipnotify.overrideAttrs (_: {
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "cdown";
    repo = "clipnotify";
    rev = "094dd7e20a06eba80c2e6f27dee775106e0eeca9";
    hash = "";
  };
  passthru.updateScript = defaultUpdateScript;
})
