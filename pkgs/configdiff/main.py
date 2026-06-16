import itertools
import difflib
from termcolor import cprint, colored
import argparse
import subprocess
import json
import tempfile
import os
import re
import shutil

parser = argparse.ArgumentParser(
    description="diff nixpkgs lib.evalConfig between flakes, e.g. flake#nixosConfigurations.foo",
)

parser.add_argument("old", help="old flake")
parser.add_argument("new", help="new flake")
parser.add_argument(
    "configuration", help="nix path to configuration, e.g. nixosConfigurations.foo"
)
parser.add_argument(
    "--eval",
    default="system.build.toplevel.drvPath",
    help="nix path in config to evaluate for trace (default: %(default)s)",
)
parser.add_argument(
    "-i",
    "--include-hashes",
    action="store_true",
    help="include when a store path hash has changed",
)
parser.add_argument("--use-dump", default=None, help="use previously dumped output")
parser.add_argument("--dump", default=None, help="dump nix output to a file")
parser.add_argument("--debug", action="store_true")

# NIX_EXTRA_PARSER

args = parser.parse_args()


def get_flake_path(path):
    ran = subprocess.run(
        ["nix", "flake", "metadata", "--json", path], capture_output=True
    )
    return json.loads(ran.stdout)["path"]


old_flake = get_flake_path(args.old)
new_flake = get_flake_path(args.new)

columns = shutil.get_terminal_size().columns


def flatten(xss):
    return [x for xs in xss for x in xs]


trace_lines = []


trace_cmd = [
    ["nix-instantiate"],
    ["--eval", "--raw", args.self_nix, "--attr", args.self_run],
    ["--argstr", "old", old_flake],
    ["--argstr", "new", new_flake],
    ["--argstr", "configurationPath", args.configuration],
    ["--argstr", "evalPath", args.eval],
]


def run_trace():
    return subprocess.run(flatten(trace_cmd), capture_output=True)


if args.use_dump:
    trace_lines = open(args.use_dump).readlines()
else:
    ran = run_trace()
    retry_mark = b" is not valid\n"
    # FIXME this retry logic is messy and expensive
    # TODO probs can work with a dynamic flake instead of getFlake
    if ran.returncode and ran.stderr.endswith(retry_mark):
        subprocess.run(
            ["nix", "eval", f"{new_flake}#{args.configuration}.config.{args.eval}"],
        )
        ran = run_trace()
        if ran.returncode and ran.stderr.endswith(retry_mark):
            subprocess.run(
                ["nix", "eval", f"{old_flake}#{args.configuration}.config.{args.eval}"],
            )
            ran = run_trace()
    if ran.returncode:
        print(f"{colored('error', 'red')}: nix had non-zero exit code")
        print(ran.stdout.decode())
        print(ran.stderr.decode())
    if args.debug:
        print(ran.stdout.decode())
        print(ran.stderr.decode())
        exit()
    trace_lines = ran.stderr.decode().splitlines() + [args.trace_marker]

if args.dump:
    with open(args.dump, "w") as out:
        for line in trace_lines:
            print(line, file=out)
    exit()

differ = difflib.Differ()

items = {}
current_key = None
in_key = None
for line, next_line in itertools.pairwise(trace_lines):
    if line.startswith(args.trace_marker):
        is_old = line.startswith(args.trace_marker_old)
        untraced = (
            line.removeprefix(args.trace_marker_old)
            if is_old
            else line.removeprefix(args.trace_marker_new)
        )
        current_key = untraced.split(args.equals_marker)[0]
        if current_key not in items:
            items[current_key] = {"old": [], "new": []}
        in_key = "old" if is_old else "new"
        items[current_key][in_key].append(
            untraced.removeprefix(current_key + args.equals_marker).rstrip()
        )
    else:
        items[current_key][in_key].append(line.rstrip())


def diff_item(key, item, out):
    results = []
    # FIXME would be nice to not erase hashes
    if not args.include_hashes:
        for lines in (item["old"], item["new"]):
            for i, line in enumerate(lines):
                lines[i] = re.sub(r"/nix/store/.{32}-", f"/nix/store/{'X' * 32}-", line)
    for line in differ.compare(item["old"], item["new"]):
        marker = line[0]
        real_line = line[2:]
        if marker == "-":
            results.append([True, real_line])
        elif marker == "+":
            results.append([False, real_line])
    if results:
        is_one = len(results) == 1
        cprint(key, attrs=["bold"], file=out, end="" if is_one else "\n")
        if is_one:
            print(" = ", file=out, end="")
        for is_old, line in results:
            cprint(line, "red" if is_old else "green", file=out)


with tempfile.NamedTemporaryFile("w") as out:
    for key in sorted(items.keys()):
        item = items[key]

        if item["old"] == item["new"]:
            continue

        diff_item(key, item, out)

    out.flush()
    subprocess.Popen([os.getenv("PAGER", "less"), out.name]).wait()
