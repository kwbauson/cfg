import argparse
import difflib
import io
import json
import os
import re
import subprocess
import tempfile

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

# NIX_EXTRA_PARSER

RED = "\033[0;31m"
GREEN = "\033[0;32m"
BOLD = "\033[1m"
END = "\033[0m"


def color(text, c):
    if text:
        result = "\n".join(f"{c}{l}{END}" if l else l for l in text.split("\n"))
    else:
        result = ""
    return result


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


def run_nix(*cmdline, autoExit=True, tracing=False):
    ran = subprocess.Popen(
        flatten(cmdline), stderr=subprocess.STDOUT, stdout=subprocess.PIPE
    )
    if not ran.stdout:
        print(f"{color('error:', RED + BOLD)} missing cmd stdout")
        exit(1)
    output = []
    for line in io.TextIOWrapper(ran.stdout):
        line = line.removesuffix("\n")
        if tracing:
            if line.startswith(args.trace_marker):
                output.append(line)
            else:
                print(line)
        else:
            print(line)
            output.append(line)
    ran.wait()
    if autoExit and ran.returncode:
        print(f"{color('error:', RED + BOLD)} nix had non-zero exit code")
        exit(ran.returncode)
    return output


trace_lines = []

if args.use_dump:
    trace_lines = [l.removesuffix("\n") for l in open(args.use_dump).readlines()]
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
    trace_lines = run_nix(
        "nix", "eval", "--raw", f"{traced_flake}#traced", tracing=True
    )

if args.dump:
    with open(args.dump, "w") as out:
        for line in trace_lines:
            print(line, file=out)
    exit()

differ = difflib.Differ()

items = {}
current_key = None
in_key = None
for line in trace_lines:
    is_old = line.startswith(args.trace_marker_old)
    untraced = (
        line.removeprefix(args.trace_marker_old)
        if is_old
        else line.removeprefix(args.trace_marker_new)
    )
    is_assign = args.equals_marker in line
    if is_assign:
        current_key = untraced.split(args.equals_marker)[0]
    if current_key not in items:
        items[current_key] = {"old": [], "new": []}
    in_key = "old" if is_old else "new"
    items[current_key][in_key].append(
        untraced.removeprefix(current_key + args.equals_marker)
    )


def norm_store_paths(text):
    return re.sub(r"/nix/store/.{32}-", f"/nix/store/{'A' * 32}-", text)


split_pattern = re.compile(r"""([\s/\-"'<>])""")


def diff_item(key, item, out):
    old = "\n".join(item["old"])
    new = "\n".join(item["new"])
    if not args.include_hashes and norm_store_paths(old) == norm_store_paths(new):
        return
    old_seq = re.split(split_pattern, old)
    new_seq = re.split(split_pattern, new)
    result = ""
    matcher = difflib.SequenceMatcher(None, old_seq, new_seq)
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        old_str = "".join(old_seq[i1:i2])
        new_str = "".join(new_seq[j1:j2])
        red = color(old_str, RED)
        green = color(new_str, GREEN)
        match tag:
            case "equal":
                result += old_str
            case "replace":
                result += red + green
            case "delete":
                result += red
            case "insert":
                result += green
    diff_lines = result.split("\n")
    result_lines = []
    for line in diff_lines:
        if RED in line or GREEN in line:
            result_lines.append(line)
    result = "\n".join(result_lines)
    multiline = len(result_lines) > 1 or old.startswith("''") or new.startswith("''")
    if multiline:
        result = "\n" + result
    print(color(key, BOLD), "=", result, file=out)


with tempfile.NamedTemporaryFile("w") as out:
    for key in sorted(items.keys()):
        item = items[key]

        if item["old"] == item["new"]:
            continue

        diff_item(key, item, out)

    out.flush()
    subprocess.Popen([os.getenv("PAGER", "less"), out.name]).wait()
