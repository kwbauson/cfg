config: with config.lib; (lib: { inherit lib; }) (builtins // {
  optional = cond: elem: if cond then [ elem ] else [ ];
  nameValuePair = name: value: { inherit name value; };
  mapAttrsToList = f: attrs:
    map (name: f name attrs.${name}) (attrNames attrs);
  reverseList = xs:
    let l = length xs; in genList (n: elemAt xs (l - n - 1)) l;
  findFirst = pred: default: list:
    let found = filter pred list;
    in if found == [ ] then default else head found;
  filterAttrs = pred: set: listToAttrs (concatMap
    (name:
      let v = set.${name}; in if pred name v then [ (nameValuePair name v) ] else [ ])
    (attrNames set)
  );
  hasSuffix = suffix: content:
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent content == suffix;
  removeSuffix = suffix: str:
    let
      sufLen = stringLength suffix;
      sLen = stringLength str;
    in
    if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str
    then substring 0 (sLen - sufLen) str
    else str;
  hasAttrs = xs: attrs: all (x: hasAttr x attrs) xs;
  import' = path:
    let importEntry = entry: type:
      if type == "directory" then
        let
          mkEntry = file: type: {
            name = removeSuffix ".nix" file;
            value = importEntry (entry + "/${file}") type;
          };
          entries = listToAttrs (mapAttrsToList mkEntry (readDir entry));
          default = entries.default or { };
        in
        if isAttrs default then default // entries
        else if isFunction default then entries // { __functor = _: default; __functionArgs = functionArgs default; }
        else default
      else if hasSuffix ".nix" entry then import entry
      else entry;
    in
    importEntry path "directory";

  tryFile = p: findFirst pathExists null
    (reverseList (map (s: s + "/${p}") config.sources));
  tryImport = p: nul:
    let f = tryFile p; in if f == null then nul else import f;
})
