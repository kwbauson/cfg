{ lib
, writers
, pkgs
, runCommandLocal
, stdenv
, nix

  # required configuration
, configdiffNix
, configdiffNixAttr
, configdiffFlake ? configdiffNix
, configdiffFlakeAttr ? configdiffNixAttr

  # optional configuration
, skipPatterns ? [
    [ "_module" ]
    [ "assertions" ]
    [ "warnings" ]
    [ "home-manager" "extraSpecialArgs" ]
    [ "home-manager" "users" null "_module" ]
    [ "home-manager" "users" null "assertions" ]
    [ "home-manager" "users" null "warnings" ]
  ]
, skipDerivationAttrs ? [ "type" "outputName" "outputs" "meta" ]
}:
let
  inherit (lib)
    any isString concatMapStringsSep length foldl' fix zipLists toJSON init
    elem isAttrs mapAttrs isList imap optionalAttrs concatStringsSep
    hasAttrByPath getAttrFromPath setAttrByPath splitString optionalString flip
    seq trim concatMapAttrsStringSep id isFunction
    ;
  inherit (lib.generators) toPretty;
  inherit (lib.strings) escapeNixIdentifier;
  inherit (stdenv.hostPlatform) system;

  marker = "TRACE_CONFIG";
  traceMarker = "trace: ${marker}";
  extraParser = /* python */ ''
    internal_help = "internal, do not use"
    parser.add_argument("--self-nix", default="${configdiffNix}", help=internal_help)
    parser.add_argument("--self-attr", default="${configdiffNixAttr}", help=internal_help)
    parser.add_argument("--marker", default="${traceMarker}", help=internal_help)
  '';
  patched-modules-nix = runCommandLocal "patched-modules.nix" { } ''
    cp ${pkgs.path}/lib/modules.nix $out
    patch $out ${./eval-modules-traced.patch}
  '';
  toPathStringPart = n: if isString n then escapeNixIdentifier n else "*";
  toPathString = path: concatMapStringsSep "." toPathStringPart path;
  pathMatches = path: pattern:
    length path == length pattern &&
    foldl' (acc: { fst, snd }: snd == null || fst == snd) true (zipLists path pattern);
  traceUsage = (f: f null null) (fix (cont': parent: at: args@{ label, path }: arg:
    let
      isDerivation = x: x ? outPath && x ? drvPath;
      inDerivation = isDerivation parent;
      cont = at: cont' arg at (args // { path = path ++ [ at ]; });
      trace = p: x: builtins.trace "${marker}${toJSON [label (toPathString p) x]}" arg;
    in
    # FIXME probably want to move the non-trace logic into python
    if any (pathMatches path) skipPatterns then arg
    else if inDerivation && at == "outPath" then trace (init path) "<derivation ${arg}>"
    else if inDerivation && elem at skipDerivationAttrs then arg
    else if isAttrs arg then mapAttrs cont arg
    else if isList arg then imap cont arg
    else trace path (toPretty { } arg)
  ));
  tracedLib = lib: lib.extend (final: prev: {
    traceConfigUsage = config:
      let args = config._module.args; in
      if args ? _traceConfigUsage
      then traceUsage args._traceConfigUsage config
      else config;
    modules = import patched-modules-nix { lib = final; };
  });
  getLib = configuration: (configuration.extendModules {
    modules = [
      ({ lib, ... }: {
        _module.args._traceConfigUsage.lib = lib;
      })
    ];
  })._module.args._traceConfigUsage.lib;
  traceConfig = args: label:
    let
      configuration = args.${label};
      mkModule = path: {
        _module.args._traceConfigUsage = { inherit label path; };
        _module.args.check = false;
      };
      mkNested = path: f: optionalAttrs
        (hasAttrByPath path configuration.options)
        (setAttrByPath path (f path (getAttrFromPath path configuration.config)));
      inherit (configuration.type.functor) payload;
    in
    ((tracedLib (getLib configuration)).evalModules {
      inherit (payload) class specialArgs;
      modules = payload.modules ++ [
        (args."${label}Module" or { })
        (mkModule [ ])
        (mkNested [ "home-manager" "users" ] (p: mapAttrs (n: _: mkModule (p ++ [ n ]))))
      ];
    }).config;
  indent = i: s: concatStringsSep "\n${i}" (splitString "\n" (trim s));
  buildFlake = inputs: outputsStr: runCommandLocal "source"
    {
      flakeNix = /* nix */ ''
        {
          inputs = {
            ${concatMapAttrsStringSep "\n    " (n: p: ''${n}.url = "path:${p}";'') inputs}
          };
          outputs = { self, ${concatMapAttrsStringSep ", " (n: _: n) inputs} }:
            ${indent "    " outputsStr};
        }
      '';
      nativeBuildInputs = [ nix ];
      passAsFile = [ "flakeNix" ];
    }
    ''
      export HOME=$PWD
      mkdir $out
      cd $out
      cp $flakeNixPath flake.nix
      cat flake.nix
      nix --extra-experimental-features 'nix-command flakes' flake lock
    '';
  tryEvalOutput = cfg: config:
    if elem cfg.class or null [ "nixos" "darwin" ] then config.system.build.toplevel.outPath
    else if cfg.class or null == "homeManager" then config.home.activationPackage.outPath
    else if hasAttrByPath [ "meta" "nixvimInfo" ] cfg.options then config.build.package.outPath
    else throw "unknown configuration type, please pass `--eval PATH`";
  mkFlake =
    { old
    , new
    , oldOutput
    , newOutput
    , eval ? null
    , oldModule ? null
    , newModule ? null
    }@args:
    let
      setOutputString = ref: out: indent "    " /* nix */ ''
        ${ref} = ${ref}.outputs.${out} or
          ${ref}.outputs.packages.${system}.${out} or
          ${ref}.outputs.legacyPackages.${system}.${out};
      '';
      optionalRunArg = name: f: optionalString (args.${name} or null != null)
        "${name} = ${if isFunction f then f args.${name} else f};";
    in
    buildFlake { configdiff = configdiffFlake; inherit old new; } /* nix */ ''
      {
        traced = configdiff.packages.${system}.${configdiffFlakeAttr}.run {
          ${setOutputString "old" oldOutput}
          ${setOutputString "new" newOutput}
          ${optionalRunArg "oldModule" id}
          ${optionalRunArg "newModule" id}
          ${optionalRunArg "eval" "_: c: c.${eval}"}
        };
      }
    '';
  run = { old, new, eval ? tryEvalOutput, ... }@args: foldl' (flip seq) "" [
    (eval old (traceConfig args "old"))
    (eval new (traceConfig args "new"))
  ];
in
(writers.writePython3Bin "configdiff"
  {
    doCheck = false;
    libraries = ps: [ ps.termcolor ];
  }
  (lib.replaceString "# NIX_EXTRA_PARSER" extraParser (lib.readFile ./main.py))
).overrideAttrs { passthru = { inherit mkFlake run; }; }
