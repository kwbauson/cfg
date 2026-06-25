from fastapi import FastAPI
from fastapi.responses import RedirectResponse

import uvicorn
import os

port = int(os.getenv("PORT", ""))
app = FastAPI()


@app.get("/search/tf/{resource}")
def tf(resource: str):
    provider, item = resource.split("_", 1)
    return RedirectResponse(
        "https://registry.terraform.io/providers/hashicorp"
        f"/{provider}/latest/docs/resources/{item}"
    )


@app.get("/search/tfd/{resource}")
def tfd(resource: str):
    provider, item = resource.split("_", 1)
    return RedirectResponse(
        "https://registry.terraform.io/providers/hashicorp"
        f"/{provider}/latest/docs/data-sources/{item}"
    )


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=port, log_level="info")
