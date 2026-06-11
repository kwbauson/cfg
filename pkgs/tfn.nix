scope: with scope;
(writeBashBin pname ''
  set -eou pipefail
  outPath=$(nix build --no-link --print-out-paths --file ${cfg} tfn.build --arg configPath ./config.nix)
  trap 'unlink config.tf.json' EXIT
  ln -s "$outPath"/config.tf.json config.tf.json
  "$outPath"/bin/tofu "$@"
'').overrideAttrs {
  passthru.checkScript = /* bash */ ''
    echo '{}' > config.nix
    tfn --version
  '';
  passthru.baseModules = [
    "${terranix.src}/modules"
    "${terranix.src}/core/terraform-options.nix"
    ({ config, ... }: {
      options.plugins = mkTypeOption (with types;
        coercedTo
          (functionTo (coercedTo (listOf package) toList package))
          (f: toList (f opentofu.plugins))
          (listOf package)
      );
      config.terraform = mkMerge (forEach config.plugins (plugin:
        let
          source = removePrefix "https://registry.terraform.io/providers/" plugin.homepage;
          name = last (splitString "/" source);
        in
        { required_providers.${name}.source = mkDefault source; }
      ));
    })
  ];
  passthru.build =
    { configPath }:
    let
      scope' = fix (final: with final; scope.mergeAttrsList [
        scope
        (scope.fix (self: import "${scope.terranix.src}/core/helpers.nix" pkgs self lib))
        {
          mkRef = ref: mkOption { type = types.str; default = tf.ref ref; };
        }
      ]);
    in
    with scope';
    let
      specialArgs = { scope = scope'; };
      modules = package.baseModules ++ [ configPath ];
      unsanitized = evalModules { inherit specialArgs modules; };
      core = import "${terranix.src}/core/default.nix" {
        inherit pkgs modules;
        extraArgs = specialArgs;
      };
    in
    buildEnv {
      name = "${pname}-runtime-env";
      paths = [
        (opentofu.withPlugins (_: unsanitized.config.plugins))
        (writeTextDir "config.tf.json" (toJSON core.config))
      ];
      passthru = { inherit unsanitized; };
    };
}
