"""Guard immutable path dependencies around a separately bounded source gate."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--out', required=True, type=Path)
parser.add_argument('--dependency', action='append', required=True, type=Path)
parser.add_argument('command', nargs=argparse.REMAINDER)
args = parser.parse_args()
command = args.command[1:] if args.command[:1] == ['--'] else args.command
assert command
args.out.mkdir(parents=True, exist_ok=False)

def snapshot():
    result = {}
    for source in args.dependency:
        git = ['git', '-c', f'safe.directory={source}', '-C', str(source)]
        assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
        names = subprocess.check_output(git + ['ls-files'], text=True).splitlines()
        hashes = {name: hashlib.sha256((source / name).read_bytes()).hexdigest()
                  for name in names if (source / name).is_file()}
        result[str(source)] = {
            'head': subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip(),
            'files': hashes,
        }
    return result

before = snapshot()
(args.out / 'before.json').write_text(json.dumps(before, indent=2) + '\n')
(args.out / 'argv.json').write_text(json.dumps(command, indent=2) + '\n')
status = subprocess.call(command)
after = snapshot()
(args.out / 'after.json').write_text(json.dumps(after, indent=2) + '\n')
result = {'exit': status, 'guards_match': before == after,
          'files': sum(len(value['files']) for value in before.values())}
(args.out / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result), flush=True)
assert before == after
raise SystemExit(status)
