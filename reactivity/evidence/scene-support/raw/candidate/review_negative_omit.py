from pathlib import Path
import json,hashlib
r=Path(__file__).parent;d=r/'negative-omit'
status=json.loads((d/'test.status.json').read_text())
assert status['exit']==101 and not status['stopped']
assert json.loads((d/'guard-after.json').read_text())==[]
log=(d/'test.log').read_text();out=(d/'test.out').read_text()
phrase='complete support case=0, tick=3, format=Rgba8UnormSrgb'
assert phrase in log and '0 passed; 1 failed' in out
artifacts=json.loads((d/'test-artifacts.json').read_text());assert len(artifacts)==1
for a in artifacts:assert hashlib.file_digest(Path(a['preserved']).open('rb'),'sha256').hexdigest()==a['sha256']
positive=r/'gpu-fixture-lint/test.out'
assert 'test complete_scene_regions_match_full_gpu_for_all_formats_and_materials ... ok' in positive.read_text()
source=Path('/home/user/gpui-scene-support-omit-lab/reactivity/crates/gpu/tests/render.rs').read_text()
assert 'read_texture(&gpu, &target) == readback(&mut oracle, &canvas)' in source
(r/'negative-omit-review.json').write_text(json.dumps({'source':(d/'source.txt').read_text().strip(),'test_status':status,'pixel_failure':phrase,'original_runner_failure':'Expected first mismatch on tick 1; actual exact image mismatch is tick 3. Test and mutant ran once. No pixel criterion changed; preserve runner assertion failure.','positive_fixture':'gpu-fixture-lint/test.out','artifacts':artifacts},indent=2))
print('Reviewed original omission run: exact pixels fail at case 0, tick 3; no rerun')
