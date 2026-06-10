{ scope, ... }: with scope;
{
  plugins = ps: ps.hashicorp_google;
  provider.google = {
    project = "kwbauson";
    region = "us-east1";
    zone = "us-east1-a";
  };

  resource.google_project_service = genAttrs
    [ "cloudasset" "secretmanager" ]
    (name: {
      service = "${name}.googleapis.com";
      disable_on_destroy = true;
    });
}
