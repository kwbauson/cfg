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
    parser.add_argument("--self-run", default="${pname}.run")
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
      trace = p: x: builtins.trace "${removePrefix "trace: " traceMarker} ${label}: ${toPathString p}${equalsMarker}${x}" arg;
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
  run =
    { old
    , new
    , configurationPath
    , evalPath
    }:
    let
      configurationPath' = splitString "." configurationPath;
      evalPath' = splitString "." evalPath;
      getConfig = label: ref: traceConfig label (getAttrFromPath configurationPath' (getFlake ref).outputs);
      getOutput = label: ref: getAttrFromPath evalPath' (getConfig label ref);
    in
    seq (seq (getOutput oldLabel old) (getOutput newLabel new)) "";
})
