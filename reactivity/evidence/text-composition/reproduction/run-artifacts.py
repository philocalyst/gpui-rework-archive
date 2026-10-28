from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import shutil
import signal
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--build', type=Path, required=True)
parser.add_argument('--out', type=Path, required=True)
parser.add_argument('--per-binary-seconds', type=int, default=120)
args = parser.parse_args()
assert json.loads((args.build / 'result.json').read_text())['exit'] == 0
rows = [json.loads(line) for line in (args.build / 'stdout.log').read_text().splitlines()]
assert any(row.get('reason') == 'build-finished' and row['success'] for row in rows)
artifacts = [row for row in rows if row.get('reason') == 'compiler-artifact'
             and row.get('executable') and row['profile']['test']]
assert artifacts
args.out.mkdir(parents=True, exist_ok=False)
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
results = []
for index, row in enumerate(artifacts):
    original = Path(row['executable'])
    directory = args.out / f'{index:03}-{row["target"]["name"]}'
    directory.mkdir()
    binary = original
    # Exclusive target: retain and recheck identity without copying huge ELFs.
    identity = {'original': str(original), 'frozen': str(binary),
                'sha256': digest(binary), 'bytes': binary.stat().st_size,
                'fresh': row['fresh'], 'package_id': row['package_id'],
                'target': row['target'], 'features': row['features'],
                'profile': row['profile']}
    (directory / 'binary.json').write_text(json.dumps(identity, indent=2) + '\n')
    with (directory / 'stdout.log').open('w') as stdout, (directory / 'stderr.log').open('w') as stderr:
        child = subprocess.Popen([str(binary), '--test-threads=1', '--nocapture'], stdout=stdout,
                                 stderr=stderr, start_new_session=True)
        try:
            status = child.wait(timeout=args.per_binary_seconds)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid, signal.SIGTERM)
            try:
                child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(child.pid, signal.SIGKILL)
                child.wait()
            status = 124
    assert digest(binary) == identity['sha256']
    output = (directory / 'stdout.log').read_text()
    counts = re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored;', output)
    result = {'target': row['target']['name'], 'exit': status,
              'passed': sum(int(c[0]) for c in counts),
              'failed': sum(int(c[1]) for c in counts),
              'ignored': sum(int(c[2]) for c in counts),
              'sha256_after_matches': True}
    (directory / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
    results.append(result)
    print(json.dumps(result), flush=True)
report = {'harnesses': len(results), 'passed': sum(r['passed'] for r in results),
          'failed': sum(r['failed'] for r in results),
          'ignored': sum(r['ignored'] for r in results),
          'all_exit_zero': all(r['exit'] == 0 for r in results), 'results': results,
          'scope': 'Pinned Cargo JSON artifacts in exclusive target; SHA256 before and after sequential execution; no performance inference.'}
(args.out / 'result.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({key: value for key, value in report.items() if key != 'results'}), flush=True)
sys.exit(0 if report['all_exit_zero'] else 1)
