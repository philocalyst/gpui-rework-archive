from pathlib import Path
import hashlib, json, os, shutil, subprocess

root = Path('/tmp/gpui-canonical-text-control-sol')
fixture = Path('/tmp/gpui-canonical-text-public-control')
out = Path(__file__).parent / 'matched-release-codegen-final'
out.mkdir(exist_ok=True)
freeze = json.loads((out.parent / 'public-final-freeze.json').read_text())
pins = freeze['source_pins']
names = ['canonical-text-public-control', 'canonical-text-native-control']
flags = ['-C', 'symbol-mangling-version=v0', '--cfg', 'tokio_unstable']
targets = {'normal': Path('/tmp/gpui-canonical-text-release-target'),
           'codegen': Path('/tmp/gpui-canonical-text-codegen-target')}
cases = [(case, lane) for case in ['tiny', 'label', 'mixed', 'wrapped32k', 'long-grapheme'] for lane in ['idle', 'busy']]
dbus = '/nix/store/8snmq54bp5d5vp5dihgn7xr53hayx629-dbus-1.16.2/bin/dbus-run-session'
env = dict(os.environ)
for key in ['RUSTFLAGS', 'CARGO_ENCODED_RUSTFLAGS', 'RUSTC_BOOTSTRAP']:
    env.pop(key, None)
assert not [key for key in env if key.startswith('CARGO_PROFILE_')]
env.update(CARGO_BUILD_JOBS='1', DISPLAY=':115')

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def git(*args):
    return subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), *args], text=True)

def sources():
    paths = git('ls-files', '-z', '--', '.cargo', 'reactivity/Cargo.toml', 'reactivity/Cargo.lock',
                'reactivity/crates', 'reactivity/vendor').split('\0')
    return {name: sha(root / name) for name in paths if name and (root / name).is_file()}

def fixed():
    return {str(path.relative_to(fixture)): sha(path) for path in fixture.rglob('*') if path.is_file()}

assert fixed() == freeze['fixture_sha256']
assert not git('status', '--porcelain')
for target in targets.values():
    assert (target / '.canonical-text-owner').read_text() == 'visual_column_reuse_sol\n'

meta = {'status': 'building; NO timing', 'source_pins': pins, 'source_path': str(root),
        'fixture_path': str(fixture), 'fixture_sha256': fixed(), 'rootflags': flags,
        'features': ['native', 'simd'], 'default_features': False,
        'profile': 'opt3/noLTO/CGU1/debug0/stripnone', 'targets': {k: str(v) for k, v in targets.items()},
        'rustc': subprocess.check_output(['rustc', '-vV'], env=env, text=True),
        'cargo': subprocess.check_output(['cargo', '-vV'], env=env, text=True),
        'variants': {}, 'commands': []}
meta['runner_sha256'] = sha(Path(__file__))
shutil.copyfile(__file__, out / 'build_frozen_controls.py')

def save():
    (out / 'metadata.json').write_text(json.dumps(meta, indent=2) + '\n')

def run(name, argv, runenv):
    record = {'name': name, 'argv': argv}
    meta['commands'].append(record)
    with (out / (name + '.log')).open('w') as log:
        record['exit'] = subprocess.call(argv, cwd=root, env=runenv, stdout=log, stderr=subprocess.STDOUT)
    save()
    print(name, record['exit'], flush=True)
    assert record['exit'] == 0, name

def observed_native(path):
    value = next(json.loads(line) for line in path.read_text().splitlines() if line.startswith('{'))
    assert value['elapsed_ns'] == [] and value['host_ack_elapsed_ns'] == []
    assert value['failed_prepare_old_p_checked'] and value['provider_completed_cycles'] == 4
    # Exposure can repeat the same current token during startup. Keep the raw
    # callbacks, and compare exact unique epoch work separately.
    value['raw_ack_count'] = len(value['ack_epochs'])
    value['ack_epochs'] = [list(epoch) for epoch in dict.fromkeys(map(tuple, value['ack_epochs']))]
    return value

