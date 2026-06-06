args: args.lib.fix (scope: with scope;
args.lib.generators // args.formats or { } //
args.writers or { } // args //
args.flake.inputs or { } // args.flake or { } //
builtins // args.lib // {
  inherit (import ./. { inherit system; }) getFlakeCompat;
  inherit (stdenv.hostPlatform) system;
  inherit (stdenv) isLinux isDarwin;
  root = importDir ./.;
  inherit (root) constants modules machines;
  inherit (pkgs) fetchurl;
  scope' = root.scope { inherit lib flake; };
  mapAttrNames = f: mapAttrs (n: _: f n);
  mapAttrValues = f: mapAttrs (_: v: f v);
  forAttrs = flip mapAttrs;
  forAttrs' = flip mapAttrs';
  forAttrNames = flip mapAttrNames;
  forAttrValues = flip mapAttrValues;
  forAttrValuesFlagged = attrs: name: forAttrValues (filterAttrs (_: getAttr name) attrs);
  mergeAttrsList = foldl' mergeAttrs { };
  mergeAttrsListWithFunc = f: foldl' (mergeAttrsWithFunc f) { };
  recursiveUpdateList = foldl' recursiveUpdate { };
  readDirPaths = dir: mapAttrNames (n: dir + "/${n}") (readDir dir);
  filterDirPaths = p: dir: filterAttrs p (readDirPaths dir);
  forDirPaths = dir: f: mapAttrs f (readDirPaths dir);
  forDirPathsWith = dir: name: f:
    mapAttrs
      (n: p: f n (p + "/${name}"))
      (filterDirPaths (_: p: pathExists (p + "/${name}")) dir);
  pipeValue = xs: pipe null ([ (const (head xs)) ] ++ (tail xs));

  importDir = dir: pipe dir [
    readDirPaths
    attrsToList
    (filter (x: pathIsDirectory x.value || hasSuffix ".nix" x.name))
    (filter (x: x.name != "default.nix"))
    (map (x: nameValuePair (removeSuffix ".nix" x.name) x.value))
    listToAttrs
    (mapAttrValues (p: if pathExists (p + "/default.nix") || !pathIsDirectory p then import p else importDir p))
    (mapAttrValues (x: if isFunction x && (functionArgs x == { _auto = false; scope = false; }) then x { _auto = true; inherit scope; } else x))
  ];

  inherit (writers) writeBash writeBashBin;
  ap = x: f: f x;
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
  nixpkgs-branch = let urlParts = splitString "/" (import ./flake.nix).inputs.nixpkgs.url; in
    if length urlParts == 3 then elemAt urlParts 2 else "master";
  excludeLines = f: text: concatStringsSep "\n" (filter (x: !f x) (splitString "\n" text));
  unpack = src: stdenv.mkDerivation {
    src = if src ? url && src ? sha256 then fetchurl { inherit (src) url sha256; } else src;
    name = src.name or "source";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mv $PWD $out
    '';
  };
  runBin = name: script: runCommand
    name
    { } ''
    mkdir -p $out/bin
    ${getExe (writeBashBin "script" script)} > $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
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
        { system ? pkgs.stdenv.hostPlatform.system
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
  buildDir = paths:
    let
      copyCommand = p: "cp -r ${builtins.path { name = "source"; path = p; }} $out/${baseNameOf p}";
      cmds = concatMapStringsSep "\n" copyCommand (toList paths);
    in
    runCommand "source" { } "mkdir $out\n${cmds}";
  buildDirExcept = path: except: buildDir (map (x: path + ("/" + x)) (
    filter
      (x: ! any (y: y == x) (toList except))
      (attrNames (readDir path))
  ));
  pathAdd = pkgs: "export PATH=${makeBinPath (toList pkgs)}:$PATH";
  echo = text: writeBash "echo-script" ''echo "$(< ${writeText "text" text})"'';
  attrsToList = mapAttrsToList (name: value: { inherit name value; });
  joinStrings = sep: f: g: concatMapStringsSep sep (s: if isString s then f s else g (head s) (lib.last s));
  joinLines = joinStrings "\n";
  override = x: y:
    if y ? _replace then y._replace
    else if y ? _append then x + y._append
    else if isList x && isList y then x ++ y
    else if isDerivation x && isPath y && pathExists y then y
    else if isDerivation x && isPath y && !pathExists y then x
    else if isDerivation x && isAttrs y then
      override x.overrideAttrs y
    else if isFunction x && isAttrs y then
      x (attrs: mapAttrs (n: v: if hasAttr n attrs then override attrs.${n} v else v) y)
    else if isAttrs x && isAttrs y then
      mapAttrs (n: v: if hasAttr n y then override v y.${n} else v) (y // x)
    else y;
  mapDirEntries = f: dir: listToAttrs (filter (x: x != null && x != { }) (mapAttrsToList f (readDir dir)));
  flakeLastModifiedDateString = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" flake.lastModifiedDate);
})
