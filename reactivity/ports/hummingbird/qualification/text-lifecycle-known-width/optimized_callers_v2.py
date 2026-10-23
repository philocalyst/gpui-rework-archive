import hashlib
import json
import pathlib
import subprocess

root = pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence')
out = root / 'known-qualification'
target = pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-target/release/deps')
controls = {
    'baseline': root / 'same-path-control/baseline-constructor-whole-artifacts',
    'candidate': out / 'constructor-artifacts',
}
sources = ['mixed-caller-v2', 'public-geometry-cost-v2']

def digest(path):
    return hashlib.file_digest(path.open('rb'), 'sha256').hexdigest()

for name, directory in controls.items():
    manifest = json.loads(directory.with_suffix('.json').read_text())
    by_target = {entry['target']: directory / file for file, entry in manifest.items()}
    for file, entry in manifest.items():
        assert digest(directory / file) == entry['sha256']
    for fixture in sources:
        source = out / fixture / 'main.rs'
        freeze = json.loads((out / fixture / 'source-freeze.json').read_text())
        assert digest(source) == freeze['sha256']
        destination = out / fixture / name
        destination.mkdir(exist_ok=False)
        binary = destination / fixture
        command = [
            'rustc', '--edition=2024', '-Copt-level=3', '-Cdebuginfo=0',
            '-Cembed-bitcode=no', '-Csymbol-mangling-version=v0',
            '--cfg', 'tokio_unstable', '-L', 'dependency=' + str(directory),
            '-L', 'dependency=' + str(target),
        ]
        if fixture == 'mixed-caller-v2':
            command += ['--extern', 'gpui_reactivity_core=' + str(by_target['gpui_reactivity_core'])]
            if name == 'candidate':
                command += ['--cfg', 'candidate']
        else:
            for dependency in ['gpui', 'gpui_canvas']:
                command += ['--extern', dependency + '=' + str(by_target[dependency])]
            log = root / 'same-path-control/constructor-baseline-build.jsonl'
            artifacts = [json.loads(line) for line in log.read_text().splitlines() if line.startswith('{')]
            counter = [row for row in artifacts if row.get('reason') == 'compiler-artifact' and row['target']['name'] == 'allocation_counter']
            assert len(counter) == 1
            library = next(pathlib.Path(path) for path in counter[0]['filenames'] if path.endswith('.rlib'))
            command += ['--extern', 'allocation_counter=' + str(library)]
        command += [str(source), '-o', str(binary)]
        record = {'command': command, 'source_sha256': digest(source), 'artifact_manifest': str(directory.with_suffix('.json'))}
        (destination / 'compile.command.json').write_text(json.dumps(record, indent=2) + '\n')
        with (destination / 'compile.log').open('wb') as log:
            compiled = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT)
        (destination / 'compile.exit').write_text(str(compiled.returncode) + '\n')
        if compiled.returncode:
            raise SystemExit(compiled.returncode)
        record['binary_sha256'] = digest(binary)
        binary.chmod(0o555)
        invocation = ['timeout', '--signal=TERM', '--kill-after=5s', '60s', str(binary)]
        record['runtime_command'] = invocation
        with (destination / 'runtime.log').open('wb') as log:
            runtime = subprocess.run(invocation, stdout=log, stderr=subprocess.STDOUT)
        record['runtime_exit'] = runtime.returncode
        record['binary_after_sha256'] = digest(binary)
        assert record['binary_after_sha256'] == record['binary_sha256']
        (destination / 'capture.json').write_text(json.dumps(record, indent=2) + '\n')
        if runtime.returncode:
            raise SystemExit(runtime.returncode)
