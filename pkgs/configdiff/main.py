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
from typing import Any, Generator

from termcolor import colored

parser = argparse.ArgumentParser(
    usage="%(prog)s [OPTIONS] old new [-- NIX_ARGS]",
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
    "--old-module",
    help="the text of a module that gets injected into old, e.g. '{ services.postgresql.enable = true; }'. if this is set, only one flake is needed",
)
parser.add_argument(
    "--new-module", help="the text of a module that gets injected into new"
)
parser.add_argument(
    "--eval",
    help="nix path in config to evaluate for trace, e.g. system.build.toplevel.outPath",
)
parser.add_argument("--dump", help="dump nix output to a file instead of diffing")
parser.add_argument("--use-dump", help="use previously dumped output")
parser.add_argument(
    "--build-trace-flake",
    action="store_true",
    help="only build the flake used to generate traces",
)
parser.add_argument(
    "--verbose",
    action="store_true",
    help="print more stuff as it happens",
)
parser.add_argument(
    "--quiet",
    action="store_true",
    help="print less stuff as it happens (supresses nix output)",
)

# NIX_EXTRA_PARSER


def die(message, exitCode=1):
    print(f"{colored('error:', 'red', attrs=['bold']):} {message}")
    exit(exitCode)


args, extra_nix_eval_args = parser.parse_known_args()

if (args.old_module or args.new_module) and not args.new:
    args.new = args.old

if not ((args.new and args.old) or args.use_dump):
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


show_spinner = sys.stdout.isatty() and not args.quiet


def run_nix(*cmdline):
    spinner_chars = "/-\\"
    spinner_idx = 0
    run_args = ["nix"] + (["--quiet"] if args.quiet else []) + flatten(cmdline)
    if args.verbose:
        print("++", " ".join(run_args))
    with subprocess.Popen(
        run_args, text=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE
    ) as proc:
        for line, f in select_lines(proc.stdout, proc.stderr):
            if f == proc.stdout:
                yield line
            elif line.startswith(args.marker):
                yield line.removeprefix(args.marker)
                if show_spinner:
                    sys.stderr.write(spinner_chars[spinner_idx] + "\r")
                    spinner_idx = (spinner_idx + 1) % len(spinner_chars)
            else:
                sys.stderr.write(line)
    if show_spinner:
        sys.stderr.write("\r\033[1K")
    if proc.returncode:
        die("nix had non-zero exit code", proc.returncode)


def run_nix_str(*cmdline):
    return "".join(run_nix(*cmdline))


def get_flake_path(ref):
    data = json.loads(run_nix_str("flake", "metadata", "--json", ref))
    if "dir" in data["resolved"]:
        return os.path.join(data["path"], data["resolved"]["dir"])
    else:
        return data["path"]


def optionalArgStr(name):
    arg = getattr(args, name)
    if arg:
        parts = name.split("_")
        nix_name = "".join(parts[:1] + [part.capitalize() for part in parts[1:]])
        return ["--argstr", nix_name, arg]
    else:
        return []


trace_lines = []

if args.use_dump:
    trace_lines = open(args.use_dump)
else:
    old_flake = get_flake_path(args.old.split("#")[0])
    if args.verbose:
        print("old flake:", old_flake)
    new_flake = get_flake_path(args.new.split("#")[0])
    if args.verbose:
        print("new flake:", new_flake)
    trace_flake = run_nix_str(
        ["build", "--file", args.self_nix, f"{args.self_attr}.mkFlake"],
        ["--no-link", "--print-out-paths"] if not args.build_trace_flake else [],
        ["--arg", "old", old_flake],
        ["--arg", "new", new_flake],
        ["--argstr", "oldOutput", args.old.split("#")[1]],
        ["--argstr", "newOutput", args.new.split("#")[1]],
        optionalArgStr("eval"),
        optionalArgStr("old_module"),
        optionalArgStr("new_module"),
    ).strip()
    if args.verbose:
        print("trace flake:", trace_flake)
    if args.build_trace_flake:
        exit()
    trace_lines = run_nix("eval", "--raw", f"{trace_flake}#traced", extra_nix_eval_args)

