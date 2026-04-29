finalPkgs: prevPkgs: with prevPkgs.scope';
let
  interpretersNixPath = "${nixpkgsPath}/pkgs/development/interpreters/python";
  pythonNames = pipeValue [
    (import interpretersNixPath)
    (f: f (functionArgs f // { inherit lib; config = prevPkgs.config; }))
    attrNames
    (filter (n: hasAttr n prevPkgs))
  ];
in
genAttrs pythonNames
  (pythonAttr: prevPkgs.${pythonAttr}.override {
    packageOverrides = final: prev: {
      accelerate = prev.accelerate.overrideAttrs {
        doCheck = false; # tests fail on rocm
      };
    };
  })
