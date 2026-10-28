from pathlib import Path
import hashlib, json, os, re, subprocess, time

root = Path('/root/gpui-ce3')
work = root / 'reactivity'
out = Path('/tmp/gpui-combined-core-gates')
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
head = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
assert head == '6d77c71c1227bd2609518cc5f3a49e37fc176f82'
paths = subprocess.check_output(git + ['ls-files', 'reactivity/crates', 'reactivity/vendor',
    'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/.cargo',
    'reactivity/ports/hummingbird', 'reactivity/evidence/typed-catalog/client-fixture'], text=True).splitlines()
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def guard():
    return {p: digest(root / p) for p in paths}
before = guard()
(out / 'source.json').write_text(json.dumps(before, indent=2) + '\n')
commands = [
    ('core', 'cargo test --offline --locked -p gpui_reactivity_core --features layout,cephal/verify-cache --jobs 2'),
    ('public', 'cargo test --offline --locked -p gpui --features desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache --jobs 2'),
    ('canvas', 'cargo test --offline --locked -p gpui_canvas --all-features --jobs 2'),
    ('gpu', 'cargo test --offline --locked -p gpui_gpu --features vulkan-tests --jobs 2'),
    ('clippy', 'cargo clippy --offline --locked -p gpui -p gpui_reactivity_core -p gpui_gpu -p gpui_canvas --features gpui/desktop,gpui/x11,gpui/wayland,gpui_canvas/parallel,gpui_gpu/vulkan-tests,cephal/verify-cache --all-targets --jobs 2 -- -D warnings'),
    ('apple', 'RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort --jobs 2'),
    ('msvc', 'RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort --jobs 2'),
    ('fmt', 'cargo fmt --check -p gpui -p gpui_reactivity_core -p gpui_gpu -p gpui_canvas -p gpui_reactivity_host -p gpui_reactivity_state'),
    ('catalog', 'cargo test --offline --locked --manifest-path evidence/typed-catalog/client-fixture/Cargo.toml --jobs 2'),
    ('hummingbird-tests', 'cargo test --offline --locked --manifest-path ports/hummingbird/Cargo.toml --all-targets --features native --jobs 2'),
    ('hummingbird-build', 'cargo build --offline --locked --manifest-path ports/hummingbird/Cargo.toml --features native --message-format json --jobs 2'),
]
rows = []
for name, command in commands:
    assert guard() == before
    print(json.dumps({'starting': name, 'source': head}), flush=True)
    log = out / f'{name}.log'
    with log.open('w') as stream:
        result = subprocess.run(['bash', '-c', 'source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2\n' + command],
            cwd=work, stdout=stream, stderr=subprocess.STDOUT)
    content = log.read_text()
    groups = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', content)
    row = {'case': name, 'command': command, 'exit': result.returncode,
        'log_sha256': digest(log), 'groups': len(groups),
        'passed': sum(int(g[0]) for g in groups), 'ignored': sum(int(g[2]) for g in groups)}
    rows.append(row)
    (out / 'checks.json').write_text(json.dumps({'source_head': head, 'checks': rows}, indent=2) + '\n')
    print(json.dumps(row), flush=True)
    assert guard() == before
    assert result.returncode == 0
assert guard() == before
(out / 'source-unchanged.txt').write_text(head + '\n')
