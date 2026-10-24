from pathlib import Path
import hashlib
import json
import os
import shutil
import subprocess
import sys

source = Path('/tmp/gpui-coverage-certificate-fault-root')
root = Path('/tmp/gpui-bundled-coverage-evidence/fault-control')
root.mkdir(exist_ok=False)
artifact = Path('/tmp/gpui-bundled-coverage-generator-target/release/build/ttf-parser/8e9a0952ebbf403a/out')
dependencies = [artifact / ('libttf_parser-8e9a0952ebbf403a.' + extension) for extension in ['rmeta', 'rlib']]
def digest(path):
    with path.open('rb') as handle:
        return hashlib.file_digest(handle, 'sha256').hexdigest()
before = {str(path): digest(path) for path in dependencies}
records = {}
for variant in ['baseline', 'wrong-primary-bit']:
    if variant != 'baseline':
        path = source / 'font-coverage.bin'
        data = bytearray(path.read_bytes())
        for index in range(0, len(data), 3):
            word = int.from_bytes(data[index:index + 3], 'little')
            if word & ((1 << 21) - 1) >= ord('A'):
                changed = word ^ (1 << 21)
                data[index:index + 3] = changed.to_bytes(3, 'little')
                break
        else:
            raise AssertionError('no ASCII interval')
        path.write_bytes(data)
        subprocess.run(['git', '-C', str(source), 'add', 'font-coverage.bin'], check=True)
        subprocess.run(['git', '-C', str(source), 'commit', '-q', '-m', 'Inject one wrong primary coverage bit'], check=True)
    pin = subprocess.check_output(['git', '-C', str(source), 'rev-parse', 'HEAD'], text=True).strip()
    destination = root / variant
    destination.mkdir()
    binary = destination / 'certificate-tests'
    common = [sys.executable, '/tmp/gpui-freeze-dependencies-root.py', '--dependency', '/tmp/gpui-coverage-integration-root']
    def gate(name, arguments, expected):
        command = common + ['--out', str(destination / (name + '-dependencies')), '--',
            sys.executable, '/tmp/gpui-run-frozen-gate-root.py', '--source', str(source), '--pin', pin,
            '--out', str(destination / name), '--timeout', '60', '--'] + arguments
        result = subprocess.run(command)
        assert result.returncode == expected, (variant, name, result.returncode, expected)
    compiler = [os.environ['RUSTC'], '--edition=2024', '--test', '-C', 'opt-level=3', str(source / 'harness.rs')]
    for dependency in dependencies:
        compiler += ['--extern', 'ttf_parser=' + str(dependency)]
    compiler += ['-L', 'dependency=' + str(artifact), '-o', str(binary)]
    gate('build', compiler, 0)
    binary.chmod(0o555)
    binary_hash = digest(binary)
    arguments = [str(binary), '--test-threads=1', '--nocapture']
    if variant != 'baseline':
        arguments += ['--exact', 'text::bundled_coverage::tests::every_unicode_scalar_matches_original_font_coverage']
    gate('run', arguments, 0 if variant == 'baseline' else 101)
    assert digest(binary) == binary_hash
    records[variant] = {'source': pin, 'binary': str(binary), 'sha256': binary_hash,
                        'build': json.loads((destination / 'build/result.json').read_text()),
                        'run': json.loads((destination / 'run/result.json').read_text())}
assert {str(path): digest(path) for path in dependencies} == before
report = {'variants': records, 'dependency_artifacts_before_after': before,
          'production_source': '023e584a0504c05e7db33c887de980671f096257',
          'scope': 'Actual unchanged production decoder with a local certificate include and exact production fonts; negative changes one data bit only. Not public-library execution or timing.'}
(root / 'result.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({name: row['run'] for name, row in records.items()}), flush=True)
