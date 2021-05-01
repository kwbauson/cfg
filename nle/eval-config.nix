with builtins;
let lib = rec {
  override = x: y:
    if y ? _apply then y._apply x
    else if y ? _replace then y._replace
    else if isList x && isList y then x ++ y
    else if isList x then x ++ [ y ]
    else if isAttrs x && isAttrs y then
      mapAttrs (n: v: if hasAttr n y then override v y.${n} else v) (y // x)
    else y;
  fix = f:
    let x = f x; in x;
  flatten = x: if isList x then concatMap (y: flatten y) x else [ x ];
  evalConfig = config: fix
    (self:
      let eval = cfg:
        if isFunction cfg then eval (cfg self)
        else if isPath cfg then eval (import cfg)
        else if isList cfg then foldl' override { } (map eval cfg)
        else cfg;
      in eval config
    ) // {
    withConfig = cfg:
      let configs = flatten [ config cfg ]; in
      evalConfig configs // { inherit configs; };
  };
}; in (lib.evalConfig { inherit lib; }).withConfig
