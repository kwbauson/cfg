scope: with scope;
let
  traceMarker = "trace: CONFIG_ACCESSED";
  traceMarkerOld = "${traceMarker} ${oldLabel}: ";
  traceMarkerNew = "${traceMarker} ${newLabel}: ";
  oldLabel = "OLD";
  newLabel = "NEW";
  equalsMarker = " CONFIG_EQUALS ";
  extraParser = /* python */ ''
    parser.add_argument("--trace-marker", default="${traceMarker}")
    parser.add_argument("--trace-marker-old", default="${traceMarkerOld}")
    parser.add_argument("--trace-marker-new", default="${traceMarkerNew}")
    parser.add_argument("--equals-marker", default="${equalsMarker}")
    parser.add_argument("--self-nix", default="${cfg}")
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
  ];
  traceAccess' = label: (f: f false null [ ] null) (fix (cont': inDerivation: parent: path: at: arg:
    let
      cont = at: cont' inDerivation arg (path ++ [ at ]) at;
      marker = "${traceMarker} ${label}: ";
      mark = s: concatStringsSep ("\n" + marker) (splitString "\n" s);
      trace = p: x: builtins.trace "${removePrefix "trace: " marker}${toPathString p}${equalsMarker}${mark x}" arg;
    in
    # FIXME probably want to move the non-trace logic into python
    if elem path skippedPaths then arg
    else if inDerivation && at == "outPath" then
      trace
        (
          if last (init path) == parent.outputName then init (init path) else init path
        ) "<derivation ${arg}>"
    else if inDerivation && elem at [ "meta" "type" ] then arg
    else if isAttrs arg then
      if arg ? outPath && arg ? drvPath then mapAttrs (n: cont' true arg (path ++ [ n ]) n) arg
      else mapAttrs cont arg
    else if isList arg then imap cont arg
    else trace path (toPretty { } arg)
  ));
  evalModulesTraced = label: (import patched-modules-nix {
    lib = inputs.nixpkgs.lib // {
      traceAccess = traceAccess' label;
    };
  }).evalModules;
  traceConfig = label: configuration:
    let inherit (configuration.type.functor) payload; in
    (evalModulesTraced label {
      inherit (payload) class specialArgs;
      modules = [{ _module.args.check = false; }] ++ payload.modules;
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
  mkFlake = { old, new, configuration, eval }: buildFlake { cfg = cfg.outPath; inherit old new; } /* nix */ ''
    {
      traced = cfg.packages.${system}.${pname}.run {
        old = old.outputs.${configuration};
        new = new.outputs.${configuration};
        eval = c: c.${eval};
      };
    }
  '';
  run = { old, new, eval }: foldl' (flip seq) "" [
    (eval (traceConfig oldLabel old))
    (eval (traceConfig newLabel new))
  ];
})
