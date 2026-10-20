"""Open a PR stack and link every body.

Usage: python3 open_stack.py <stack.json>

stack.json:
  {
    "repo": "/path/to/repo",
    "base": "main",
    "layers": [
      {"branch": "feat/x", "title": "feat: the whole change", "body": "body-1.md"},
      {"branch": "feat/x-2", "title": "feat: [2/3] ...", "body": "body-2.md"}
    ]
  }

Body paths are relative to stack.json. Bodies use {{PR1}}..{{PRn}} for PR numbers.
Layer 1 targets `base`. Each later layer targets the branch below it. A layer whose
branch already has an open PR keeps it, and layer 1's title is set to its `title`.
Rerunning is safe: it only creates the PRs that are missing.
"""

import json
import pathlib
import re
import subprocess
import sys


def main(stack_path):
    stack_file = pathlib.Path(stack_path).resolve()
    stack = json.loads(stack_file.read_text())
    layers = stack['layers']

    def gh(*args):
        return subprocess.run(
            ['gh', *args], cwd=stack['repo'], check=True, capture_output=True, text=True
        ).stdout.strip()

    numbers = {}
    for n, layer in enumerate(layers, start=1):
        existing = gh('pr', 'list', '--head', layer['branch'], '--state', 'open',
                      '--json', 'number', '-q', '.[0].number')
        if existing:
            numbers[n] = int(existing)
            continue
        base = stack['base'] if n == 1 else layers[n - 2]['branch']
        url = gh('pr', 'create', '--draft', '--base', base, '--head', layer['branch'],
                 '--title', layer['title'], '--body-file', str(stack_file.parent / layer['body']))
        numbers[n] = int(url.rsplit('/', 1)[1])

    for n, layer in enumerate(layers, start=1):
        template = (stack_file.parent / layer['body']).read_text()
        body = re.sub(r'\{\{PR(\d+)\}\}', lambda m: f'#{numbers[int(m.group(1))]}', template)
        filled = stack_file.parent / f'filled-{n}.md'
        filled.write_text(body)
        retitle = ['--title', layer['title']] if n == 1 else []
        gh('pr', 'edit', str(numbers[n]), '--body-file', str(filled), *retitle)

    for n, layer in enumerate(layers, start=1):
        print(f"{n}. #{numbers[n]} {layer['branch']}")


if __name__ == '__main__':
    main(sys.argv[1])
