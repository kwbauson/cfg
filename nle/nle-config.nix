config: with config.lib; {
  lib = builtins // {
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
  };

  sources = [ ];

  nixpkgs = {
    config = tryImport "config.nix" { };
    overlays = [ ]; # tryImport "overlays.nix" [ ];
    pkgs = import config.nixpkgs.path {
      inherit (config.nixpkgs) system config overlays;
    };
  };

  bundler = {
    enable = all hasFile [ "Gemfile" "Gemfile.lock" "gemset.nix" ];
    build = config.nixpkgs.pkgs.bundlerEnv;
    settings = {
      name = "bundler-env";
      gemfile = tryFile "Gemfile";
      lockfile = tryFile "Gemfile.lock";
      gemset = tryFile "gemset.nix";
    };
  };

  outputs =
    let build = n: cfg:
      if cfg.enable or false then (cfg.build cfg.settings).overrideAttrs (_: { name = "${n}-env"; }) else null;
    in filterAttrs (n: v: v != null) (mapAttrs build (config // { outputs = null; paths = null; }));
  paths._replace = attrValues config.outputs;
}
