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

  hasFile = p: tryFile p != null;
  tryFile = p: findFirst pathExists null
    (reverseList (map (s: s + "/${p}") config.sources));
  tryRead = p: if tryFile p == null then "" else readFile (tryFile p);
  tryImport = p: nul:
    let f = tryFile p; in if f == null then nul else import f;
})
