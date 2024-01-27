scope: with scope;
attrs:
let
  parseGithubUrl = url:
    let pair = match "https://github.com/([^/]*)/([^/]*)/?" url;
    in {
      owner = elemAt pair 0;
      repo = removeSuffix ".git" (elemAt pair 1);
    };
  nimbleLock = pipe "${attrs.src}/nimble.lock" [
    readFile
    unsafeDiscardStringContext
    fromJSON
  ];
  packages = pipe nimbleLock [
    (getAttr "packages")
    (mapAttrs (pname: spec:
      fetchTree {
        type = "github";
        inherit (parseGithubUrl spec.url) owner repo;
        rev = spec.vcsRevision;
      }
    ))
    attrValues
  ];
in
stdenv.mkDerivation (attrs // {
  inherit packages;
  nativeBuildInputs = [ nim ];
  buildPhase = ''
    export HOME=/tmp/home
    nim compile ${concatMapStringsSep " " (p: "--path:${p}") packages} ${attrs.pname}
    mkdir -p $out/bin
    mv ${attrs.pname} $out/bin
  '';
})
