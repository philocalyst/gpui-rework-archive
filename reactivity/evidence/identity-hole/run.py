#!/usr/bin/env python3
"""Five matched public callers; no compiler or excluded/retried sample paths."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
PINS = {
    'baseline': ('/root/gpui-identity-index-base', '59467a4136d92822e90dfcff329383c75f9c3c33', 'base'),
    'packed': ('/root/gpui-identity-index', '8da013d5f81d2687d9fdc7321f91109713e1e6c1', 'packed'),
    'runs': ('/root/gpui-identity-runs', '75544537f7596a7e0929306ab27b48f9942b7062', 'runs'),
    'inline': ('/root/gpui-identity-inline', 'f251f4be7bc215644859df8ee2f70a0f104f8d36', 'inline'),
    'hole': ('/root/gpui-identity-hole-hot', 'db04a211c5ba7a1d13647c2a62a03ec350adb5a9', 'hole-hot'),
}
CODE = ['reactivity/crates/gpui/src', 'reactivity/crates/gpui/Cargo.toml',
        'reactivity/crates/core', 'reactivity/crates/canvas',
        'reactivity/Cargo.toml', 'reactivity/Cargo.lock']
OLD = Path('/root/gpui-identity-inline/reactivity/evidence/identity-inline/frozen.json')

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def command(args):
    return subprocess.check_output(args, text=True)

def source(tag):
    root, pin, _ = PINS[tag]
    subprocess.run(['git', '-C', root, 'merge-base', '--is-ancestor', pin, 'HEAD'], check=True)
    assert not command(['git', '-C', root, 'diff', pin, '--', *CODE]).strip(), tag
    caller = Path(root) / 'reactivity/crates/gpui/examples/identity_inline_control.rs'
    assert sha(caller) == sha(HERE / 'fixtures/owner.rs')
    return {'pin': pin, 'caller': sha(caller)}

def parse(path, tag, capture):
    lines = Path(path).read_text().splitlines()
    assert f'pin,{tag},{PINS[tag][1]}' in lines
    rows = [next(csv.reader([line])) for line in lines if line.startswith('cost,')]
    guards = sorted(line for line in lines if line.startswith('guard,'))
    assert len(rows) == 36 and len(guards) == 40, (path, len(rows), len(guards))
    if capture:
        for row in rows:
            count, operations = int(row[2]), int(row[3])
            if '-lookup-' in row[1]:
                actual_len = count + (2 if row[1].startswith('gapped') else 1)
                expected = max(16, (65_536 + actual_len - 1) // actual_len) * actual_len
                assert operations == expected and operations >= 65_536, row
    return guards

def freeze():
    old = json.loads(OLD.read_text())
    for artifact in old['executables'].values():
        assert sha(artifact['path']) == artifact['sha256']
    result = {'runner': sha(__file__), 'fixture': sha(HERE / 'fixtures/owner.rs'),
              'sources': {}, 'executables': {}, 'files': {}, 'producers': {}}
    oracles = []
    for tag, (root, _, prefix) in PINS.items():
        result['sources'][tag] = source(tag)
        build = Path(f'/tmp/gpui-idnorm-{prefix}-build.jsonl')
        artifacts = [json.loads(line) for line in build.read_text().splitlines() if line.startswith('{')]
        libs = [a for a in artifacts if a.get('reason') == 'compiler-artifact' and a['target']['kind'] == ['lib'] and a['target']['name'] == 'gpui']
        callers = [a for a in artifacts if a.get('reason') == 'compiler-artifact' and a['target']['name'] == 'identity_inline_control']
        assert len(libs) == len(callers) == 1
        lib, caller = libs[0], callers[0]
        assert not caller['fresh'] and caller['profile']['opt_level'] == '3'
        assert caller['package_id'].startswith('path+file://' + root + '/reactivity/crates/gpui#')
        assert lib['profile']['opt_level'] == '3'
        if tag == 'hole':
            assert not lib['fresh']
        else:
            # Reuse all four earlier normalized producers exactly. Their warm
            # cache/fresh-build provenance remains in the preceding manifest.
            assert lib['fresh'] == old['producers'][tag]['root_library_fresh']
            assert sha(build) == old['files'][str(build)]
            for path in lib['filenames']:
                assert sha(path) == old['files'][path]
            assert sha(caller['executable']) == old['executables'][tag]['sha256']
        result['producers'][tag] = {'root_library_fresh': lib['fresh'], 'profile': caller['profile'],
                                    'features': caller['features'], 'package_id': caller['package_id']}
        binary = caller['executable']
        result['executables'][tag] = {'path': binary, 'sha256': sha(binary)}
        for path in [build, *lib['filenames']]:
            result['files'][str(path)] = sha(path)
        oracles.append(parse(f'/tmp/gpui-idnorm-{prefix}-guard.log', tag, False))
    assert all(o == oracles[0] for o in oracles)
    result['old_frozen'] = sha(OLD)
    (HERE / 'frozen.json').write_text(json.dumps(result, indent=2) + '\n')
    print('FROZEN; five complete pixel/bounds/membership oracles agree')

def guard():
    frozen = json.loads((HERE / 'frozen.json').read_text())
    assert frozen['runner'] == sha(__file__)
    assert frozen['fixture'] == sha(HERE / 'fixtures/owner.rs')
    assert frozen['old_frozen'] == sha(OLD)
    for tag in PINS:
        assert source(tag) == frozen['sources'][tag]
    for artifact in frozen['executables'].values():
        assert sha(artifact['path']) == artifact['sha256']
    for path, checksum in frozen['files'].items():
        assert sha(path) == checksum, path
    return frozen

def environment():
    processes = command(['ps', '-eo', 'pid,stat,pcpu,comm'])
    for line in processes.splitlines()[1:]:
        fields = line.split()
        if len(fields) == 4 and not any(state in fields[1] for state in 'TZ'):
            assert not fields[3].startswith(('cargo', 'rustc', 'clippy', 'zig', 'rust-lld')), line
    return {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'processes': processes,
            **{f'{k}_pressure': Path(f'/proc/pressure/{k}').read_text() for k in ['cpu', 'io', 'memory']}}

def capture(output):
    assert os.environ.get('IDENTITY_INDEX_QUIET') == 'approved', 'wait for coordinated START'
    frozen = guard()
    assert 2 in os.sched_getaffinity(0)
    os.sched_setaffinity(0, {2})
    output.mkdir(parents=True, exist_ok=False)
    (output / 'frozen.json').write_text(json.dumps(frozen, indent=2) + '\n')
    (output / 'before.json').write_text(json.dumps(environment(), indent=2) + '\n')
    deadline = time.monotonic() + 180
    elapsed = []
    for number in range(5):
        tags = list(PINS)
        tags = tags[number:] + tags[:number]
        oracle = None
        for tag in tags:
            guard()
            start = time.monotonic()
            assert start < deadline
            print('START', number + 1, tag, flush=True)
            path = output / f'owner-{number + 1}-{tag}.txt'
            with path.open('w') as stream:
                result = subprocess.run([frozen['executables'][tag]['path'], 'capture'],
                                        stdout=stream, stderr=subprocess.STDOUT, timeout=deadline-start)
            seconds = time.monotonic() - start
            assert result.returncode == 0, path
            guard()
            current = parse(path, tag, True)
            if oracle is None:
                oracle = current
            assert current == oracle
            elapsed.append({'round': number + 1, 'variant': tag, 'wall_seconds': seconds})
            print('FINISHED', number + 1, tag, f'{seconds:.4f}', flush=True)
    (output / 'elapsed.json').write_text(json.dumps(elapsed, indent=2) + '\n')
    (output / 'after.json').write_text(json.dumps(environment(), indent=2) + '\n')
    print('ALL_POSTGUARDS_PASS; all900costrows retained', flush=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['freeze', 'guard', 'capture'])
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    if args.mode == 'freeze':
        freeze()
    elif args.mode == 'guard':
        guard()
        print('ALL_GUARDS_PASS')
    else:
        assert args.output is not None
        capture(args.output)
