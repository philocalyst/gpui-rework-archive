"""Reject a wrong count using the independently positioned public layout output."""
from pathlib import Path
import hashlib
import json
import os
import shutil
import subprocess
import sys

source = Path('/tmp/gpui-coverage-integration-root')
evidence = Path('/tmp/gpui-coverage-integration-evidence')
out = Path('/tmp/gpui-count-preflight-fault-control-root')
selected = 'ff8fa35f19af553764f82a4af943c94b1235f5a4'
test = 'text::planner::tests::raw_run_counts_match_positioned_output_across_wraps_and_scripts'
git = ['git', '-C', str(source)]
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == selected
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True)
out.mkdir(exist_ok=False)


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def freeze(build_log, name):
    rows = [json.loads(line) for line in build_log.read_text().splitlines() if line.startswith('{')]
    artifacts = [row for row in rows if row.get('reason') == 'compiler-artifact'
                 and row['target']['name'] == 'gpui_canvas' and row.get('executable')]
    assert len(artifacts) == 1
    original = Path(artifacts[0]['executable'])
    binary = out / name
    before = digest(original)
    shutil.copy2(original, binary)
    binary.chmod(0o555)
    assert digest(binary) == digest(original) == before
    return {'original': str(original), 'path': str(binary), 'bytes': binary.stat().st_size,
            'sha256': before, 'compiler_artifact': artifacts[0]}


def gate(pin, label, command, expected):
    status = subprocess.call([sys.executable, '/tmp/gpui-run-frozen-gate-root.py',
                              '--source', str(source), '--pin', pin, '--out', str(out / label),
                              '--timeout', '900' if 'build' in label else '120', '--'] + command)
    assert status == expected, (label, status)
    result = json.loads((out / label / 'result.json').read_text())
    assert result['guards_match']
    return result


good = freeze(evidence / 'raw-unit-tests/stdout.log', 'good-tests')
positive = gate(selected, 'positive-run', [good['path'], test, '--exact'], 0)
assert positive['passed'] == 1 and digest(Path(good['path'])) == good['sha256']

path = source / 'reactivity/vendor/parley/src/layout/run.rs'
text = path.read_text()
old = '            .map(|cluster| cluster.glyph_len() as usize)\n            .sum()'
assert text.count(old) == 1
path.write_text(text.replace(old, old[:-len('.sum()')] + '.sum::<usize>() + 1'))
subprocess.run(git + ['add', str(path)], check=True)
subprocess.run(git + ['-c', 'user.name=Codex', '-c', 'user.email=codex@openai.com',
                      'commit', '-q', '-m', 'Fault control: overcount every raw text run'], check=True)
bad_pin = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
(out / 'fault.patch').write_bytes(subprocess.check_output(git + ['diff', selected, bad_pin]))
build = gate(bad_pin, 'negative-build', ['cargo', 'test', '--release', '--offline', '--locked',
             '--manifest-path', 'reactivity/Cargo.toml', '-p', 'gpui_canvas', '--lib', '--no-run',
             '--message-format=json'], 0)
bad = freeze(out / 'negative-build/stdout.log', 'wrong-count-tests')
negative = gate(bad_pin, 'negative-run', [bad['path'], test, '--exact'], 101)
assert negative['failed'] == 1 and digest(Path(bad['path'])) == bad['sha256']
assert digest(Path(good['path'])) == good['sha256']
subprocess.run(git + ['switch', '--detach', selected], check=True)
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True)
report = {'selected': selected, 'fault_source': bad_pin, 'good_binary': good,
          'wrong_count_binary': bad, 'positive_run': positive, 'negative_build': build,
          'negative_run': negative, 'source_restored_clean': True,
          'scope': 'Actual Canvas test executables, exact focused count oracle, before/after binary and source guards; no timing.'}
(out / 'result.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'positive': positive['passed'], 'negative_failures': negative['failed'],
                  'restored': selected}), flush=True)
