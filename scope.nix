args: args.lib.fix (scope: with scope;
args.lib.generators // args.formats or { } // args.writers or { } //
args.flake.inputs or { } // args.flake.outputs or { } //
removeAttrs builtins [ "fetchurl" ] // args // args.lib // {
  inherit (import ./. { inherit system; }) getFlakeCompat;
  inherit (flake) inputs outPath;
  inherit (stdenv.hostPlatform) system;
  inherit (stdenv) isLinux isDarwin;
  root = importDir ./.;
  inherit (root) constants modules machines;
  scope' = root.scope { inherit lib flake; };
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
  alias = name:
    if isString name
    then arg:
      let
        cmd = if isDerivation arg then getExe arg else arg;
        pre = if any (s: hasInfix s arg) [ "&&" "||" ";" "|" "\n" ] then "" else "exec";
        post = if any (s: hasInfix s arg) [ ''"$@"'' "\n" ] then "" else ''"$@"'';
      in
      writeBashBin name "${pre} ${cmd} ${post}"
    else mapAttrs alias name;
  nixpkgsPath = inputs.nixpkgs.outPath;
  importNixpkgs = args:
    let
      helper =
        { system ? scope.system
        , config ? { }
        , overlays ? [ ]
        , rev ? null
        , sha256 ? null
        , path ? nixpkgsPath
        , owner ? "NixOS"
        , repo ? "nixpkgs"
        , src ? if sha256 != null then fetchFromGitHub { inherit owner repo rev sha256; }
          else if rev != null then fetchTree { type = "github"; inherit owner repo rev; }
          else path
        }: import src { inherit system config overlays; };
    in
    helper (
      if isPath args then { path = args; }
      else if isString args then { rev = args; }
      else if isDerivation args then { src = args; }
      else args
    );
  pathAdd = pkgs: "export PATH=${makeBinPath (toList pkgs)}:$PATH";
  flakeLastModifiedDateString = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" flake.lastModifiedDate);

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
