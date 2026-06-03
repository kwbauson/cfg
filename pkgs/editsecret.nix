scope: with scope;
let
  agenix = pkgs.agenix.package.override { nix = lixPackageSets.latest.lix; };
  machineKeys = mapAttrValues (m: m.public-key) machines;
  mkRules = writeText "mk-rules.nix" /* nix */ ''
    { isShared, name, machines }:
    let
      keys = ${toPretty {} machineKeys};
    in
    {
      ''${name}.publicKeys = map (n: keys.''${n}) machines;
    }
  '';
  script = writeBashBin pname ''
    set -euo pipefail
    cd ~/cfg/secrets
    if [[ $1 = -s ]];then
      isShared=true
      machines=$2
      name=$3.age
    else
      isShared=false
      machines=$(machine-name)
      name=$machines.$1.age
    fi
    printf -v machinesStr '"%s" ' $machines
    export RULES="${mkRules} { isShared = $isShared; name = \"$name\"; machines = [ $machinesStr]; }"
    ${agenix}/bin/agenix --edit "$name"
  '';
in
addMetaAttrs { includePackage = true; } (script.overrideAttrs { passthru = { inherit mkRules; }; })
