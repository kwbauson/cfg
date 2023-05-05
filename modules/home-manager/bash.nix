{ config, scope, machine-name, isNixOS, ... }: with scope;
{
  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      completion-query-items = -1;
      expand-tilde = false;
      match-hidden-files = false;
      mark-symlinked-directories = true;
      page-completions = false;
      skip-completed-text = true;
      colored-stats = true;
      keyseq-timeout = 0;
      bell-style = false;
      show-mode-in-prompt = true;
      revert-all-at-newline = true;
      vi-ins-mode-string = "\\1\\e[6 q\\2";
      vi-cmd-mode-string = "\\1\\e[2 q\\2";
    };
    bindings = {
      "\\C-p" = "history-search-backward";
      "\\C-n" = "history-search-forward";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
      "\\C-d" = "possible-completions";
      "\\C-l" = "complete";
      "\\C-f" = "complete-filename";
      "\\C-e" = "complete-command";
      "\\C-a" = "insert-completions";
      "\\C-k" = "kill-whole-line";
      "\\C-w" = ''" \edba\b"'';
      "\\t" = "menu-complete";
      "\\e[Z" = "menu-complete-backward";
    };
  };
  programs.bash = {
    enable = true;
    inherit (config.home) sessionVariables;
    historyFileSize = -1;
    historySize = -1;
    shellAliases = {
      l = "ls -lh";
      ll = "l -a";
      ls = "ls --color=auto --group-directories-first";
      file = "file -s";
      sudo = "sudo --preserve-env=SSH_CLIENT";
      su = "sudo su";
      grep = "grep --color -I";
      rg = "rg --color=always -S --hidden --no-require-git --glob '!/.git/'";
      ncdu = "ncdu --color dark -ex";
      wrun = "watchexec --debounce 50 --no-shell --clear --restart --signal SIGTERM -- ";
      root-symlinks = with {
        paths = words ".bash_profile .bashrc .inputrc .nix-profile .profile .config .local";
      }; "sudo ln -sft /root ${config.home.homeDirectory}/{${concatStringsSep "," paths}}";
      qemu = ", qemu-system-x86_64 -net nic,vlan=1,model=pcnet -net user,vlan=1 -m 3G -vga std -enable-kvm";
    };
    initExtra = ''
      [[ $UID -eq 0 ]] && _color=31 _prompt=# || _color=32 _prompt=$
      [[ -n $SSH_CLIENT ]] && _host="${machine-name} " || _host=
      PS1="\[\e[1;''${_color}m\]''${_host}\[\e[s\e[\''${_place}C\e[1;31m\''${_status}\e[u\e[0;34m\]\w \[\e[0;''${_color}m\]''${_prompt}\[\e[m\] "

      set -o vi
      set +h
      _promptcmd() {
          ret=$?
          [[ $ret -eq 0 || $ret -eq 148 ]] && rstat= || rstat=$ret

          if [[ -z $rstat && -z $jstat ]];then
            _status=
          elif [[ -z $rstat ]];then
            _status=$jstat
          elif [[ -z $jstat ]];then
            _status=$rstat
          else
            _status="$rstat $jstat"
          fi

          _place=$(($COLUMNS - $((''${#_host} + ''${#_status}))))

          history -a
          tail -n1 ~/.bash_history >> ~/.bash_history-all
      }
      PROMPT_COMMAND='_promptcmd'

      source ${complete-alias}/bin/complete_alias
      complete -F _complete_alias $( alias | perl -lne 'print "$1" if /^alias ([^=]*)=/' )

      if [[ $(type -p ___git_complete) != function ]];then
        source ~/.nix-profile/share/bash-completion/bash_completion
        if [[ -d ~/.nix-profile/etc/bash_completion.d ]];then
          for script in ~/.nix-profile/etc/bash_completion.d/*;do
            source "$script"
          done
        fi
      fi
      _completion_loader git
      ___git_complete g __git_main

      new_line_ps1() {
        local _ y x _
        local LIGHT_YELLOW="\001\033[1;93m\002"
        local     RESET="\001\e[0m\002"

        IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
        if [[ "$x" != 1 ]]; then
          printf "\n''${LIGHT_YELLOW}^^ no newline at end of output ^^\n''${RESET}"
        fi
      }
      PS1="\$(new_line_ps1)$PS1"
    '' + optionalString (!isNixOS) ''
      export GPG_TTY=$(tty)

      # there are often duplicate path entries on non-nixos; remove them
      NEWPATH=
      OLDIFS=$IFS
      IFS=:
      for entry in $PATH;do
        if [[ ! :$NEWPATH: == *:$entry:* ]];then
          if [[ -z $NEWPATH ]];then
            NEWPATH=$entry
          else
            NEWPATH=$NEWPATH:$entry
          fi
        fi
      done

      IFS=$OLDIFS
      export PATH="$NEWPATH"
      unset OLDIFS NEWPATH
    '' + optionalString isDarwin ''
      export PATH="$PATH":/opt/homebrew/bin
    '';
    profileExtra = ''
      [[ -e ~/cfg/secrets/bw-session ]] && export BW_SESSION=$(< ~/cfg/secrets/bw-session)
      [[ -e ~/cfg/secrets/github-token ]] && export GITHUB_TOKEN=$(< ~/cfg/secrets/github-token)
    '';
  };
  programs.zoxide.enable = true;
}
