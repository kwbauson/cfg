{ scope, ... }: with scope;
let
  scriptPython = (python3.withPackages (ps: with ps; [ uvicorn fastapi ])).overrideAttrs (_: { ignoreCollisions = true; });
  script = /* python */ ''
    #!${scriptPython.interpreter}
    from fastapi import FastAPI
    from fastapi.responses import RedirectResponse
    import uvicorn
    app = FastAPI()


    @app.get("/search/tf/{resource}")
    def tf(resource: str):
        provider, item = resource.split('_', 1)
        return RedirectResponse(
            "https://registry.terraform.io/providers/hashicorp"
            f"/{provider}/latest/docs/resources/{item}"
        )


    @app.get("/search/tfd/{resource}")
    def tfd(resource: str):
        provider, item = resource.split('_', 1)
        return RedirectResponse(
            "https://registry.terraform.io/providers/hashicorp"
            f"/{provider}/latest/docs/data-sources/{item}"
        )


    if __name__ == "__main__":
        uvicorn.run("main:app", host="0.0.0.0", port=${toString constants.personal-api.port}, log_level="info")
  '';
  app = writeScriptBin "main.py" script;
in
{
  systemd.services.personal-api = {
    wantedBy = [ "multi-user.target" ];
    script = getExe app;
  };
}
