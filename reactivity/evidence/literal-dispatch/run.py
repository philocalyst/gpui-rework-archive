#!/usr/bin/env python3
"""Frozen same-caller direct-executable controls; never invokes a compiler."""
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
    'f019': ('/root/gpui-style-startup-base', 'f01947e679d9dd2ca7ef149b70dccff92dad67dc', '/tmp/gpui-style-startup-base-build.jsonl', 'f019'),
    'baseline': ('/root/gpui-literal-dispatch-base', '09a9a229f114df7db203e6d12f81947dca923e41', '/tmp/gpui-literal-dispatch-base-build.jsonl', 'baseline-09a9'),
    'candidate': ('/root/gpui-literal-dispatch', '582bca7cd0a2836a86c21f82e52cd55515e14d88', '/tmp/gpui-literal-dispatch-final-build.jsonl', 'literal-dispatch'),
}

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def command(args):
    return subprocess.check_output(args, text=True)

def source(tag):
    root, pin, _, _ = PINS[tag]
    assert command(['git', '-C', root, 'rev-parse', 'HEAD']).strip() == pin
    paths = ['reactivity/crates/gpui/src/element.rs', 'reactivity/crates/gpui/src/property.rs', 'reactivity/crates/gpui/src/style.rs', 'reactivity/crates/core/src/geometry.rs', 'reactivity/Cargo.lock', 'reactivity/crates/gpui/examples/literal_startup.rs']
    if tag != 'f019':
        paths.append('reactivity/crates/gpui/src/style_port.rs')
    assert not command(['git', '-C', root, 'diff', '--name-only', '--'] + paths).strip()
    caller = Path(root) / paths[-2 if tag != 'f019' else -1]
    assert sha(caller) == sha(HERE / 'fixtures/literal_startup.rs')
    return {path: sha(Path(root) / path) for path in paths}

def parse(path, tag, capture):
    text = Path(path).read_text()
    assert f'pin,{PINS[tag][3]},{PINS[tag][1]}' in text
    guards = [line for line in text.splitlines() if line.startswith('guard,')]
    costs = [next(csv.reader([line])) for line in text.splitlines() if line.startswith('cost,')]
    assert len(guards) == (7 if capture else 6)
    assert len(costs) == (12 if capture else 0)
    return guards

def freeze():
    result = {'runner': sha(__file__), 'fixture': sha(HERE / 'fixtures/literal_startup.rs'), 'variants': {}}
    oracles = []
    for tag, (_, _, build, _) in PINS.items():
        rows = [json.loads(line) for line in Path(build).read_text().splitlines() if line.startswith('{')]
        artifacts = [r for r in rows if r.get('reason') == 'compiler-artifact' and r['target']['name'] == 'literal_startup']
        assert len(artifacts) == 1
        art = artifacts[0]
        assert not art['fresh'] and art['profile']['opt_level'] == '3'
        assert str(Path(PINS[tag][0]) / 'reactivity/crates/gpui') in art['package_id']
        libs = [r for r in rows if r.get('reason') == 'compiler-artifact' and r['target']['name'] == 'gpui' and 'lib' in r['target']['kind']]
        assert len(libs) == 1
        # The supplementary f019 executable is the unchanged historical artifact.
        # The matched baseline and candidate both rebuild their own root library.
        assert tag == 'f019' or not libs[0]['fresh']
        if tag == 'f019':
            old = json.loads(Path('/root/gpui-style-batch/reactivity/evidence/style-batch/frozen.json').read_text())
            assert sha(art['executable']) == old['executables']['literal-f019']['sha256']
        files = {build: sha(build), art['executable']: sha(art['executable'])}
        for path in libs[0]['filenames']:
            files[path] = sha(path)
        result['variants'][tag] = {'source': source(tag), 'files': files, 'binary': art['executable']}
        oracles.append(parse(HERE / 'logs' / f'{tag}-guard.txt', tag, False))
    assert oracles[0] == oracles[1] == oracles[2]
    (HERE / 'frozen.json').write_text(json.dumps(result, indent=2) + '\n')
    print('FROZEN')

def guard():
    result = json.loads((HERE / 'frozen.json').read_text())
    assert result['runner'] == sha(__file__)
    assert result['fixture'] == sha(HERE / 'fixtures/literal_startup.rs')
    for tag, variant in result['variants'].items():
        assert source(tag) == variant['source']
        for path, checksum in variant['files'].items():
            assert sha(path) == checksum, path
    return result

def environment():
    processes = command(['ps', '-eo', 'pid,stat,pcpu,comm'])
    for line in processes.splitlines()[1:]:
        fields = line.split()
        if len(fields) == 4 and not any(state in fields[1] for state in 'TZ'):
            assert not fields[3].startswith(('cargo', 'rustc', 'clippy', 'zig', 'rust-lld')), line
    return {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'processes': processes,
            **{f'{kind}_pressure': Path(f'/proc/pressure/{kind}').read_text() for kind in ['cpu', 'io', 'memory']}}

def capture(output, rounds):
    assert os.environ.get('LITERAL_DISPATCH_QUIET') == 'approved'
    frozen = guard()
    assert 2 in os.sched_getaffinity(0)
    os.sched_setaffinity(0, {2})
    output.mkdir(parents=True, exist_ok=False)
    (output / 'frozen.json').write_text(json.dumps(frozen, indent=2) + '\n')
    (output / 'before.json').write_text(json.dumps(environment(), indent=2) + '\n')
    end = time.monotonic() + 90
    elapsed_rows = []
    for number in range(rounds):
        tags = list(PINS)
        tags = tags[number % len(tags):] + tags[:number % len(tags)]
        oracle = None
        for tag in tags:
            guard()
            start = time.monotonic()
            assert start < end
            path = output / f'round-{number+1}-{tag}.txt'
            print('START', number+1, tag, flush=True)
            env = dict(os.environ, STYLE_STARTUP_CAPTURE='approved', STYLE_STARTUP_COLD_COUNT='139')
            with path.open('w') as stream:
                result = subprocess.run([frozen['variants'][tag]['binary'], 'capture'], env=env, stdout=stream, stderr=subprocess.STDOUT, timeout=end-start)
            elapsed = time.monotonic()-start
            assert result.returncode == 0, path
            guard()
            current = parse(path, tag, True)
            if oracle is None:
                oracle = current
            assert current == oracle
            elapsed_rows.append({'round': number+1, 'variant': tag, 'wall_seconds': elapsed})
            print('FINISHED', number+1, tag, elapsed, flush=True)
    (output / 'elapsed.json').write_text(json.dumps(elapsed_rows, indent=2) + '\n')
    (output / 'after.json').write_text(json.dumps(environment(), indent=2) + '\n')
    print('ALL_POSTGUARDS_PASS', flush=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['freeze', 'guard', 'capture'])
    parser.add_argument('--output', type=Path)
    parser.add_argument('--rounds', type=int, default=3)
    args = parser.parse_args()
    if args.mode == 'freeze':
        freeze()
    elif args.mode == 'guard':
        guard()
        print('ALL_GUARDS_PASS')
    else:
        assert args.output is not None and args.rounds > 0
        capture(args.output, args.rounds)
