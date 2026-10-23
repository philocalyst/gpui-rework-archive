"""Count authored source separately from first-party shipping libraries, using Syn/Tokei."""
import hashlib
import json
import pathlib
import subprocess
import sys
import tempfile

root = pathlib.Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / 'reactivity/tools'))
import core_lines
import inventory

helper = pathlib.Path('/tmp/gpui-inventory-sol-target/release/inventory-rust')
tokei = pathlib.Path('/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei')
files = ['reactivity/crates/canvas/src/text/planner.rs',
         'reactivity/vendor/parley/src/editing/geometry.rs',
         'reactivity/vendor/parley/src/editing/mod.rs',
         'reactivity/vendor/parley/src/layout/run.rs']
rows = {}
for ref in ['1d5bc3061cce3beb3c4857102ed651da501b5cfd', '81bd9e53b7a18161903dad3816d494ed1afdfce3', '8d81d28bc4']:
    sources = [(path, inventory.git('show', f'{ref}:{path}', binary=True), 'Rust') for path in files]
    analyses = inventory.rust_analysis(sources, helper)
    rows[ref] = {}
    with tempfile.TemporaryDirectory(prefix='caret-transaction-lines-') as temporary:
        for path, data, _ in sources:
            stripped = core_lines.without_tests(data.decode(), analyses[path]['test_ranges'])
            target = pathlib.Path(temporary) / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(stripped)
        counts = json.loads(subprocess.check_output([str(tokei), '--no-ignore', '--files', '--output', 'json', temporary], text=True))
        for report in counts['Rust']['reports']:
            path = str(pathlib.Path(report['name']).relative_to(temporary))
            rows[ref][path] = dict(code=report['stats']['code'], sha256=hashlib.sha256(dict((p,d) for p,d,_ in sources)[path]).hexdigest(), unclassified=analyses[path]['unclassified'])
support = [path for path in pathlib.Path(__file__).parent.iterdir() if path.suffix in ['.py', '.rs']]
support_counts = json.loads(subprocess.check_output([str(tokei), '--no-ignore', '--files', '--output', 'json', *map(str,support)], text=True))
output = dict(helper_sha256=hashlib.sha256(helper.read_bytes()).hexdigest(), tokei_sha256=hashlib.sha256(tokei.read_bytes()).hexdigest(), revisions=rows, evidence_support=support_counts)
(pathlib.Path(__file__).parent / 'ast-source-ledger.json').write_text(json.dumps(output, indent=2) + '\n')
print(json.dumps({ref: {p:r['code'] for p,r in paths.items()} for ref,paths in rows.items()}, indent=2))