try:
    for label in ['baseline', 'candidate']:
        assert not git('status', '--porcelain')
        subprocess.run(['git', '-c', f'safe.directory={root}', '-C', str(root),
                        'checkout', '--detach', pins[label]], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        before = sources()
        variant = {'head': git('rev-parse', 'HEAD').strip(), 'source_files': before, 'builds': {}}
        meta['variants'][label] = variant
        save()
        for mode, target in targets.items():
            runenv = {**env, 'CARGO_TARGET_DIR': str(target)}
            expected_flags = flags + (['-Zemit-stack-sizes'] if mode == 'codegen' else [])
            cargo = ['cargo']
            if mode == 'codegen':
                runenv['RUSTC_BOOTSTRAP'] = '1'
                cargo += ['--config', 'build.rustflags=["-Zemit-stack-sizes"]']
            manifest = ['--manifest-path', str(fixture / 'Cargo.toml')]
            prefix = label + '-' + mode
            run(prefix + '-clean', cargo + ['clean', *manifest, '--offline', '--locked', '--release',
                '-p', 'gpui', '-p', 'gpui_canvas', '-p', 'canonical-text-public-control'], runenv)
            run(prefix + '-build', cargo + ['build', *manifest, '--offline', '--locked', '--release',
                '--no-default-features', '--features', 'native,simd',
                '--bin', names[0], '--bin', names[1], '--message-format=json-render-diagnostics', '-vv'], runenv)
            events = []
            for line in (out / (prefix + '-build.log')).read_text().splitlines():
                if line.startswith('{'):
                    try:
                        events.append(json.loads(line))
                    except ValueError:
                        pass
            artifacts = [event for event in events if event.get('reason') == 'compiler-artifact']
            assert not any('allocation_counter' in event['target']['name'] for event in artifacts)
            selected = [event for event in artifacts if event['target']['name'] in ['gpui', 'gpui_canvas', *names]]
            assert {event['target']['name'] for event in selected} == {'gpui', 'gpui_canvas', *names}
            assert all(not event['fresh'] for event in selected)
            gpui = next(event for event in selected if event['target']['name'] == 'gpui')
            assert {'simd', 'x11', 'accessibility'} <= set(gpui['features'])
            fingerprints = []
            for package, filename in [('gpui', 'lib-gpui.json'), ('gpui_canvas', 'lib-gpui_canvas.json'),
                    ('canonical-text-public-control', 'bin-canonical-text-public-control.json'),
                    ('canonical-text-public-control', 'bin-canonical-text-native-control.json')]:
                matched = []
                for path in (target / 'release/.fingerprint').glob(package + '-*/' + filename):
                    value = json.loads(path.read_text())
                    if value['rustflags'] == expected_flags:
                        matched.append({'path': str(path), 'sha256': sha(path), 'data': value})
                assert matched, (prefix, package, filename, 'missing rootflag fingerprint')
                fingerprints.extend(matched)
            build = {'target': str(target), 'rustflags': expected_flags, 'artifacts': selected,
                     'fingerprints': fingerprints, 'binaries': {}, 'native_oracle': {}}
            variant['builds'][mode] = build
            for name in names:
                source = target / 'release' / name
                binary = out / (prefix + '-' + name)
                shutil.copyfile(source, binary)
                binary.chmod(0o555)
                build['binaries'][name] = {'path': str(binary), 'sha256': sha(binary), 'bytes': binary.stat().st_size}
            save()
            run(prefix + '-public-oracle', [build['binaries'][names[0]]['path'], 'oracle'], runenv)
            for case, lane in cases:
                oracle = prefix + '-native-' + case + '-' + lane
                run(oracle, [dbus, '--', build['binaries'][names[1]]['path'], 'oracle', case, lane, '4'], runenv)
                build['native_oracle'][case + '-' + lane] = observed_native(out / (oracle + '.log'))
            assert sources() == before and fixed() == meta['fixture_sha256']
            assert all(sha(Path(item['path'])) == item['sha256'] for item in build['binaries'].values())
            assert not git('status', '--porcelain')
            build['sources_fixture_binaries_unchanged'] = True
            save()
    gold = (out / 'baseline-normal-public-oracle.log').read_bytes()
    gold_native = meta['variants']['baseline']['builds']['normal']['native_oracle']
    for label in ['baseline', 'candidate']:
        for mode in targets:
            assert (out / (label + '-' + mode + '-public-oracle.log')).read_bytes() == gold
            native = meta['variants'][label]['builds'][mode]['native_oracle']
            for case, expected in gold_native.items():
                assert {k: v for k, v in native[case].items() if k != 'raw_ack_count'} == {
                    k: v for k, v in expected.items() if k != 'raw_ack_count'}, (label, mode, case)
    meta['status'] = 'complete; matched oracle/source/rootflag guards PASS; NO timing'
    save()
except BaseException as error:
    meta['status'] = 'failed; no timing'
    meta['failure'] = repr(error)
    save()
    raise
finally:
    assert not git('status', '--porcelain')
    subprocess.run(['git', '-c', f'safe.directory={root}', '-C', str(root),
                    'checkout', '--detach', pins['candidate']], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    meta['restored_candidate'] = git('rev-parse', 'HEAD').strip() == pins['candidate'] and not git('status', '--porcelain')
    save()
