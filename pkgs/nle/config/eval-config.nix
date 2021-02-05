with builtins;
let
  override = x: y:
    if y ? _apply then y._apply x
    else if y ? _replace then y._replace
    else if isList x && isList y then x ++ y
    else if isAttrs x && isAttrs y then
      mapAttrs (n: v: if hasAttr n y then override v y.${n} else v) (y // x)
    else y;
  fix = f:
    let x = f x; in x;
  evalConfig = config: fix (self:
    let eval = cfg:
      if isFunction cfg then cfg self
      else if isPath cfg then eval (import cfg)
      else if isList cfg then foldl' override { } (map eval cfg)
      else if cfg ? imports then eval [ cfg.imports (removeAttrs cfg [ "imports" ]) ]
      else cfg;
    in eval config
  ) // { withConfig = cfg: evalConfig [ config cfg ]; };
in
evalConfig
