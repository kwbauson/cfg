from fastapi import FastAPI
from fastapi.responses import HTMLResponse

import uvicorn
import subprocess

app = FastAPI()


@app.get("/", response_class=HTMLResponse)
def index():
    return """<html>
  <body>
      <script>
        window.runAction = async (action) => {
          const el = document.getElementById(action)
          el.innerText += ' (starting)'
          await fetch(`/api/${action}`, { method: 'POST' })
          el.innerText += ' (done)'
        }
      </script>
    <button id="start_valheim" onclick="runAction('start_valheim')">
      Start Valheim
    </button>
    <br>
    <button id="start_palworld" onclick="runAction('start_palworld')">
      Start Palworld
    </button>
  </body>
</html>"""


def starter(service):
    @app.post(f"/api/start_{service}")
    def start_service():
        subprocess.run(["systemctl", "start", service])


starter("valheim")
starter("palworld")


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=13001, log_level="info")
