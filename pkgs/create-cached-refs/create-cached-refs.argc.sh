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
# @option --name=
# @option --email=
push() {
  echo 'TODO push to git'
  echo "paths: $argc_paths"
  echo "tag: $argc_tag"
  echo "name: $argc_name"
  echo "email: $argc_email"

  g() {
    git -c user.name="$argc_name" -c user.email="$argc_email" "$@"
  }

  root=$PWD

  try_push() {
    cd "$root"
    worktree=/tmp/create-cached-refs/cached
    g fetch origin cached:cached || true
    g worktree add "$worktree" --orphan || g worktree add "$worktree"
    cd "$worktree"

    touch a # TODO

    g add --all
    g commit --amend --message cached-refs || git commit --message cached-refs
    g push --force-with-lease --set-upstream origin cached
    cd "$root"
    g worktree remove "$worktree"
  }

  try_push || (sleep 5 && try_push)
}

set -euo pipefail

refresh='--refresh'

