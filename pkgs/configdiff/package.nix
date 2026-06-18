scope: with scope;
let
  marker = "TRACE_CONFIG";
  traceMarker = "trace: ${marker}";
  extraParser = /* python */ ''
    internal_help = "internal, do not use"
    parser.add_argument("--self-nix", default="${cfg}", help=internal_help)
    parser.add_argument("--marker", default="${traceMarker}", help=internal_help)
  '';
in
(writePython3Bin pname
  {
    doCheck = false;
    libraries = [ python3.pkgs.termcolor ];
  }
  (replaceString "# NIX_EXTRA_PARSER" extraParser (readFile ./main.py))
).overrideAttrs (final: prev: with final.passthru; (x: { passthru = x; meta.includePackage = true; }) {
  patched-modules-nix = runCommand "patched-modules.nix" { } ''
    cp ${nixpkgsPath}/lib/modules.nix $out
    patch $out ${./eval-modules-traced.patch}
  '';
  toPathStringPart = n: if isString n then strings.escapeNixIdentifier n else "*";
  toPathString = path: concatMapStringsSep "." toPathStringPart path;
  skipPatterns = [
    [ "_module" ]
    [ "assertions" ]
    [ "warnings" ]
    [ "home-manager" "extraSpecialArgs" ]
    [ "home-manager" "users" null "_module" ]
    [ "home-manager" "users" null "assertions" ]
    [ "home-manager" "users" null "warnings" ]
  ];
  pathMatches = path: pattern:
    length path == length pattern &&
    foldl' (acc: { fst, snd }: snd == null || fst == snd) true (zipLists path pattern);
  traceUsage = (f: f null null) (fix (cont': parent: at: args@{ label, path }: arg:
    let
      isDerivation = x: x ? outPath && x ? drvPath;
      inDerivation = isDerivation parent;
      skipDerivationAttrs = [ "type" "outputName" "outputs" "meta" ];
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
    modules = toList ({ lib, ... }: {
      _module.args._traceConfigUsage.lib = lib;
    });
  })._module.args._traceConfigUsage.lib;
  traceConfig = label: configuration:
    let
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
        (mkModule [ ])
        (mkNested [ "home-manager" "users" ] (p: mapAttrNames (n: mkModule (p ++ [ n ]))))
      ];
    }).config;
  indent = i: s: concatStringsSep "\n${i}" (splitString "\n" (trim s));
  buildFlake = inputs: outputsStr: runCommand "source"
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
  setOutputString = ref: out: indent "    " /* nix */ ''
    ${ref} = ${ref}.outputs.${out} or
      ${ref}.outputs.packages.${system}.${out} or
      ${ref}.outputs.legacyPackages.${system}.${out};
  '';
  mkFlake = { old, new, oldOutput, newOutput, eval ? null }:
    buildFlake { cfg = cfg.outPath; inherit old new; } /* nix */ ''
      {
        traced = cfg.packages.${system}.${pname}.run {
          ${setOutputString "old" oldOutput}
          ${setOutputString "new" newOutput}
          ${optionalString (eval != null) /* nix */ "eval = _: c: c.${eval};"}
        };
      }
    '';
  run = { old, new, eval ? tryEvalOutput }: foldl' (flip seq) "" [
    (eval old (traceConfig "old" old))
    (eval new (traceConfig "new" new))
  ];
})
