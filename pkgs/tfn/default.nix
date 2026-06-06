scope: with scope;
let
  wrapper = writeBashBin pname ''
    set -eou pipefail
    ${pathAdd [ opentofu ]}
    nixFile=${flake}/pkgs/${pname}/generate-tf-json.nix
    nix build --out-link config.tf.json --file "$nixFile" --arg configPath ./config.nix
    trap 'unlink config.tf.json' EXIT
    tofu "$@"
  '';
  opentofu = pkgs.opentofu.withPlugins (ps: [
    ps.hashicorp_google
    ps.cullenmcdermott_porkbun
    ps.integrations_github
  ]);
  paths = [
    wrapper
    terranix
    google-cloud-sdk
    opentofu
  ];
in
buildEnv { name = "${pname}-env"; inherit paths; }
