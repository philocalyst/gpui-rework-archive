from pathlib import Path
import json,shutil,tomllib
for name,source in [('base','/tmp/gpui-property-control-base-sol'),('candidate','/tmp/gpui-property-selection-sol')]:
    root=Path(source)/'reactivity'
    manifest=tomllib.loads((root/'Cargo.toml').read_text())
    control=Path('/tmp/gpui-property-linked-'+name)
    (control/'src').mkdir(parents=True,exist_ok=True)
    shutil.copyfile('/tmp/gpui-property-linked-model.rs',control/'src/main.rs')
    text='[package]\nname="property-linked-control"\nversion="0.0.0"\nedition="2024"\n[workspace]\n[features]\nproperty=[]\nselection=[]\n[dependencies]\ngpui={path='+json.dumps(str(root/'crates/gpui'))+',default-features=false}\n[profile.release]\nopt-level=3\nlto=false\ncodegen-units=1\ndebug=0\nstrip="none"\n[patch.crates-io]\n'
    for package,patch in manifest['patch']['crates-io'].items():
        assert set(patch)=={'path'},(package,patch)
        text+=package+'={path='+json.dumps(str((root/patch['path']).resolve()))+'}\n'
    (control/'Cargo.toml').write_text(text)
    shutil.copyfile(root/'Cargo.lock',control/'Cargo.lock')
print('Prepared source-identical controls, same release profile, patched paths/source pins differ only.')
