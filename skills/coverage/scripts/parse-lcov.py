#!/usr/bin/env python3
"""
Parse lcov.info and correlate with git diff to find uncovered changed lines.

Usage:
  python3 scripts/parse-lcov.py --lcov <path> --diff <path>

Output (stdout):
  file:line for each uncovered changed line

Exit codes:
  0 - success (even if uncovered lines found)
  1 - error (missing args, file not found, parse failure)
"""
import argparse
import re
import sys


def parse_lcov(lcov_path):
    coverage = {}
    current_file = None
    try:
        with open(lcov_path) as f:
            for line in f:
                line = line.strip()
                if line.startswith("SF:"):
                    current_file = line[3:]
                    coverage[current_file] = {}
                elif line.startswith("DA:") and current_file:
                    parts = line[3:].split(",")
                    if len(parts) >= 2:
                        lineno = int(parts[0])
                        hits = int(parts[1])
                        coverage[current_file][lineno] = hits
                elif line == "end_of_record":
                    current_file = None
    except FileNotFoundError:
        print(f"ERROR: lcov file not found: {lcov_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: failed to parse lcov file: {e}", file=sys.stderr)
        sys.exit(1)
    return coverage


def parse_diff(diff_path):
    changed = {}
    current_file = None
    current_line = None
    try:
        with open(diff_path) as f:
            for line in f:
                m = re.match(r"^\+\+\+ b/(.+)", line)
                if m:
                    current_file = m.group(1)
                    changed.setdefault(current_file, set())
                    continue
                m = re.match(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@", line)
                if m:
                    current_line = int(m.group(1))
                    continue
                if current_file and current_line is not None:
                    if line.startswith("+") and not line.startswith("+++"):
                        changed[current_file].add(current_line)
                        current_line += 1
                    elif not line.startswith("-"):
                        current_line += 1
    except FileNotFoundError:
        print(f"ERROR: diff file not found: {diff_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: failed to parse diff file: {e}", file=sys.stderr)
        sys.exit(1)
    return changed


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--lcov", required=True, help="Path to lcov.info")
    parser.add_argument("--diff", required=True, help="Path to git diff output file")
    args = parser.parse_args()

    coverage = parse_lcov(args.lcov)
    changed = parse_diff(args.diff)

    uncovered = []
    total = 0
    covered = 0

    for filepath, lines in changed.items():
        file_coverage = None
        for lcov_path in coverage:
            if lcov_path.endswith(filepath) or filepath.endswith(lcov_path):
                file_coverage = coverage[lcov_path]
                break

        if file_coverage is None:
            continue

        for lineno in sorted(lines):
            hits = file_coverage.get(lineno)
            if hits is None:
                continue
            total += 1
            if hits > 0:
                covered += 1
            else:
                uncovered.append(f"{filepath}:{lineno}")

    for item in uncovered:
        print(item)

    print(f"SUMMARY: {covered}/{total} changed lines covered", file=sys.stderr)


if __name__ == "__main__":
    main()
