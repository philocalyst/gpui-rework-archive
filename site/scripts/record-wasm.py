#!/usr/bin/env python3
"""Record which source and distributions belong to a completed WASM build."""
from pathlib import Path
import hashlib
import json
site = Path(__file__).resolve().parents[1]
paths = [site / name for name in [
    'wasm/src/lib.rs',
    'wasm/Cargo.toml',
    'wasm/Cargo.lock',
    'wasm/gpui-demo/src/main.rs',
    'wasm/gpui-demo/Cargo.toml',
    'wasm/gpui-demo/Cargo.lock',
    'wasm/gpui-demo/index.html',
    'static/wasm/gpui_examples.wasm',
]]
paths += sorted((site/'static/components/gpui-demo').glob('*'))
manifest = {str(p.relative_to(site)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths if p.is_file()}
(site/'wasm-build-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
print(f'Recorded {len(manifest)} WASM source and distribution fingerprints.')
