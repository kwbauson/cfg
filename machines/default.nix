{ scope }: with scope;
let
  naiveModuleConfig = m:
    let r = if isFunction m then m (functionArgs m // { inherit lib scope; }) else m; in
    naiveResolveModuleOverrides (r.config or r);
  naiveResolveModuleOverrides = mapAttrsRecursiveCond (x: !(isAttrs x && x._type or "" == "override")) (_: x: x.content or x);
  naiveMergeModuleFunc = x: y: if isAttrs x && isAttrs y then x // y else throw "cannot merge";
  naiveMergeModules = ms: mergeAttrsListWithFunc naiveMergeModuleFunc (map naiveModuleConfig ms);
  rawMachines = removeAttrs (importDir ./.) [ "default" ];
in
pipe (mapAttrs (n: x: x // { name = n; }) rawMachines) (map mapAttrValues [
  (machine: machine // rec {
    partial = naiveMergeModules [
      (machine.hardware-configuration or { })
      (machine.home-configuration or { })
      (machine.darwin-configuration or { })
      (machine.configuration or { })
    ];
    system = partial.nixpkgs.hostPlatform;
    isNixOS = machine ? configuration;
    isNixDarwin = machine ? darwin-configuration;
  })
  (m: m // m.partial._module.args or { })
])
