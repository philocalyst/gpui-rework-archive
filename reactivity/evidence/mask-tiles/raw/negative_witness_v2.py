from pathlib import Path
import re,json,hashlib
r=Path(__file__).parent;g=r/'negative-y';out=(g/'test.out').read_text();text=(g/'test.log').read_text()+'\n'+out;assert json.loads((g/'test.status.json').read_text())['exit']==101 and '0 passed; 1 failed' in out
assert 'public_mask_lattice_readbacks_replay_clips_and_density_fallbacks' in text
left=re.findall(r'^\s*left: (\[.*\])$',text,re.M);right=re.findall(r'^\s*right: (\[.*\])$',text,re.M);assert len(left)==len(right)==1
actual=bytes(json.loads(left[0]));expected=bytes(json.loads(right[0]));oracle=Path('/home/user/gpui-mask-lattice-evidence/oracle-gpu-initial/pixels/0-false-0-0-false.rgba').read_bytes();candidate=(r/'gpu-initial/pixels/0-false-0-0-false.rgba').read_bytes();assert expected==oracle==candidate and len(actual)==len(expected)==35840 and actual!=expected
bad=[i for i,(a,b) in enumerate(zip(actual,expected)) if a!=b];(g/'proof-enabled-mutant.rgba').write_bytes(actual);(g/'proof-disabled-reference.rgba').write_bytes(expected)
result=dict(source=(g/'source.txt').read_text().strip(),test_exit=101,bytes=len(actual),differing_bytes=len(bad),first_difference=bad[0],expected=expected[bad[0]],actual=actual[bad[0]],expected_sha256=hashlib.sha256(expected).hexdigest(),actual_sha256=hashlib.sha256(actual).hexdigest(),oracle_file='0-false-0-0-false.rgba',scope='The unchanged public fixture rejects mutated proof-enabled literal tile output against its proof-disabled fallback; right-hand bytes also equal the independently compiled pre-change oracle and real candidate.')
(g/'witness.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2))
