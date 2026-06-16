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
  skippedPaths = [
    [ "_module" ]
    [ "assertions" ]
    [ "home-manager" "extraSpecialArgs" ]
  ];
  traceUsage = label: (f: f null null) (fix (cont': parent: at: path: arg:
    let
      isDerivation = x: x ? outPath && x ? drvPath;
      inDerivation = isDerivation parent;
      skipDerivationAttrs = [ "type" "outputName" "outputs" "meta" ];
      cont = at: cont' arg at (path ++ [ at ]);
      trace = p: x: builtins.trace "${marker}${toJSON [label (toPathString p) x]}" arg;
    in
    # FIXME probably want to move the non-trace logic into python
    if elem path skippedPaths then arg
    else if inDerivation && at == "outPath" then trace (init path) "<derivation ${arg}>"
    else if inDerivation && elem at skipDerivationAttrs then arg
    else if isAttrs arg then mapAttrs cont arg
    else if isList arg then imap cont arg
    else trace path (toPretty { } arg)
  ));
  tracedLib = pkgs.lib.extend (final: prev: {
    traceConfigUsage = config:
      let
        inherit (config._module) args;
        inherit (args._traceConfigUsage) label path;
      in
      if args ? _traceConfigUsage
      then traceUsage label path config
      else config;
    modules = import patched-modules-nix { lib = final; };
  });
  traceConfigUsageModule = label: path: {
    _module.args._traceConfigUsage = { inherit label path; };
    _module.args.check = false;
  };
  traceConfig = label: configuration:
    let inherit (configuration.type.functor) payload; in
    (tracedLib.evalModules {
      inherit (payload) class specialArgs;
      modules = payload.modules ++ [
        (traceConfigUsageModule label [ ])
        {
          config = optionalAttrs (configuration.config ? home-manager) {
            home-manager.users = forAttrNames configuration.config.home-manager.users (name: {
              imports = [ (traceConfigUsageModule label [ "home-manager" name ]) ];
            });
          };
        }
      ];
    }).config;
  buildFlake = inputs: outputsStr: runCommand "source"
    {
      flakeNix = /* nix */ ''
        {
          inputs = {
            ${concatMapAttrsStringSep "\n    " (n: p: ''${n}.url = "path:${p}";'') inputs}
          };
          outputs = { self, ${concatMapAttrsStringSep ", " (n: _: n) inputs} }:
            ${concatStringsSep "\n    " (splitString "\n" (trim outputsStr))};
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
  mkFlake = { old, new, oldOutput, newOutput, eval }:
    buildFlake { cfg = cfg.outPath; inherit old new; } /* nix */ ''
      {
        traced = cfg.packages.${system}.${pname}.run {
          old = old.outputs.${oldOutput};
          new = new.outputs.${newOutput};
          eval = c: c.${eval};
        };
      }
    '';
  run = { old, new, eval }: foldl' (flip seq) "" [
    (eval (traceConfig "old" old))
    (eval (traceConfig "new" new))
  ];
})
