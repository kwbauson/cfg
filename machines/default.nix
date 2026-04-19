{ _auto, scope }: with scope;
let
  naiveModuleConfig = m:
    let r = if isFunction m then m (functionArgs m // { inherit lib scope; }) else m; in
    naiveResolveModuleOverrides (r.config or r);
  naiveResolveModuleOverrides = mapAttrsRecursiveCond (x: !(isAttrs x && x._type or "" == "override")) (_: x: x.content or x);
  naiveMergeModuleFunc = x: y: if isAttrs x && isAttrs y then x // y else throw "cannot merge";
  naiveMergeModules = ms: mergeAttrsListWithFunc naiveMergeModuleFunc (map naiveModuleConfig ms);
  rawMachines = removeAttrs (importDir ./.) [ "default" ];
in
pipe rawMachines (map mapAttrs [
  (name: machine: machine // {
    inherit name;
    partial = naiveMergeModules [
      (machine.hardware-configuration or { })
      (machine.home-configuration or { })
      (machine.darwin-configuration or { })
      (machine.configuration or { })
    ];
  })
  (_: m: m // m.partial.machine or { })
  (_: m: fix (machine: m // {
    system = m.partial.nixpkgs.hostPlatform;
    username = m.username or "keith";
    isNixOS = m ? configuration;
    isNixDarwin = m ? darwin-configuration;
    isGraphical = m.isGraphical or true;
    isMinimal = m.isMinimal or false;
    scope = {
      inherit machine;
      inherit (machine) isNixOS isNixDarwin username isGraphical isMinimal;
    };
  }))
])
