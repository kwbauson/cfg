from typing import Generator, Any, Literal
import argparse
import difflib
import io
import json
import os
import re
import selectors
import subprocess
import sys
import tempfile

parser = argparse.ArgumentParser(
    usage="%(prog)s [OPTIONS] old new",
    description="diff nixpkgs lib.evalConfig between flakes, e.g. flake#nixosConfigurations.foo",
)

parser.add_argument(
    "old",
    nargs="?",
    help="flake installable for old configuration, e.g. old#nixosConfigurations.foo",
)
parser.add_argument("new", nargs="?", help="flake installable for new configuration")
parser.add_argument(
    "-i",
    "--include-hashes",
    action="store_true",
    help="include changes when the only difference is a store path hash",
)
parser.add_argument(
    "--eval",
    default="system.build.toplevel.outPath",
    help="nix path in config to evaluate for trace (default: %(default)s)",
)
parser.add_argument(
    "--dump", default=None, help="dump nix output to a file instead of diffing"
)
parser.add_argument("--use-dump", default=None, help="use previously dumped output")

# NIX_EXTRA_PARSER

RED = "\033[0;31m"
GREEN = "\033[0;32m"
BOLD = "\033[1m"
END = "\033[0m"


def color(text, c):
    if text:
        result = "\n".join(
            f"{c}{line}{END}" if line else line for line in text.split("\n")
        )
    else:
        result = ""
    return result


def die(message, exitCode=1):
    print(f"{color('error:', RED + BOLD):} {message}")
    exit(exitCode)


args = parser.parse_args()

if not (args.use_dump or (args.new and args.old)):
    parser.print_help()
    die("missing required args")


def flatten(x):
    if isinstance(x, list) or isinstance(x, tuple):
        result = []
        for y in x:
            result += flatten(y)
        return result
    else:
        return [x]


def select_lines(*files) -> Generator[tuple[str, Any]]:
    sel = selectors.DefaultSelector()
    for f in files:
        sel.register(f, events=selectors.EVENT_READ)
    ok = True
    while ok:
        for key, _ in sel.select():
            if key.fileobj in files:
                key.fileobj
            if isinstance(key.fileobj, io.TextIOWrapper):
                line = key.fileobj.readline()
                if line:
                    yield (line, key.fileobj)
                else:
                    for f in files:
                        for line in f:
                            yield (line, f)
                    ok = False
            else:
                die("reading from invalid fileobj")


def run_nix(*cmdline):
    spinner_chars = "/-\\"
    spinner_idx = 0
    with subprocess.Popen(
        flatten(cmdline), text=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE
    ) as proc:
        for line, f in select_lines(proc.stdout, proc.stderr):
            if f == proc.stdout:
                yield line
            elif line.startswith(args.marker):
                yield line.removeprefix(args.marker)
                sys.stderr.write(spinner_chars[spinner_idx] + "\r")
                spinner_idx = (spinner_idx + 1) % len(spinner_chars)
            else:
                sys.stderr.write(line)
    sys.stderr.write("\r\033[1K")
    if proc.returncode:
        die("nix had non-zero exit code", proc.returncode)


def run_nix_str(*cmdline):
    return "".join(run_nix(*cmdline))


def get_flake_path(path):
    return json.loads(run_nix_str("nix", "flake", "metadata", "--json", path))["path"]


trace_lines = []

if args.use_dump:
    trace_lines = open(args.use_dump)
else:
    old_flake = get_flake_path(args.old.split("#")[0])
    new_flake = get_flake_path(args.new.split("#")[0])
    traced_flake = run_nix_str(
        ["nix", "build", "--file", args.self_nix, "configdiff.mkFlake"],
        ["--no-link", "--print-out-paths"],
        ["--arg", "old", old_flake],
        ["--arg", "new", new_flake],
        ["--argstr", "oldOutput", args.old.split("#")[1]],
        ["--argstr", "newOutput", args.new.split("#")[1]],
        ["--argstr", "eval", args.eval],
    ).strip()
    trace_lines = run_nix("nix", "eval", "--raw", f"{traced_flake}#traced")

if args.dump:
    with open(args.dump, "w") as out:
        for line in trace_lines:
            out.write(line)
    exit()

items = {}
for label, path, value in map(json.loads, trace_lines):
    if path not in items:
        items[path] = {"old": [], "new": []}
    items[path][label].append(value)


def norm_store_paths(text):
    return re.sub(r"/nix/store/.{32}-", f"/nix/store/{'A' * 32}-", text)


# this should never include valid store hash characters
split_pattern = re.compile(r"""([\s/\-"'<>])""")


def diff_item(key, item, out):
    old = "\n".join(item["old"])
    new = "\n".join(item["new"])
    real_old_seq = re.split(split_pattern, old)
    real_new_seq = re.split(split_pattern, new)
    if args.include_hashes:
        old_seq = real_old_seq
        new_seq = real_new_seq
    else:
        old_seq = re.split(split_pattern, norm_store_paths(old))
        new_seq = re.split(split_pattern, norm_store_paths(new))
    if len(real_old_seq) != len(old_seq) or len(real_new_seq) != len(new_seq):
        die("sequence length mismatch")
    result = ""
    matcher = difflib.SequenceMatcher(a=old_seq, b=new_seq, autojunk=False)
    sections: list[tuple[Literal["equal", "delete", "insert"], str]] = []
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        old_text = "".join(real_old_seq[i1:i2])
        new_text = "".join(real_new_seq[j1:j2])
        match tag:
            case "equal" | "delete":
                sections.append((tag, old_text))
            case "replace":
                sections.append(("delete", old_text))
                sections.append(("insert", new_text))
            case "insert":
                sections.append((tag, new_text))
    # TODO roll changes to line boundaries
    # especially because hashes between lines look weird
    for tag, text in sections:
        match tag:
            case "equal":
                result += text
            case "delete":
                result += color(text, RED)
            case "insert":
                result += color(text, GREEN)
    # TODO cleaner exclusion of unchanged lines
    diff_lines = result.split("\n")
    changed_lines = []
    for line in diff_lines:
        if RED in line or GREEN in line:
            changed_lines.append(line)
    if not changed_lines:
        return
    result = "\n".join(changed_lines)
    multiline = len(changed_lines) > 1 or old.startswith("''") or new.startswith("''")
    if multiline:
        result = "\n" + result
    print(
        color(key, BOLD),
        # TODO check that this is what i actually want
        "=" if len(diff_lines) == len(changed_lines) else "= ...",
        result,
        file=out,
    )


with tempfile.NamedTemporaryFile("w") as out:
    for key in sorted(items.keys()):
        item = items[key]

        if item["old"] == item["new"]:
            continue

        diff_item(key, item, out)

    out.flush()
    subprocess.Popen([os.getenv("PAGER", "less"), out.name]).wait()
