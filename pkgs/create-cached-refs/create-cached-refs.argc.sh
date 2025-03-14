# @cmd Generate nix files for cached paths
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
    echo "{ mkPath }:"
    for path in *;do
      if [[ $path = __sourceHash ]];then
        echo "  $path = \"$(< $path)\";"
      else
        attrName=$(echo "$path" | sed -e 's/^/"/' -e 's/\./"."/g' -e 's/$/"/')
        echo "  $attrName = mkPath $(realpath "$path");"
      fi
    done
    echo "}"
  ) > "$out/paths/$argc_tag.nix"
}

# @cmd Generate, add to cached branch, and push to origin
# @arg paths=./result
# @option --tag=
# @option --name=create-cached-refs
# @option --email=noreply@example.com
push() {
  root=$PWD

  try_push() {
    cd "$root"
    worktree=/tmp/create-cached-refs/cached
    rm -rf "$worktree"
    git worktree prune
    git fetch --prune origin
    git fetch origin cached:cached || true
    git worktree add "$worktree" --orphan || git worktree add "$worktree"
    cd "$worktree"

    "$0" generate . "$root/$argc_paths" --tag "$argc_tag"

    git add --all
    commit() {
      git -c user.name="$argc_name" -c user.email="$argc_email" commit --message cached-refs "$@"
    }
    commit --amend || commit
    git push --force-with-lease --set-upstream origin cached
    cd "$root"
    git worktree remove "$worktree"
  }

  try_push || sleep 5 && try_push
}

# @cmd
# @arg flakeref!
# @arg package
run() {
  nix $refresh
}

set -euo pipefail

refresh='--refresh'