if args.dump:
    with open(args.dump, "w") as out:
        for line in trace_lines:
            out.write(line)
    exit()

items = {}
for label, path, value in map(json.loads, trace_lines):
    if path not in items:
        items[path] = {"old": [], "new": []}
    items[path][label].extend(value.splitlines())


def norm_store_paths(text):
    return re.sub(r"/nix/store/.{32}-", f"/nix/store/{'A' * 32}-", text)


# this should never include valid store hash characters
split_pattern = re.compile(r"""([/\-"'<>])""")


def split_text(text):
    return [s for s in re.split(split_pattern, text) if s != ""]


def colored_lines(text, *args, **kwargs):
    return "\n".join(colored(line, *args, **kwargs) for line in text.splitlines())


def diff_item(key, old, new, out):
    raw_old = "\n".join(old)
    raw_new = "\n".join(new)
    if args.include_hashes:
        if raw_old == raw_new:
            return
        old_seq = old
        new_seq = new
    else:
        norm_old = norm_store_paths(raw_old)
        norm_new = norm_store_paths(raw_new)
        if norm_old == norm_new:
            return
        old_seq = norm_old.splitlines()
        new_seq = norm_new.splitlines()
        if len(old) != len(old_seq) or len(new) != len(new_seq):
            dir("normalized diff sequence length mismatch")
    line_matcher = difflib.SequenceMatcher(a=old_seq, b=new_seq, autojunk=False)
    results = []
    deleted_count = 0
    inserted_count = 0
    for tag, i1, i2, j1, j2 in line_matcher.get_opcodes():
        old_lines = [colored(line, "red") for line in old[i1:i2]]
        new_lines = [colored(line, "green") for line in new[j1:j2]]
        if tag != "equal":
            deleted_count += len(old_lines)
            inserted_count += len(new_lines)
        if tag == "delete":
            results.extend(old_lines)
        elif tag == "insert":
            results.extend(new_lines)
        elif tag == "replace":
            inline_old = split_text("\n".join(old[i1:i2]))
            inline_new = split_text("\n".join(new[j1:j2]))
            inline_old_seq = split_text("\n".join(old_seq[i1:i2]))
            inline_new_seq = split_text("\n".join(new_seq[j1:j2]))
            inline_matcher = difflib.SequenceMatcher(
                a=inline_old_seq, b=inline_new_seq, autojunk=False
            )
            inline_results = []
            for tag, i1, i2, j1, j2 in inline_matcher.get_opcodes():
                equal_parts = "".join(inline_old[i1:i2])
                old_parts = colored_lines(equal_parts, "red")
                new_parts = colored_lines("".join(inline_new[j1:j2]), "green")
                if tag == "equal":
                    inline_results.append(equal_parts)
                elif tag == "delete":
                    inline_results.append(old_parts)
                elif tag == "insert":
                    inline_results.append(new_parts)
                elif tag == "replace":
                    inline_results.extend((old_parts, new_parts))
            results.extend("".join(inline_results).splitlines())
    if results:
        result_text = "\n  ".join(results)
        full_assign = (
            len(old) == len(new) == deleted_count == inserted_count
            or (not old and len(new) == len(results))
            or (not new and len(old) == len(results))
        )
        print(
            colored(key, attrs=["bold"]),
            "=" if full_assign else "= ...",
            result_text if len(results) == 1 else "\n  " + result_text,
            file=out,
        )


with tempfile.NamedTemporaryFile("w") as out:
    for key in sorted(items.keys()):
        diff_item(key, items[key]["old"], items[key]["new"], out)
    out.flush()
    subprocess.Popen([os.getenv("PAGER", "less"), out.name]).wait()
