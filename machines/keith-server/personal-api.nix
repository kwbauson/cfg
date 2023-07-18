{ scope, ... }: with scope;
let
  app = writePython3Bin "main.py" { libraries = with python3.pkgs; [ fastapi uvicorn ]; } ''
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
        uvicorn.run("main:app", port=${toString constants.personal-api.port}, log_level="info")
  '';
in
{
  systemd.services.personal-api.script = getExe app;
}
