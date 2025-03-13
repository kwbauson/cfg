# @cmd Generate pin nix files
# @alias g
# @arg out! Output location
# @arg paths=./result Directory of paths to be pinned
# @option --tag=default Name for generated paths file
generate() {
  out=$PWD/$argc_out
  paths=$argc_paths

  mkdir -p "$out"/paths
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
  ) > "$out/paths/$argc_tag.nix"
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

  root=$PWD

  try_push() {
    cd "$root"
    worktree=/tmp/create-cached-refs/cached
    rm -rf "$worktree"
    git worktree prune
    git fetch origin cached:cached || true
    git worktree add "$worktree" --orphan || git worktree add "$worktree"
    cd "$worktree"

    "$0" generate . "$root/$argc_paths" --tag "$argc_tag"

    git add --all
    commit() {
      git commit --message cached-refs --author "$argc_name <$argc_email>" "$@"
    }
    commit --amend || commit
    git push --force-with-lease --set-upstream origin cached
    cd "$root"
    git worktree remove "$worktree"
  }

  try_push || (sleep 5 && try_push)
}

set -euo pipefail

refresh='--refresh'

