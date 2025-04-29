finalPkgs: prevPkgs: prevPkgs.lib.genAttrs [ "python311" "python312" "python313" ]
  (pythonAttr: prevPkgs.${pythonAttr}.override {
    packageOverrides = final: prev: {
      accelerate = prev.accelerate.overrideAttrs {
        doCheck = false; # tests fail on rocm
      };
    };
  })
