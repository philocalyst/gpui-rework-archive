from pathlib import Path
import gzip, hashlib, json, re, subprocess

root = Path('/root/gpui-ce3')
source = '8c17a763ee'
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
out = root / 'reactivity/evidence/pointer-queue-main'
out.mkdir(exist_ok=False)
digest = lambda data: hashlib.sha256(data).hexdigest()
def put(name, data):
    target = out / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
def copy(path, name, compress=False):
    data = path.read_bytes()
    put(name + ('.gz' if compress else ''), gzip.compress(data, mtime=0) if compress else data)

original = Path('/tmp/gpui-main-pointer-queue-gates')
native = Path('/tmp/gpui-main-pointer-queue-native')
checks = json.loads((original / 'results.json').read_text())
assert len(checks) == 10 and all(row['exit'] == 0 for row in checks[:9])
assert checks[-1]['case'] == 'native-original' and checks[-1]['exit'] == 1
assert 'failed to exec' in (original / 'native-original.log').read_text()
native_results = json.loads((native / 'results.json').read_text())
assert len(native_results) == 4 and all(row['exit'] == 0 for row in native_results)
assert json.loads((native / 'metadata.json').read_text())['status'] == 'passed'
guard = json.loads((original / 'source-guard.json').read_text())
assert {name: digest((root / name).read_bytes()) for name in guard} == guard
resolved = subprocess.check_output(git + ['rev-parse', source], text=True).strip()
assert json.loads((original / 'metadata.json').read_text())['source'] == resolved

def results(name):
    matches = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', (original / name).read_text())
    rows = [tuple(map(int, row)) for row in matches]
    return dict(groups=len(rows), passed=sum(row[0] for row in rows), failed=sum(row[1] for row in rows), ignored=sum(row[2] for row in rows))
totals = {name: results(name + '.log') for name in ['gpui-gpu-full', 'hummingbird-default', 'hummingbird-native']}
assert totals['gpui-gpu-full'] == dict(groups=62, passed=667, failed=0, ignored=30)
assert all(totals[name] == dict(groups=9, passed=33, failed=0, ignored=0) for name in ['hummingbird-default', 'hummingbird-native'])
counts = json.loads(Path('/tmp/gpui-main-pointer-queue-core-lines.json').read_text())
assert counts['core_non_test_code_lines'] == 30599
copy(Path('/tmp/gpui-main-pointer-queue-core-lines.json'), 'core-lines.json')
(root / 'reactivity/evidence/core-lines/8c17a763ee.json').write_bytes(Path('/tmp/gpui-main-pointer-queue-core-lines.json').read_bytes())
for folder, label in [(original, 'qualification'), (native, 'native')]:
    for path in sorted(folder.iterdir()):
        if path.is_file() and path.name != 'hummingbird-native-frozen':
            copy(path, f'{label}/{path.name}', compress=path.suffix in ('.json', '.log'))
for path in [Path('/tmp/gpui-main-pointer-queue-gates.py'), Path('/tmp/gpui-main-pointer-queue-native.py'), Path('/tmp/gpui-main-pointer-queue-gates-driver.log'), Path('/tmp/gpui-main-pointer-queue-native-driver.log'), Path('/tmp/gpui-main-plan-stamp-focused.log'), Path('/tmp/gpui-native-env.sh')]:
    copy(path, 'capture/' + path.name, compress=path.suffix == '.log')
copy(Path(__file__), 'capture/archive.py')
for name in ['gpui-rapid-pointer-native-client.py', 'gpui-rapid-pointer-native-loop-client.py']:
    path = Path('/tmp') / name
    copy(path, 'clients/' + name)
    assert any(row['client_sha256'] == digest(path.read_bytes()) for row in native_results)
