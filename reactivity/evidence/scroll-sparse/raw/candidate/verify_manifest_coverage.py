from pathlib import Path
import json
root=Path(__file__).resolve().parents[2]
manifest=json.loads((root/'manifest.json').read_text())
actual={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p!=root/'manifest.json'}
assert set(manifest)==actual,(sorted(actual-set(manifest)),sorted(set(manifest)-actual))
print('complete manifest coverage',len(actual),'files')
