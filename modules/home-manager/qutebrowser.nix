{ scope, isGraphical, ... }: with scope;
{
  programs.qutebrowser = {
    enable = isGraphical && isLinux;
    loadAutoconfig = true;
    aliases = {
      h = "help";
      q = "quit";
      w = "session-save";
      wq = "quit --save";
    };
    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      aur = "https://aur.archlinux.org/packages/?K={}";
      aw = "https://wiki.archlinux.org/index.php?search={}";
      g = "https://www.google.com/search?q={}";
      nw = "https://nixos.wiki/index.php?search={}&go=Go";
      tv = "https://www.google.com/search?q=site:tvtropes.org+{}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}";
      yt = "http://www.youtube.com/results?search_query={}";
      b = "https://www.biblegateway.com/passage/?version=NLT&search={}";
    };
    settings = {
      confirm_quit = [ "downloads" ];
      new_instance_open_target = "window";
      session.default_name = "default";
      auto_save.session = true;
      content.cache.size = null;
      content.fullscreen.window = true;
      content.geolocation = false;
      content.pdfjs = true;
      completion.cmd_history_max_items = -1;
      completion.height = "25%";
      completion.show = "auto";
      completion.web_history.exclude = [ "about:blank" ];
      completion.open_categories = [ "bookmarks" "history" ];
      downloads.remove_finished = 1000;
      hints.chars = "asdfghjkl;qwertyuiopzxcvbnm";
      hints.scatter = false;
      hints.uppercase = true;
      input.forward_unbound_keys = "none";
      spellcheck.languages = [ "en-US" ];
      statusbar.position = "top";
      statusbar.widgets = [ "keypress" "url" "scroll" "history" "progress" ];
      tabs.show = "multiple";
      tabs.tabs_are_windows = true;
      url.default_page = "about:blank";
      url.open_base_url = true;
      url.start_pages = [ "about:blank" ];
      window.title_format = "{perc}{current_title}";
      colors.webpage.preferred_color_scheme = "dark";
    };
    keyBindings.normal = {
      ";d" = "hint all delete";
      ";e" = "hint inputs";
      ";f" = "hint all tab-fg";
      ";r" = "hint --rapid all tab-bg";
      ";y" = "hint links yank-primary";
      "<Alt+h>" = "scroll left";
      "<Alt+j>" = "scroll down";
      "<Alt+k>" = "scroll up";
      "<Alt+l>" = "scroll right";
      "<Ctrl+e>" = "scroll-px 0 40";
      "<Ctrl+y>" = "scroll-px 0 -40";
      "<Down>" = "scroll down";
      "<Shift+Space>" = "scroll-page 0 -1";
      "<Space>" = "scroll-page 0 1";
      "<Up>" = "scroll up";
      F = "hint all tab-bg";
      O = "set-cmd-text :open {url:pretty}";
      P = "open -t {primary}";
      T = "set-cmd-text :open -t {url:pretty}";
      Y = "yank";
      b = "set-cmd-text -s :open -b";
      c = "tab-clone";
      gb = "open qute:bookmarks";
      gp = "spawn -u login-fill";
      gq = "open https://github.com/qutebrowser/qutebrowser/commits/master";
      gc = "open https://github.com/kwbauson/cfg";
      gn = "open https://github.com/NixOS/nix/commits/master";
      gN = "open https://github.com/NixOS/nixpkgs/commits/master";
      gs = "set";
      gv = "open qute:version";
      h = "scroll-px -40 0";
      j = "scroll-px 0 40";
      k = "scroll-px 0 -40";
      l = "scroll-px 40 0";
      p = "open {primary}";
      s = "stop";
      t = "set-cmd-text -s :open -t";
      w = "open -t";
      y = "yank --sel";
      u = "undo --window";
    };
    keyBindings.insert = {
      "<Ctrl+h>" = "fake-key <backspace>";
      "<Ctrl+j>" = "fake-key <enter>";
      "<Ctrl+m>" = "fake-key <enter>";
      "<Ctrl+u>" = "fake-key <shift-home><backspace>";
      "<Ctrl+w>" = "fake-key <ctrl-backspace>";
    };
    extraConfig = ''
      config.unbind("<Ctrl+w>")
    '';
  };
  xdg.dataFile."qutebrowser/userscripts/login-fill" = {
    executable = true;
    source = writeBash "login-fill" ''
      set -e
      if [[ -e ~/cfg/secrets/bw-session ]];then
        export BW_SESSION=$(< ~/cfg/secrets/bw-session)
      fi
      items=$(bw list items --url "$QUTE_URL" | jq 'map(.login) | map({ username, password, url: .uris[0].uri })')
      count=$(echo "$items" | jq length)
      if [[ $count -eq 1 ]];then
        choice=1
      elif [[ $count -gt 1 ]];then
        choices=$(echo "$items" | jq -r 'map([.username, .url]) | map(join(" | ")) | join("\n")' | nl)
        choice=$(echo "$choices" | rofi -dmenu | awk '{ print $1 }')
      else
        echo no matching logins
        exit 1
      fi
      if [[ -n $choice ]];then
        item=$(echo "$items" | jq ".[$choice - 1]")
        username=$(echo "$item" | jq -r '.username')
        password=$(echo "$item" | jq -r '.password')
        echo "jseval -q document.querySelectorAll('input[type=password]')[0].focus()" > "$QUTE_FIFO"
        echo "fake-key $password<shift-tab>$username<tab>" > "$QUTE_FIFO"
      fi
    '';
  };
}