put('integration.patch.gz', gzip.compress(subprocess.check_output(git + ['diff', 'dded3dff54', resolved, '--', 'reactivity/crates/gpui', 'reactivity/ports/hummingbird']), mtime=0))
put('stamp-successor.patch', subprocess.check_output(git + ['diff', 'b212e15ea0', resolved, '--', 'reactivity/ports/hummingbird']))
summary = {'source': resolved, 'guarded_files': len(guard), 'source_unchanged': True, 'totals': totals, 'core_non_test_code_lines': 30599, 'native_binary_sha256': digest((original / 'hummingbird-native-frozen').read_bytes()), 'native_results': [{k: row[k] for k in ['case', 'exit', 'client_sha256']} for row in native_results], 'preserved_runner_failure': 'Initial native launch used python3 absent from PATH and exited before the app; the native-only runner resumes verified completed prefix with the absolute interpreter.', 'limits': 'No new timing, RSS, hardware performance, native HDR, full audio player, Zed port or merged-source foreign-OS runtime claim.'}
put('summary.json', (json.dumps(summary, indent=2) + '\n').encode())
put('README.md', b'''# Integrated rapid pointer and Hummingbird queue

Source `8c17a763ee` combines the main CSR/lazy-indirect source with the exact
reviewed rapid-pointer producer6021 and Hummingbird queue producer365, followed
by removal of the redundant entry key from the opaque playback occurrence stamp.
The source patches, command transcripts, exact artifact and input guards, both
unchanged external clients and their CPU/GPU output are retained here.

## Main qualification

* Full GPUI/GPU tests and docs:667 passed,30 ignored across62 result groups.
  Features include desktop/X11/Wayland, Canvas parallel, Cephal verify-cache,
  offline shader validation and actual Vulkan readbacks.
* Hummingbird:33 default and33 native cases pass, including source delivery,
  navigation/undo, duplicate identity, stale EOS and the public queue consumer.
* GPUI/GPU and application all-target strict checks pass, with both application
  feature sets; scoped formatting passes. All2104 tracked input guards match.
* Both unchanged Registry/input clients pass on the frozen ordinary application
  using explicit CPU and GPU policies:four private-bus X11/Xvfb executions,
  including immediate press/release loops. Vulkan is software llvmpipe here;
  these establish behavior, not hardware performance. Owned displays stop.

The first native command failed before the app because the runner used bare
python3 absent from PATH. That failed command/log/metadata remain in qualification;
the separate native-only runner verifies the completed prefix, all source guards
and the same binary, then uses the known absolute Python interpreter. No successful
test prefix was rerun or relabelled. Producer foreign library compilation remains
separate; no merged foreign application or runtime qualification is claimed.

## Behavior and costs

The pointer proof admits only its own pending caret-focus paint, with exact token,
source, viewport and namespace guards and a fresh acknowledged hit. It does not
weaken the general presentation gate. Session and optional session remain32B.
The built-in inspector still uses strict ACK admission on this source; its
point-specific P/C successor is isolated and not adopted.

Hummingbird now has an exclusively owned queue, shared immutable track payloads,
distinct duplicate occurrences, current/lookahead plans, selection and range
controls, reorder/remove/undo/shuffle/repeat operations and source-qualified rows.
The queue plan is a decoder boundary: this slice does not attach audio output.
Original behavior fixtures and explicit desired differences remain in the
producer archive. Native held-button success was insufficient; the rapid clients
now execute against the integrated fix.

Each controller has a globally unique checked session and strictly increasing
checked serial. Their pair already identifies an occurrence, including same-entry
restart and repeat, so its stamp need not duplicate the current entry key. On this
64-bit build PlanStamp24->16B, Plan/OptionPlan56->48B and controller200->192B.
Late/duplicate/foreign EOS and exhaustion revocation remain tested. These are
carrier sizes, not measured process RSS or summed dynamic stack peaks.

The six shipping first-party libraries measure30599 code lines including18 build
lines, +86 from89ae. Tests, comments, blanks, apps, vendors and support tools are
excluded. App source and tests remain separate; this source bill does not predict
final feature-complete size or claim the overall rewrite complete.
''')
manifest = {str(path.relative_to(out)): digest(path.read_bytes()) for path in sorted(out.rglob('*')) if path.is_file()}
put('files.sha256.json', (json.dumps(manifest, indent=2) + '\n').encode())
assert all(digest((out / name).read_bytes()) == value for name, value in manifest.items())
print(json.dumps(summary, indent=2))
