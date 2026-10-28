from pathlib import Path
import json,hashlib,sys
r=Path(__file__).parent;gate=sys.argv[1];mutant=gate.startswith('negative-');out=r/gate
baseline=Path('/home/user/gpui-mask-lattice-evidence/oracle-gpu-initial/pixels');parent=Path('/home/user/gpui-mask-lattice-evidence/gpu-near-ties/pixels');current=out/'pixels'
assert len(list(baseline.glob('*.rgba')))==336 and {p.name for p in baseline.glob('*.rgba')}=={p.name for p in parent.glob('*.rgba')}=={p.name for p in current.glob('*.rgba')}
fixture='reactivity/crates/gpu/tests/support/mask_lattice.rs'
assert (Path('/home/user/gpui-mask-lattice-oracle-lab')/fixture).read_bytes()==(Path('/home/user/gpui-mask-grid-lab')/fixture).read_bytes()==(Path('/home/user/gpui-mask-grid-coarse-lab')/fixture).read_bytes()
def sha(b):return hashlib.sha256(b).hexdigest()
rows=[]
for p in sorted(baseline.glob('*.rgba')):
 b=p.read_bytes();old=(parent/p.name).read_bytes();v=(current/p.name).read_bytes();assert b==old and len(b)==len(v)
 bad=[i for i,(x,y) in enumerate(zip(b,v)) if x!=y]
 rows.append(dict(file=p.name,bytes=len(b),oracle_sha256=sha(b),parent_sha256=sha(old),candidate_sha256=sha(v),equal=not bad,differing_bytes=len(bad),first_difference=bad[0] if bad else None,first_expected=b[bad[0]] if bad else None,first_actual=v[bad[0]] if bad else None))
fails=[x for x in rows if not x['equal']];result=dict(gate=gate,mutant=mutant,frames=len(rows),exact_frames=len(rows)-len(fails),mismatches=len(fails),fixture_sha256=sha((Path('/home/user/gpui-mask-grid-lab')/fixture).read_bytes()),rows=rows)
(out/'independent-pixels.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k!='rows'}));print('first mismatch',fails[:1]);assert bool(fails)==mutant
