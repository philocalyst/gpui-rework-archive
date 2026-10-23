from pathlib import Path
import gzip
import hashlib
import json
import re
import shutil
import subprocess


PIN = 'd6883d6d6ad2cee0ba3d3458ac9ef7fac5dea78e'
SOURCE = Path('/tmp/gpui-source-value-nightly-root')
DEST = Path('/root/gpui-ce3/reactivity/evidence/source-value-nightly/native-and-strict')
GIT = ['git', '-c', f'safe.directory={SOURCE}', '-C', str(SOURCE)]
assert subprocess.check_output(GIT + ['rev-parse', 'HEAD'], text=True).strip() == PIN
assert not subprocess.check_output(GIT + ['status', '--porcelain'], text=True).strip()
assert not DEST.exists()

captures = [
    ('native-no-backend-failed', Path('/tmp/gpui-source-value-nightly-native-evidence'),
     Path('/tmp/gpui-source-value-nightly-native-root.py'), 101, (0, 0, 0, 0)),
    ('native-x11-combined-timeout', Path('/tmp/gpui-source-value-nightly-native-x11-evidence'),
     Path('/tmp/gpui-source-value-nightly-native-x11-root.py'), 124, (610, 0, 33, 56)),
    ('native-x11-postbuild', Path('/tmp/gpui-source-value-nightly-native-x11-postbuild-evidence'),
     Path('/tmp/gpui-source-value-nightly-native-x11-postbuild-root.py'), 0, (620, 0, 34, 86)),
    ('strict-deprecation-failed', Path('/tmp/gpui-source-value-nightly-strict-evidence'),
     Path('/tmp/gpui-source-value-nightly-strict-root.py'), None, None),
]
verified = []
all_files = []
for name, directory, helper, expected_exit, expected_counts in captures:
    before = json.loads((directory / 'before.json').read_text())
    after = json.loads((directory / 'after.json').read_text())
    assert before == after and len(before) == 1989
    for filename, expected_hash in before.items():
        assert hashlib.sha256((SOURCE / filename).read_bytes()).hexdigest() == expected_hash, filename
    record = {'capture': name, 'source': PIN, 'guards_reopened': len(before), 'guards_match': True}
    if expected_exit is not None:
        command = json.loads((directory / 'command.json').read_text())
        assert command['source'] == PIN and command['RUSTC_BOOTSTRAP'] is None
        assert command['timeout_seconds'] == 600
        status = int((directory / 'native.exit').read_text())
        rows = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;',
                          (directory / 'native.jsonl').read_text())
        actual = tuple(sum(int(row[i]) for row in rows) for i in range(3)) + (len(rows),)
        assert status == expected_exit and actual == expected_counts, (name, status, actual)
        summary = json.loads((directory / 'summary.json').read_text())
        assert summary['exit'] == status and summary['bootstrap'] is False
        assert tuple(summary[k] for k in ['passed', 'failed', 'ignored', 'harnesses']) == actual
        version = (directory / 'rustc.txt').read_text()
        assert '1.101.0-nightly' in version and '7189d39d9' in version
        record.update(exit=status, passed=actual[0], failed=actual[1], ignored=actual[2], harnesses=actual[3])
    else:
        commands = json.loads((directory / 'commands.json').read_text())
        for mode in ['default', 'native']:
            assert commands[mode]['source'] == PIN and commands[mode]['bootstrap'] is False
            assert int((directory / f'{mode}.exit').read_text()) == 101
            diagnostic = (directory / f'{mode}.jsonl').read_text()
            assert 'fetch_update' in diagnostic and 'deprecated' in diagnostic
        record.update(default_exit=101, native_exit=101, reason='existing std atomic deprecation under -D warnings')
    verified.append(record)
    all_files.extend((name, file, file.name) for file in sorted(directory.iterdir()) if file.is_file())
    assert helper.is_file()
    all_files.append((name, helper, 'capture.py'))

DEST.mkdir(parents=True)
payload = {}
for name, original, leaf in all_files:
    target_dir = DEST / name
    target_dir.mkdir(exist_ok=True)
    raw = original.read_bytes()
    compressed = len(raw) >= 20_000
    target = target_dir / (leaf + '.gz' if compressed else leaf)
    target.write_bytes(gzip.compress(raw, mtime=0) if compressed else raw)
    reopened = gzip.decompress(target.read_bytes()) if compressed else target.read_bytes()
    assert reopened == raw
    payload[str(target.relative_to(DEST))] = {
        'original': str(original), 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest(),
        'stored_bytes': target.stat().st_size, 'stored_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
        'compression': 'gzip mtime=0' if compressed else None,
    }
report = {'source': PIN, 'source_tree_clean': True, 'captures': verified, 'files': payload,
          'production_adopted': False,
          'scope': 'Native feature tests, not native window execution. Postbuild uses same600s deadline. All failed attempts preserved. Strict/foreign/cost successors are separate pins.'}
(DEST / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
shutil.copy2(__file__, DEST / 'verify-and-archive.py')
print(json.dumps({'captures': verified, 'payload_files': len(payload), 'stored_bytes': sum(x['stored_bytes'] for x in payload.values())}, indent=2))
