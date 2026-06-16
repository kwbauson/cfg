import itertools
import difflib
from termcolor import cprint, colored
import argparse
import subprocess
import json
import tempfile
import os
import re
import io

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
    default="system.build.toplevel.outPath",
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


def flatten(x):
    if isinstance(x, list) or isinstance(x, tuple):
        result = []
        for y in x:
            result += flatten(y)
        return result
    else:
        return [x]


def run_nix(*cmdline, autoExit=True):
    ran = subprocess.Popen(
        flatten(cmdline), stderr=subprocess.STDOUT, stdout=subprocess.PIPE
    )
    if not ran.stdout:
        print(f"{colored('error:', 'red', attrs=['bold'])} missing cmd stdout")
        exit(1)
    output = []
    for line in io.TextIOWrapper(ran.stdout):
        output.append(line.removesuffix("\n"))
    ran.wait()
    if autoExit and ran.returncode:
        print(f"{colored('error:', 'red', attrs=['bold'])} nix had non-zero exit code")
        print("\n".join(output))
        exit(ran.returncode)
    return output


trace_lines = []

if args.use_dump:
    trace_lines = open(args.use_dump).readlines()
else:
    old_flake = get_flake_path(args.old)
    new_flake = get_flake_path(args.new)
    traced_flake = run_nix(
        ["nix", "build", "--file", args.self_nix, "configdiff.mkFlake"],
        ["--no-link", "--print-out-paths"],
        ["--arg", "old", old_flake],
        ["--arg", "new", new_flake],
        ["--argstr", "configuration", args.configuration],
        ["--argstr", "eval", args.eval],
    )[-1]
    trace_lines = run_nix("nix", "eval", "--raw", f"{traced_flake}#traced")
    if args.debug:
        print("\n".join(trace_lines))
        exit()
    trace_lines += [args.trace_marker]

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
    elif current_key is not None:
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
