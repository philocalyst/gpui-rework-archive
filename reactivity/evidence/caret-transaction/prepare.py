#!/usr/bin/env python3
"""Prepare pinned production Parley modules plus separately recorded private tests."""
import argparse
import hashlib
import json
import pathlib
import subprocess
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--repo', type=pathlib.Path, required=True)
parser.add_argument('--ref', required=True)
parser.add_argument('--output', type=pathlib.Path, required=True)
args = parser.parse_args()
fixture = pathlib.Path(__file__).resolve().parent
subprocess.run([sys.executable, str(fixture.parent / 'monotonic-caret-span/prepare.py'),
                '--repo', str(args.repo), '--ref', args.ref, '--output', str(args.output), '--stream'], check=True)
sha = lambda data: hashlib.sha256(data).hexdigest()
for name in ['transaction_tests.rs']:
    (args.output / 'src/tests' / name).write_bytes((fixture / name).read_bytes())
with (args.output / 'src/tests/mod.rs').open('a') as module:
    module.write('pub(crate) mod transaction_tests;\n')
geometry = args.output / 'src/editing/geometry.rs'
production = geometry.read_bytes()
suffix = (fixture / 'state_tests.rs').read_bytes()
geometry.write_bytes(production + suffix)
provenance = json.loads((args.output / 'provenance.json').read_text())
provenance.update(partial_tests={name: sha((fixture / name).read_bytes()) for name in ['transaction_tests.rs', 'state_tests.rs']},
                  geometry_test_suffix_bytes=len(suffix), geometry_production_prefix_sha256=sha(production),
                  focused_test_filter='tests:: --skip layout:: --skip resolve::')
# Every production file equals the requested immutable pin. The geometry file
# differs only by the separately hashed cfg(test) child, never in its prefix.
for name, digest in provenance['copied_source_sha256'].items():
    if not name.startswith('reactivity/vendor/parley/') or not name.endswith('.rs'):
        continue
    relative = name.removeprefix('reactivity/vendor/parley/')
    if relative == 'src/tests/mod.rs':
        continue
    data = (args.output / relative).read_bytes()
    if relative == 'src/editing/geometry.rs':
        data = data[:-len(suffix)]
    assert sha(data) == digest, name
(args.output / 'provenance.json').write_text(json.dumps(provenance, indent=2) + '\n')
