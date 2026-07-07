cfg: cfg.lib.fix (scope: with scope;
cfg.lib.generators // cfg.inputs // cfg.outputs // cfg.lib //
cfg.lib.mapAttrs (s: _: cfg.packages.${s}.scope) cfg.legacyPackages //
{
  scope' = scope;
  inherit cfg;
  inherit (cfg) inputs outPath;
  inherit (import ./. { }) getFlakeCompat;
  root = importDir ./.;
  inherit (root) constants modules machines;
  mapAttrNames = f: mapAttrs (n: _: f n);
  mapAttrValues = f: mapAttrs (_: v: f v);
  forAttrs = flip mapAttrs;
  forAttrs' = flip mapAttrs';
  forAttrNames = flip mapAttrNames;
  forAttrValues = flip mapAttrValues;
  forAttrValuesFlagged = attrs: name: forAttrValues (filterAttrs (_: getAttr name) attrs);
  mergeAttrsListWithFunc = f: foldl' (mergeAttrsWithFunc f) { };
  recursiveUpdateList = foldl' recursiveUpdate { };
  pipeValue = xs: pipe null ([ (const (head xs)) ] ++ (tail xs));

  importDir = dir: pipeValue [
    (mapAttrNames (n: dir + "/${n}") (readDir dir))
    attrsToList
    (filter (x: pathIsDirectory x.value || hasSuffix ".nix" x.name))
    (filter (x: x.name != "default.nix"))
    (map (x: nameValuePair (removeSuffix ".nix" x.name) x.value))
    listToAttrs
    (mapAttrValues (p: if pathExists (p + "/default.nix") || !pathIsDirectory p then import p else importDir p))
    (mapAttrValues (x: if isFunction x && (functionArgs x == { _auto = false; scope = false; }) then x { _auto = true; inherit scope; } else x))
  ];

  prefixIf = b: x: y: if b then x + y else y;
  descString = pkg: concatStringsSep "\n" [
    "  name: ${pkg.name or pkg.pname or "null"}"
    "  description: ${pkg.meta.description or "null"}"
    "  homepage: ${pkg.meta.homepage or "null"}"
  ];
  desc = pkg: (trace "\n${descString pkg}" null);
  d = desc;
  mapLines = f: s: concatMapStringsSep "\n"
    (l: if l != "" then f l else l)
    (splitString "\n" s);
  words = string: filter (x: isString x && x != "") (split "[[:space:]]+" string);
  attrIf = check: name: if check then name else null;
  userName = "Keith Bauson";
  userEmail = "kwbauson@gmail.com";
  nixpkgsPath = inputs.nixpkgs.outPath;
  importNixpkgs = args:
    let
      helper =
        { system
        , config ? id
        , overlays ? id
        , rev ? null
        , sha256 ? null
        , path ? nixpkgsPath
        , owner ? "NixOS"
        , repo ? "nixpkgs"
        , src ? if sha256 != null then fetchFromGitHub { inherit owner repo rev sha256; }
          else if rev != null then fetchTree { type = "github"; inherit owner repo rev; }
          else path
        }: import src {
          inherit system;
          overlays = (if isList overlays then const overlays else overlays) root.nixpkgs.overlays;
          config = (if isAttrs config then const config else config) root.nixpkgs.config;
        };
    in
    helper (
      if isPath args then { path = args; }
      else if isString args then { rev = args; }
      else if isDerivation args then { src = args; }
      else args
    );
  pathAdd = pkgs: "export PATH=${makeBinPath (toList pkgs)}:$PATH";
  cfgLastModifiedDateString = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" cfg.lastModifiedDate);

  mkFromEnabled = attrs: f:
    let
      error = throw "mkFromEnabled: `f` must produce non-lazy attrs";
      fake = f error error;
      enabled = filterAttrs (_: c: c.enable) attrs;
    in
    mapAttrs (name: _: mkMerge (mapAttrsToList (n: v: (f n v).${name}) enabled)) fake;
  mkSubmodulesOption = module: mkOption {
    type = types.attrsOf (types.submodule module);
  };
  mkTypeOption = type: mkOption { inherit type; };
})
