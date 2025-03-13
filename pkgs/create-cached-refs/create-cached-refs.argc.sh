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

# @cmd
# @arg flakeref!
# @arg package
run() {
  nix $refresh
}

# @cmd
# @arg paths=./result
# @option --tag=
push() {
  echo 'TODO push to git'
  echo "paths: $argc_paths"
  echo "tag: $argc_tag"

  # nix run github:kwbauson/create-pin-refs -- kwbauson
  # git config user.name 'Keith Bauson'
  # git config user.email 'kwbauson@gmail.com'
  # git switch --orphan pins
  # mv pins pins-dir
  # mv pins-dir/* .
  # git add --all
  # git commit --message 'publish pins'
  # git push --force --set-upstream origin pins
}

set -euo pipefail

refresh='--refresh'

