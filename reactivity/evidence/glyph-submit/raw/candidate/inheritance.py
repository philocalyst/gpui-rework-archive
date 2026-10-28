from pathlib import Path
import json,subprocess,hashlib
r=Path(__file__).parent;w=Path('/home/user/gpui-glyph-submit-lab');p=Path('/home/user/gpui-glyph-submit-predecessor-lab')
changes=subprocess.check_output(['git','diff','--name-only','aed951bc175d7bdf624b293a95d4c05a3401849e','HEAD','--','reactivity/crates','.cargo','clippy.toml'],cwd=w,text=True).splitlines();assert changes and all(f.startswith('reactivity/crates/gpu/') for f in changes)
files=subprocess.check_output(['git','ls-files','-z','reactivity/crates/gpui','reactivity/crates/canvas','reactivity/crates/core','reactivity/crates/state'],cwd=w).decode().split('\0');same={}
for f in filter(None,files):
 if not (w/f).is_file():continue
 h=hashlib.sha256((w/f).read_bytes()).hexdigest();assert hashlib.sha256((p/f).read_bytes()).hexdigest()==h;same[f]=h
r.joinpath('inherited-source-equality.json').write_text(json.dumps(dict(candidate=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip(),predecessor='aed951bc175d7bdf624b293a95d4c05a3401849e',changed_build_files=changes,identical_files=same,qualification='Default GPUI/Canvas production and native wrong-sequence authority mutant inherited from the sealed glyph-damage experiment; native composed and GPU gates repeated for this candidate. Only GPU files change against the fully qualified cost predecessor.'),indent=2));print('inherited source equality',len(same),'files')
