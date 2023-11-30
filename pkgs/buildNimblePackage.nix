scope: with scope;
let
  parseGithubUrl = url:
    let pair = match "https://github.com/([^/]*)/([^/]*)" url;
    in {
      owner = elemAt pair 0;
      repo = removeSuffix ".git" (elemAt pair 1);
    };
in
{ nim ? pkgs.nim2
, allOverrides ? { }
, overrides ? { }
, ...
}@attrs:
let
  inherit (attrs) src;
  nimbleLock = pipe "${src}/nimble.lock" [
    readFile
    unsafeDiscardStringContext
    fromJSON
  ];
  nimblePackages = pipe nimbleLock [
    (getAttr "packages")
    (mapAttrs (pname: spec: buildNimPackage ({
      pname = "nim-${pname}";
      inherit (spec) version;
      src = fetchTree {
        type = "github";
        inherit (parseGithubUrl spec.url) owner repo;
        rev = spec.vcsRevision;
      };
      buildInputs = map (n: nimblePackages.${n}) spec.dependencies ++ overrides.${pname}.buildInputs or [ ];
      passthru = { inherit spec; };
    } // removeAttrs overrides.${pname} or { } [ "buildInputs" ] // allOverrides)))
    (attrs: attrs // { inherit nim; })
  ];
in
buildNimPackage (
  (recursiveUpdate
    {
      buildInputs = map (n: nimblePackages.${n}) (attrNames nimbleLock.packages) ++ attrs.buildInputs or [ ];
      passthru = {
        pkgs = nimblePackages;
        inherit nimbleLock;
      };
    }
    (removeAttrs attrs [ "nim" "allOverrides" "overrides" "buildInputs" ])
  ) //
  allOverrides
)
