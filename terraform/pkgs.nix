scope: with scope;
[
  (writeBashBin "tfn" ''
    set -eou pipefail
    terranix > config.tf.json
    trap 'unlink config.tf.json' EXIT
    tofu "$@"
  '')
  terranix
  google-cloud-sdk
  (opentofu.withPlugins (ps: [
    ps.hashicorp_google
    ps.cullenmcdermott_porkbun
  ]))
]
