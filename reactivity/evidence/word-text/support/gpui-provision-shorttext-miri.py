from pathlib import Path
import hashlib
import json
import subprocess
import tarfile
import tomllib

out = Path('/tmp/gpui-shorttext-miri-provision')
out.mkdir(exist_ok=False)
manifest = tomllib.loads(Path('/tmp/gpui-nightly-provision-2026-10-23/channel.toml').read_text())
entry = manifest['pkg']['miri-preview']['target']['x86_64-unknown-linux-gnu']
assert entry['available']
archive = out / 'miri-nightly-x86_64-unknown-linux-gnu.tar.xz'
command = ['curl', '--fail', '--location', '--silent', '--show-error', '--output', str(archive), entry['xz_url']]
with (out / 'fetch.log').open('w') as log:
    subprocess.run(command, stdout=log, stderr=log, timeout=120, check=True)
assert hashlib.sha256(archive.read_bytes()).hexdigest() == entry['xz_hash']
(out / 'verified-download.json').write_text(json.dumps({'url': entry['xz_url'], 'sha256': entry['xz_hash'], 'bytes': archive.stat().st_size}, indent=2)+'\n')
unpacked = out / 'unpacked'
unpacked.mkdir()
with tarfile.open(archive) as tar:
    tar.extractall(unpacked, filter='data')
installer = unpacked / 'miri-nightly-x86_64-unknown-linux-gnu' / 'install.sh'
prefix = Path('/tmp/gpui-shorttext-miri-tools')
assert not prefix.exists()
with (out / 'install.log').open('w') as log:
    subprocess.run(['bash', str(installer), f'--prefix={prefix}', '--disable-ldconfig'], stdout=log, stderr=log, timeout=300, check=True)
adaptation = json.loads(Path('/tmp/gpui-nightly-provision-2026-10-23/nix-loader-adaptation.json').read_text())['files'][0]
records = []
for binary in sorted((prefix / 'bin').iterdir()):
    original = binary.read_bytes()
    if not original.startswith(b'\x7fELF'):
        continue
    original_text = out / (binary.name + '-text-before')
    adapted_text = out / (binary.name + '-text-after')
    subprocess.run(['objcopy', '--dump-section', f'.text={original_text}', str(binary)], check=True)
    subprocess.run(['patchelf', '--set-interpreter', adaptation['interpreter'], '--set-rpath', adaptation['new_rpath'], str(binary)], check=True)
    subprocess.run(['objcopy', '--dump-section', f'.text={adapted_text}', str(binary)], check=True)
    assert original_text.read_bytes() == adapted_text.read_bytes()
    records.append({'path': str(binary), 'original_sha256': hashlib.sha256(original).hexdigest(), 'adapted_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(), 'text_sha256_unchanged': hashlib.sha256(original_text.read_bytes()).hexdigest(), 'interpreter': adaptation['interpreter'], 'rpath': adaptation['new_rpath']})
    original_text.unlink()
    adapted_text.unlink()
(out / 'nix-adaptation.json').write_text(json.dumps(records, indent=2)+'\n')
print(json.dumps({'download_verified': True, 'adapted_binaries': len(records), 'prefix': str(prefix)}), flush=True)
