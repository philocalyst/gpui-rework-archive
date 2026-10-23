"""Syn/Tokei final vendor geometry and separately charged experiment support."""
from pathlib import Path
import hashlib, json, subprocess, sys, tempfile
root = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(root / 'reactivity/tools'))
import inventory, core_lines
helper = Path('/tmp/gpui-inventory-sol-target/release/inventory-rust')
tokei = Path('/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei')
source = 'reactivity/vendor/parley/src/editing/geometry.rs'
data = inventory.git('show', '62e4047420:' + source, binary=True)
analysis = inventory.rust_analysis([(source, data, 'Rust')], helper)[source]
with tempfile.TemporaryDirectory() as folder:
    path = Path(folder) / 'geometry.rs'
    path.write_text(core_lines.without_tests(data.decode(), analysis['test_ranges']))
    counts = json.loads(subprocess.check_output([str(tokei), '--no-ignore', '--output', 'json', str(path)], text=True))
support = sorted(p for p in Path(__file__).parent.parent.rglob('*') if p.suffix in ['.rs', '.py'])
support_counts = json.loads(subprocess.check_output([str(tokei), '--no-ignore', '--files', '--output', 'json', *map(str, support)], text=True))
result = dict(source='62e4047420', path=source, sha256=hashlib.sha256(data).hexdigest(), geometry_code=counts['Rust']['code'], analysis=analysis, support=support_counts, helper_sha256=hashlib.sha256(helper.read_bytes()).hexdigest(), tokei_sha256=hashlib.sha256(tokei.read_bytes()).hexdigest())
(Path(__file__).parent / 'source-ledger.json').write_text(json.dumps(result, indent=2) + '\n')
print(result['geometry_code'])
