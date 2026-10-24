from pathlib import Path
import fcntl, hashlib, json, os, re, shutil, signal, subprocess, time, traceback

p = Path('/Users/mileswirht/gpui-reactivity-20261024-root/component-3fc07815-sol')
top = p.parent
source = p / 'source'
out = p / 'qualification'
out.mkdir()
prefix = top / 'nightly-2026-10-23'
child = None
status = dict(state='waiting-serial-lock', source='3fc07815a0ce389db54e492dd1d889c6fca10699', pid=os.getpid(), gates=[], binaries=[], results=[], scope='Exact compound component/Length/binding composition on Reader/Remote/GPU957; full actual Darwin native GPUI and component tests, strict all-target native checks, docs and Halloween build. IME successor remains separate. No UI permission request, fabricated input, physical capture or service restart.')
manifest = json.loads((source / 'source-manifest.json').read_text())
assert len(manifest) == 2089
sha = lambda q: hashlib.sha256(q.read_bytes()).hexdigest()

def save():
    temp = out / 'status.tmp'
    temp.write_text(json.dumps(status, indent=2) + '\n')
    temp.replace(out / 'status.json')

def check():
    actual={name:sha(source/name) for name in manifest}
    assert actual==manifest, [name for name in manifest if actual[name]!=manifest[name]]
    return dict(source=status['source'],aggregate=hashlib.sha256(json.dumps(actual,sort_keys=True).encode()).hexdigest(),files=actual)

def run(argv, name, timeout=1800):
    global child
    (out/(name+'.before.json')).write_text(json.dumps(check(),indent=2)+chr(10))
    assert shutil.disk_usage(p).free > 20 * 1024**3, '20 GiB storage floor'
    (out / (name + '.command.json')).write_text(json.dumps(dict(argv=argv, cwd=str(source)), indent=2) + '\n')
    started = time.monotonic()
    with (out / (name + '.stdout')).open('w') as stdout, (out / (name + '.stderr')).open('w') as stderr:
        child = subprocess.Popen(argv, cwd=source, env=environment, stdout=stdout, stderr=stderr, start_new_session=True)
        while child.poll() is None:
            assert shutil.disk_usage(p).free > 20 * 1024**3, '20 GiB storage floor'
            assert time.monotonic() - started < timeout, ('timeout', name)
            time.sleep(.5)
        code = child.wait()
    (out/(name+'.after.json')).write_text(json.dumps(check(),indent=2)+chr(10))
    status['gates'].append(dict(name=name, exit=code, seconds=time.monotonic()-started))
    save()
    return code

def cargo(arguments):
    return [str(prefix / 'bin/cargo'), *arguments, '--manifest-path', str(source / 'reactivity/Cargo.toml'), '--locked', '--offline', '-Z', 'checksum-freshness', '--config', 'build.fingerprint="content"']

def freeze(name, tests):
    rows = [json.loads(line) for line in (out / (name + '.stdout')).read_text().splitlines()]
    artifacts = [row for row in rows if row.get('reason') == 'compiler-artifact' and row.get('executable') and (not tests or row['profile']['test'])]
    assert artifacts and all(not row['fresh'] for row in artifacts), 'all actual executables must rebuild'
    if tests:
        for library in ['gpui', 'gpui_component']:
            libs = [row for row in rows if row.get('reason') == 'compiler-artifact' and row['target']['name'] == library and not row['profile']['test']]
            assert libs and all(not row['fresh'] for row in libs), ('library must rebuild', library)
        assert len(artifacts) > 65
    result = []
    for i, row in enumerate(artifacts):
        original = Path(row['executable'])
        target = out / (name + '-' + str(i) + '-' + row['target']['name'])
        original.rename(target)
        target.chmod(0o555)
        record = dict(name=row['target']['name'], file=target.name, sha256=sha(target), bytes=target.stat().st_size, cargo=row)
        (out / (target.name + '.binary.json')).write_text(json.dumps(record, indent=2) + '\n')
        result.append(record)
    check()
    return result

