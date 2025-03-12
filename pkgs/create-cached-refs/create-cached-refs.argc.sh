# @cmd Generate pin nix files
# @alias g gen
# @arg out! Output pins location
# @arg paths=./result Directory of paths to be pinned
# @option --tag=default Optional suffix for generated pins file
generate() {
  out=$PWD/$argc_out
  paths=$argc_paths

  mkdir -p "$out"/pins
  cp --no-preserve=mode $TEMPLATE_FLAKE "$out"/flake.nix
  cp --no-preserve=mode $TEMPLATE_DEFAULT "$out"/default.nix

  cd "$paths"
  (
    echo "{ storePath }:"
    for path in *;do
      attrName=$(echo "$path" | sed -e 's/^/"/' -e 's/\./"."/g' -e 's/$/"/')
      echo "  $attrName = storePath $(realpath "$path");"
    done
    echo "}"
  ) > "$out/pins/$argc_tag.nix"
}

# @cmd Pack pins into a tarball that nix can read over http
# @arg output=pins.tar.gz
# @arg paths=./result Directory of paths to be pinned
pack() {
  out=$(mktemp -d)
  generate "$out" "$2"
  tar czf "$1" "$out"
  rm -r "$out"
}

# @cmd
# @arg flakeref!
# @arg package
run() {
  nix $refresh
}



set -euo pipefail

refresh='--refresh'

