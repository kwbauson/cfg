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
      ci = gs ''
        if [[ -t 0 && -t 1 ]];then
          git commit -v "$@"
        else
          echo unable to run "'git ci'" without a tty
          exit 1
        fi
      '';
      co = "checkout";
      cod = gs ''git co $(git default) "$@"'';
      df = gs ''
        ${tmpGitIndex}
        git add -A
        git -c core.pager='${exe delta} --dark' diff --staged "$@" || true
      '';
      dfd = gs ''git df $(git merge-base origin/$(git default) HEAD)'';
      dfo = gs ''git f && git df "origin/''${1:-$(git branch-name)}"'';
      f = "fetch --all";
      g = gs "git f && git mo";
      gr = gs "git pull origin $(git branch-name) --rebase --autostash";
      gd = gs "git fetch origin $(git default):$(git default)";
      md = gs "git merge $(git default)";
      mo = gs "git merge --ff-only";
      gmd = gs "git gd && g md";
      rmo = gs "git branch -D $1 && git push origin --delete $1";
      hidden = gs "git ls-files -v | grep '^S' | cut -c3-";
      hide = gs ''touch "$@" && git add -N "$@" && git update-index --skip-worktree --assume-unchanged "$@"'';
      unhide = "update-index --no-skip-worktree --no-assume-unchanged";
      l = "log";
      lg = gs "git lfo && git mo";
      lfo = gs ''git f && git log HEAD..origin/$(git branch-name) --no-merges --reverse'';
      p = "put";
      fp = gs ''
        set -e
        git fetch
        loga=$(mktemp)
        logb=$(mktemp)
        git log origin/$(git branch-name) > "$loga"
        git log > "$logb"
        ${exe delta} "$loga" "$logb" || true
        rm "$loga" "$logb"
        read -n1 -p "Continue? [y/n] " continue
        echo
        [[ $continue = y ]] && git put --force-with-lease
      '';
      tracking = gs "git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null";
      put = gs ''
        tracking=$(git tracking)
        if [[ -z $tracking ]];then
          git push --set-upstream origin $(git branch-name) "$@"
        else
          read remote branch < <(echo "$tracking" | tr / ' ')
          git push "$remote" HEAD:"$branch" "$@"
        fi
      '';
      ro = gs ''git reset --hard origin/$(git branch-name) "$@"'';
      ros = gs "git stash && git ro && git stash pop";
      rt = gs ''git reset --hard ''${1:-HEAD} && git clean -d'';
      s = gs "git br && git -c color.status=always status | grep -E --color=never '^\\s\\S|:$' || true";
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
