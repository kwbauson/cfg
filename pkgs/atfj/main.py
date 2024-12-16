#!/usr/bin/env python
import typer
import json
import subprocess
import sys
import os
from dataclasses import dataclass
from openai import OpenAI
from pathlib import Path
from rich import print
from typing_extensions import Annotated
from enum import StrEnum
from rich.syntax import Syntax

APP_NAME = "atfj"

app = typer.Typer(no_args_is_help=True)

python = sys.executable

app_dir = Path(typer.get_app_dir(APP_NAME))
scripts_dir = app_dir / "scripts"
config_path = app_dir / "config.json"


@dataclass
class Config:
    base_url: str = ""
    api_key: str = ""
    model: str = ""


def get_config():
    if config_path.exists():
        with open(config_path) as config_file:
            data = json.load(config_file)
            return Config(**data)
    else:
        return Config()


config = get_config()


@app.command()
def configure(
    base_url: Annotated[str, typer.Option(prompt=True)] = config.base_url,
    api_key: Annotated[str, typer.Option(prompt=True)] = config.api_key,
    model: Annotated[str, typer.Option(prompt=True)] = config.model,
):
    new_config = {"base_url": base_url, "api_key": api_key, "model": model}
    app_dir.mkdir(parents=True, exist_ok=True)
    with open(config_path, "w") as config_file:
        config_file.write(json.dumps(new_config))


def make_prompt(input: str, details: str):
    return f"""
I have this sample text:
```
{input}
```

Write a python3 program to convert text structured like this into JSON.
The program should read text from stdin.
Only output code.

{details}
"""


def run_prompt(prompt: str):
    client = OpenAI(base_url=config.base_url, api_key=config.api_key)
    response = client.chat.completions.create(
        model=config.model,
        messages=[
            {
                "role": "user",
                "content": [{"type": "text", "text": prompt}],
            }
        ],
    )
    return response.choices[0].message.content or ""


def extract_python(text: str):
    lines = []
    started = False
    finished = False
    for line in text.splitlines():
        if started:
            if line == "```":
                finished = True
                break
            lines.append(line)

        if line == "```python":
            started = True
    if started and finished:
        return "\n".join(lines)


def get_script(sample: str, details: str):
    # return 'print("hello world")'
    print("[yellow]Generating script...[/yellow]", file=sys.stderr)
    return extract_python(run_prompt(make_prompt(sample, details)))


def create_script(id: str, script: str):
    scripts_dir.mkdir(parents=True, exist_ok=True)
    with open(scripts_dir / id, "w") as file:
        file.write(script)


def run_script(id: str, sample: str, err=False):
    proc = subprocess.Popen(
        [sys.executable, scripts_dir / id],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
    )
    output = proc.communicate(sample)[0]
    if not output.endswith("\n"):
        output = output + "\n"
    if err:
        print(output, end="", file=sys.stderr)
    else:
        print(output, end="")


def get_id(cmd: list[str]):
    id_parts = []
    breakIndex = None
    for i, item in enumerate(cmd):
        if item == "--":
            breakIndex = i
            break
        id_parts.append(item)
    if breakIndex is not None:
        del cmd[breakIndex]
    return "_".join(id_parts) + ".py"


TEMP = "__temp__.py"


class TryOption(StrEnum):
    accept = "accept"
    test = "test"
    details = "details"
    edit = "edit"
    retry = "retry"
    abort = "abort"


def try_sample(id: str, sample: str):
    options = list(TryOption.__members__.values())
    choice = TryOption("retry")
    details = ""
    script = get_script(sample, details)
    printed = False
    while choice != "accept" and choice != "abort":
        if script is None:
            print("[red]Failed to get python script[/red]", file=sys.stderr)
            script = ""
        elif not printed:
            print(Syntax(script, "python"), file=sys.stderr)
            printed = True

        print("[green]Choose an action[/green]", file=sys.stderr)
        choice = typer.prompt(
            "(" + ", ".join(options) + ")",
            type=TryOption,
            err=True,
        )

        if choice == "accept":
            create_script(id, script)
            run_script(id, sample)
        elif choice == "test":
            create_script(TEMP, script)
            run_script(TEMP, sample, err=True)
        elif choice == "details":
            details = typer.prompt("Extra prompt details", err=True)
            script = get_script(sample, details)
            printed = False
        elif choice == "edit":
            create_script(TEMP, script)
            editor = os.environ.get("EDITOR", "nano")
            subprocess.call([editor, scripts_dir / TEMP])
            with open(scripts_dir / TEMP) as file:
                script = file.read()
        elif choice == "retry":
            script = get_script(sample, details)
            printed = False


@app.command()
def make(sample_path: Path, cmd: list[str]):
    id = get_id(cmd)
    with open(sample_path) as file:
        sample = file.read()
    try_sample(id, sample)


@app.command()
def run(cmd: list[str]):
    id = get_id(cmd)
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True)
    if proc.stdout:
        sample = proc.stdout.read()
        if (scripts_dir / id).exists():
            run_script(id, sample)
        else:
            try_sample(id, sample)


@app.command()
def rm(cmd: list[str]):
    id = get_id(cmd)
    script_file = scripts_dir / id
    script_file.unlink()


if __name__ == "__main__":
    app()
