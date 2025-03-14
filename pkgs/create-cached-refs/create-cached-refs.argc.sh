set -euo pipefail

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
    echo "{"
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

# @cmd Wraps nix to use cached if it exists
# @alias nix
# @arg cmd!
# @arg flakeref!
# @arg package=default
# @arg _rest~
wrapped_nix() {
  shift
  shift
  [[ -n ${1:-} ]] && shift || true

  if [[ -e $argc_flakeref ]];then
    fetchExpr="fetchGit $(realpath "$argc_flakeref")"
  else
    fetchExpr="fetchTree (parseFlakeRef \"$argc_flakeref\")"
  fi
  sourceHash=$(nix --refresh eval --raw --impure --expr "with builtins; substring 11 32 ($fetchExpr).outPath")

  cachedFlakeRef=$argc_flakeref?ref=origin/cached
  cachedSourceHash=$(nix eval --raw "$cachedFlakeRef#__sourceHash")
  hasPackage=$(
    nix eval "$cachedFlakeRef#packages" --impure --apply \
      "with builtins; x: let pkgs = x.\${currentSystem}; in with pkgs.lib; hasAttrByPath (splitString \".\" \"$argc_package\") pkgs"
  )

  if [[ $sourceHash = $cachedSourceHash && $hasPackage = true ]];then
    flakeref=$cachedFlakeRef
  else
    flakeref=$argc_flakeref
  fi

  nix "$argc_cmd" "$flakeref#$argc_package" "$@"
}
