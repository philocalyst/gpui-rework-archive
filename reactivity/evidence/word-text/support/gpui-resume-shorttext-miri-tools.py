from pathlib import Path
import hashlib
import json
import subprocess

out = Path('/tmp/gpui-shorttext-miri-provision')
adaptation = json.loads(Path('/tmp/gpui-nightly-provision-2026-10-23/nix-loader-adaptation.json').read_text())['files'][0]
patchelf = '/nix/store/if2h609psbpg1ysf1m27dpshjk2wzpk4-patchelf-0.15.2/bin/patchelf'
records = []
for binary in sorted(Path('/tmp/gpui-shorttext-miri-tools/bin').iterdir()):
    raw = binary.read_bytes()
    original = out / 'unpacked/miri-nightly-x86_64-unknown-linux-gnu/miri-preview/bin' / binary.name
    assert raw == original.read_bytes(), binary
    old_text = out / (binary.name + '-text-before')
    new_text = out / (binary.name + '-text-after')
    subprocess.run(['objcopy', '--dump-section', f'.text={old_text}', str(binary)], check=True)
    subprocess.run([patchelf, '--set-interpreter', adaptation['interpreter'], '--set-rpath', adaptation['new_rpath'], str(binary)], check=True)
    subprocess.run(['objcopy', '--dump-section', f'.text={new_text}', str(binary)], check=True)
    assert old_text.read_bytes() == new_text.read_bytes()
    records.append({'path': str(binary), 'original_sha256': hashlib.sha256(raw).hexdigest(), 'adapted_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(), 'text_sha256_unchanged': hashlib.sha256(old_text.read_bytes()).hexdigest(), 'interpreter': adaptation['interpreter'], 'rpath': adaptation['new_rpath']})
    old_text.unlink()
    new_text.unlink()
(out / 'nix-adaptation.json').write_text(json.dumps(records, indent=2)+'\n')
print(json.dumps({'adapted_binaries': len(records), 'unchanged_text': True}))