try:
    save()
    check()
    environment = os.environ.copy()
    for key in ['RUSTFLAGS', 'CARGO_ENCODED_RUSTFLAGS', 'RUSTC_BOOTSTRAP']:
        environment.pop(key, None)
    environment.update(PATH=str(prefix/'bin')+':'+environment['PATH'], RUSTC=str(prefix/'bin/rustc'), RUSTDOC=str(prefix/'bin/rustdoc'), CARGO_HOME=str(top/'cargo-home'), CARGO_TARGET_DIR=str(top/'target-nightly'), CARGO_BUILD_JOBS='4', CARGO_INCREMENTAL='0', CARGO_PROFILE_DEV_DEBUG='0', CARGO_PROFILE_TEST_DEBUG='0')
    (out/'initial-source.json').write_text(json.dumps(check(),indent=2)+chr(10))
    (out/'toolchain.txt').write_text(subprocess.check_output([str(prefix/'bin/rustc'), '-Vv'], env=environment, text=True) + subprocess.check_output([str(prefix/'bin/cargo'), '-V'], env=environment, text=True))
    (out/'platform.json').write_text(json.dumps(dict(uname=list(os.uname()), initial_free=shutil.disk_usage(p).free), indent=2)+'\n')
    with (top/'host.lock').open('a') as lease:
        # Exclusive for clean, compilation, freezing AND execution: a shared
        # compile lease can otherwise delete another job's not-yet-frozen ELF.
        fcntl.flock(lease, fcntl.LOCK_EX)
        status['state'] = 'cleaning-first-party-dev'
        save()
        names = ['gpui', 'gpui-component', 'gpui_canvas', 'gpui_gpu', 'gpui_inline_call', 'gpui_reactivity_core', 'gpui_reactivity_state', 'gpui_reactivity_host']
        clean = [str(prefix/'bin/cargo'), 'clean', '--manifest-path', str(source/'reactivity/Cargo.toml'), '--profile', 'dev']
        for name in names:
            clean += ['-p', name]
        assert run(clean, 'clean-first-party-dev') == 0
        status['state'] = 'building-full-native'
        save()
        assert run(cargo(['test', '-p', 'gpui', '-p', 'gpui-component', '--features', 'native', '--lib', '--tests', '--no-run', '--message-format=json']), 'full-native-build') == 0
        status['binaries'] = freeze('full-native-build', True)
        status['state'] = 'executing-full-native'
        save()
        for i, record in enumerate(status['binaries']):
            binary = out / record['file']
            assert sha(binary) == record['sha256']
            code = run([str(binary), '--nocapture', '--test-threads=1'], 'native-run-'+str(i), 240)
            counts = re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored;', (out/('native-run-'+str(i)+'.stdout')).read_text())
            result = dict(binary=record['file'], name=record['name'], exit=code)
            if len(counts) == 1:
                result.update(zip(('passed','failed','ignored'), map(int,counts[0])))
            else:
                result['missing_harness_result'] = True
            assert sha(binary) == record['sha256']
            status['results'].append(result)
            save()
        status['state'] = 'building-native-app'
        save()
        app_code = run(cargo(['build', '-p', 'gpui-component', '--features', 'native', '--example', 'halloween', '--message-format=json']), 'native-app-build')
        status['application'] = freeze('native-app-build', False) if app_code == 0 else []
        status['state'] = 'strict-native-and-docs'
        save()
        run(cargo(['clippy', '-p', 'gpui', '-p', 'gpui-component', '--features', 'native', '--all-targets', '--message-format=json']) + ['--','-D','warnings'], 'strict-native-clippy')
        run(cargo(['test', '-p', 'gpui', '-p', 'gpui-component', '--features', 'native', '--doc']), 'native-docs')
        check()
        for record in status['binaries'] + status['application']:
            assert sha(out/record['file']) == record['sha256']
        (out/'final-source.json').write_text(json.dumps(check(),indent=2)+chr(10))
        status.update(state='complete', source_hashes_match=True, binary_hashes_match=True, final_free=shutil.disk_usage(p).free, passed=sum(x.get('passed',0) for x in status['results']), failed=sum(x.get('failed',0) for x in status['results']), ignored=sum(x.get('ignored',0) for x in status['results']), native_all_exit_zero=all(x['exit']==0 and not x.get('missing_harness_result') for x in status['results']), all_gates_exit_zero=all(x['exit']==0 for x in status['gates']))
        save()
except BaseException:
    if child is not None and child.poll() is None:
        os.killpg(child.pid, signal.SIGTERM)
        try:
            child.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid, signal.SIGKILL)
            child.wait()
    status.update(state='failed', error=traceback.format_exc())
    save()
