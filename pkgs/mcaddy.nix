scope: with scope;
(caddy.withPlugins {
  plugins = [ "github.com/greenpau/caddy-security@v1.1.50" ];
  hash = "sha256-YIiI8AqT8YnfXCd2qv02btw9YFTE49SZ/7l82CVCunQ=";
}).overrideAttrs (old: {
  meta = old.meta // {
    skipBuild = isDarwin;
  };
  passthru = old.passthru // {
    tests = { };
    # TODO updateScript
  };
})
