{ scope, isGraphical, ... }: with scope;
{
  programs.tmux = {
    enable = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 65535;
    keyMode = "vi";
    reverseSplit = true;
    secureSocket = false;
    sensibleOnTop = false;
    shortcut = "s";
    baseIndex = 1;
    extraConfig = ''
      bind -n M-C-k send-keys -R \; clear-history
      bind r source-file ~/.config/tmux/tmux.conf
      set -g set-titles on
      set -ga terminal-overrides ",*-256color:RGB"
      set -g status off
      set -g status-position top
      set -g window-status-current-format "#[fg=black]#[bg=green] #I #[bg=blue]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"
      set -g window-status-format "#[fg=black]#[bg=yellow] #I #[bg=brightblack]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"
      set -g status-fg colour1
      set -g status-bg colour0
      set -g window-status-separator ""
      set -g status-left ""
      set -g status-right ""
      set -g default-command "''${SHELL}"
      ${optionalString (isLinux && isGraphical) ''bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xsel"''}
    '';
    plugins = with tmuxPlugins; [ jump ];
  };
}
