{ scope, ... }: with scope;
{
  included-packages = { inherit git-trim gh git-ignore git-fuzzy; };
  programs.git = with {
    gs = text:
      let
        script = writeBash "git-script" ''
          set -eo pipefail
          cd -- ''${GIT_PREFIX:-.}
          ${text}
        '';
      in
      "! ${script}";
    tmpGitIndex = ''
      export GIT_INDEX_FILE=$(mktemp)
      index=$(git rev-parse --show-toplevel)/.git/index
      [[ -e $index ]] && cp "$index" "$GIT_INDEX_FILE" || rm "$GIT_INDEX_FILE"
      trap 'rm -f "$GIT_INDEX_FILE"' EXIT
    '';
    gitDf = "git -c core.pager='${exe delta} --dark' diff";
  }; {
    enable = true;
    package = gitFull;
    aliases = {
      v = gs "nvim '+ Git | only'";
      a = "add -A";
      br = gs ''
        esc=$'\e'
        reset=$esc[0m
        red=$esc[31m
        yellow=$esc[33m
        green=$esc[32m
        git -c color.ui=always branch -vv "$@" | sed -E \
          -e "s/: (gone)]/: $red\1$reset]/" \
          -e "s/[:,] (ahead [0-9]*)([],])/: $green\1$reset\2/g" \
          -e "s/[:,] (behind [0-9]*)([],])/: $yellow\1$reset\2/g"
        git --no-pager stash list
      '';
      brf = gs "git f --quiet && git br";
      default = gs "git symbolic-ref refs/remotes/origin/HEAD | sed s@refs/remotes/origin/@@";
      branch-name = "rev-parse --abbrev-ref HEAD";
      gone = gs ''git branch -vv | sed -En "/: gone]/s/^..([^[:space:]]*)\s.*/\1/p"'';
      rmg = gs ''
        gone=$(git gone)
        echo About to remove branches: $gone
        read -n1 -p "Continue? [y/n] " continue
        echo
        [[ $continue = y ]] && git branch -D $gone
      '';
      ca = gs ''git a && git ci "$@"'';
      cap = gs ''git ca "$@" && git p'';
      capr = gs ''git ca "$@" && git pr'';
      ci = gs ''
        if [[ -t 0 && -t 1 ]];then
          git commit -v "$@"
        else
          echo unable to run "'git ci'" without a tty
          exit 1
        fi
      '';
      co = "checkout";
      cod = gs ''git co $(git default) -- "$@"'';
      cob = gs ''git co $(git merge-base ''${1:-origin/$(git default)} HEAD) -- "$@"'';
      cof = gs ''br=$(git branch --color=always -av | fzf | sed -e 's/^..//' -e 's@remotes/origin/@@' | awk '{ print $1 }') && git switch "$br"'';
      df = gs ''
        ${tmpGitIndex}
        git add -A
        ${gitDf} --staged "$@" || true
      '';
      dfb = gs ''git df $(git merge-base ''${1:-origin/$(git default)} HEAD)'';
      dft = gs ''
        old=$PWD
        current=$(git rev-parse HEAD)
        branch=$(git tracking)
        dir=$(mktemp --tmpdir -d dft-XXXXX)
        patch=$(mktemp --tmpdir dft-XXXXX)
        git add -A
        git diff --staged > "$patch"
        git worktree add --quiet --detach "$dir"
        cd "$dir"
        trap 'cd "$old" && git worktree remove "$dir" && rm "$patch"' EXIT
        git apply --allow-empty "$patch"
        git add -A
        git commit --message tmp --quiet --allow-empty
        git merge --quiet --no-edit "$branch"
        ${gitDf} "$current.." || true
      '';
      f = "fetch --all";
      g = gs "git f && git mt";
      gr = gs "git pull $(git tracking | tr / ' ') --rebase --autostash";
      gd = gs "git fetch origin $(git default):$(git default)";
      md = gs "git merge $(git default)";
      mt = gs "git merge --ff-only";
      gmd = gs "git gd && g md";
      rmo = gs "git branch -D $1 && git push origin --delete $1";
      hidden = gs "git ls-files -v | grep '^S' | cut -c3-";
      hide = gs ''touch "$@" && git add -N "$@" && git update-index --skip-worktree --assume-unchanged "$@"'';
      unhide = "update-index --no-skip-worktree --no-assume-unchanged";
      l = "log";
      lg = gs "git lfo && git mt";
      lft = gs ''git f && git log HEAD..$(git tracking) --no-merges --reverse'';
      p = "put";
      pr = gs "git put && gh pr create --body ''";
      fp = gs ''
        set -e
        git fetch
        loga=$(mktemp)
        logb=$(mktemp)
        git log $(git tracking) > "$loga"
        git log > "$logb"
        ${exe delta} "$loga" "$logb" || true
        rm "$loga" "$logb"
        read -n1 -p "Continue? [y/n] " continue
        echo
        [[ $continue = y ]] && git put --force
      '';
      tracking = gs "git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null";
      put = gs ''
        tracking=$(git tracking || true)
        if [[ -z $tracking ]];then
          git push --set-upstream origin $(git branch-name) "$@"
        else
          read remote branch < <(echo "$tracking" | tr / ' ')
          git push "$remote" HEAD:"$branch" "$@"
        fi
      '';
      rt = gs ''git reset --hard $(git tracking) "$@"'';
      rh = gs ''git reset --hard ''${1:-HEAD} && git clean -d'';
      s = gs ''
        git br
        git -c color.status=always status | grep --color=never -Ev \
          -e '^$' \
          -e '^On branch' \
          -e '^Your branch is' \
          -e '^\s+\(use "git' \
          -e '^no changes added to commit' \
          -e '^nothing to commit' || true
      '';
      sf = gs ''git f --quiet && git s "$@"'';
    };
    inherit userName userEmail;
    extraConfig = {
      clean.requireForce = false;
      checkout.defaultRemote = "origin";
      core.autocrlf = "input";
      core.hooksPath = "/dev/null";
      fetch.prune = true;
      pager.branch = false;
      push.default = "simple";
      pull.rebase = false;
      rebase.instructionFormat = "(%an) %s";
      init.defaultBranch = "main";
    };
  };
}
