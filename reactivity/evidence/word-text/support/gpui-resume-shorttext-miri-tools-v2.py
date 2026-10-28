from pathlib import Path
import hashlib
import json
import subprocess

out = Path('/tmp/gpui-shorttext-miri-provision')
adaptation = json.loads(Path('/tmp/gpui-nightly-provision-2026-10-23/nix-loader-adaptation.json').read_text())['files'][0]
patchelf = '/nix/store/if2h609psbpg1ysf1m27dpshjk2wzpk4-patchelf-0.15.2/bin/patchelf'

def text_section(binary, label):
    text = out / (label + '.text')
    disposable = out / (label + '.elf')
    subprocess.run(['objcopy', '--dump-section', f'.text={text}', str(binary), str(disposable)], check=True)
    data = text.read_bytes()
    text.unlink()
    disposable.unlink()
    return data

records = []
for binary in sorted(Path('/tmp/gpui-shorttext-miri-tools/bin').iterdir()):
    raw = binary.read_bytes()
    original = out / 'unpacked/miri-nightly-x86_64-unknown-linux-gnu/miri-preview/bin' / binary.name
    original_text = text_section(original, binary.name + '-official')
    assert text_section(binary, binary.name + '-pre-adaptation') == original_text
    subprocess.run([patchelf, '--set-interpreter', adaptation['interpreter'], '--set-rpath', adaptation['new_rpath'], str(binary)], check=True)
    assert text_section(binary, binary.name + '-adapted') == original_text
    records.append({'path': str(binary), 'official_sha256': hashlib.sha256(original.read_bytes()).hexdigest(), 'pre_adaptation_sha256': hashlib.sha256(raw).hexdigest(), 'adapted_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(), 'text_sha256_unchanged': hashlib.sha256(original_text).hexdigest(), 'interpreter': adaptation['interpreter'], 'rpath': adaptation['new_rpath']})
(out / 'nix-adaptation.json').write_text(json.dumps(records, indent=2)+'\n')
print(json.dumps({'adapted_binaries': len(records), 'unchanged_text': True}))
