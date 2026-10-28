from pathlib import Path
import json,shutil,random
r=Path(__file__).parent;w=Path('/home/user/gpui-native-phase-lab');d=w/'reactivity/evidence/native-phase';d.mkdir(parents=True)
art=json.loads(Path('/home/user/gpui-native-workspace-evidence/frozen/artifacts.json').read_text())
(r/'artifacts.json').write_text(json.dumps({k:art[k] for k in ['candidate','zgx']},indent=2))
variants={}
for route in ['exact','owner']:
 for initial in [0,190]:variants[f'{route}-{initial}']={'name':'candidate','initial':initial,'route':route}
for initial in [0,190]:variants[f'zgx-{initial}']={'name':'zgx','initial':initial,'route':None}
(r/'variants.json').write_text(json.dumps(variants,indent=2))
names=list(variants);base=[0,1,5,2,4,3];orders=[]
for group in range(6):orders.append({'mode':'stream','group':group,'order':[names[(x+group)%6] for x in base]})
for mode in ['scroll','both']:
 for group in range(4):orders.append({'mode':mode,'group':group,'order':['exact-0','zgx-0'] if group%2==0 else ['zgx-0','exact-0']})
random.Random(20261108).shuffle(orders)
(r/'order.json').write_text(json.dumps(orders,indent=2));shutil.copy2(r/'order.json',d/'PROCESS_ORDER.json')
shutil.copy2('/home/user/gpui-native-workspace-evidence/prior-matrix-tail-diagnostic.json',r/'prior-matrix-tail-diagnostic.json')
s=Path('/home/user/gpui-native-threads-evidence/run.py').read_text()
a=s.index("R=Path(__file__)");b=s.index('\ndef run(',a)
s=s[:a]+'''R=Path(__file__).parent;HZ=os.sysconf('SC_CLK_TCK');PAGE=os.sysconf('SC_PAGE_SIZE')
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def artifact(name):
 a=json.loads((R/'artifacts.json').read_text())[name]['artifact'];assert sha(Path(a['preserved']))==a['sha256'];return a
'''+s[b:]
s=s.replace('timed=False):','timed=False,route=None):')
s=s.replace("env.pop('WAYLAND_DISPLAY',None)","env.pop('WAYLAND_DISPLAY',None)\n if name!='zgx':\n  env['GPUI_LAB_TRACE']='1'\n  if route=='owner':env['GPUI_LAB_INGRESS']='owner'")
s=s.replace("'visible_seconds':visible,","'initial_ticks':initial,'route':route,'visible_seconds':visible,")
s=s[:s.index("if __name__=='__main__':")]+'''if __name__=='__main__':
 from guard import check
 check('guard-before.json')
 orders=json.loads((R/'order.json').read_text());variants=json.loads((R/'variants.json').read_text());(R/'runs').mkdir(exist_ok=False)
 for group in orders:
  for label in group['order']:
   v=variants[label]
   try:run(v['name'],group['mode'],6,R/'runs'/group['mode']/str(group['group'])/label,initial=v['initial'],timed=True,route=v['route'])
   except Exception as e:print('FAILED diagnostic observation',group['mode'],group['group'],label,repr(e),flush=True)
 check('guard-after.json')
'''
(r/'run.py').write_text(s)
(d/'PROTOCOL.md').write_text('''# Native phase and thread attribution — preregistration

Diagnostic only. Native-workspace dossier 344c7f8ddd55326dca2c88322f67530914c97733
fails the fixed goal: all eight candidate stream runs miss cadence; qualified
scroll/mixed CPU ratios are 8.068853/6.055585 versus ZGX, exceeding .8. The earlier
failed result is immutable. Warm offscreen fixtures seed 190 updates, unlike native
initial0. Existing warm records have no >16.667ms candidate frame in four primary
cases. This motivates separating startup/text growth from steady work and delivery
route; it does not establish a cause.

Use the exact candidate/ZGX native-profile ELFs from that dossier; no build,
production, shader, API or application change. Candidate production base41a67473,
ZGX a3678578980e. Unique local worktree /home/user/gpui-native-phase-lab, branch
local/native-phase; external evidence /home/user/gpui-native-phase-evidence. No
build target is needed. Verify source build paths, profiles, immutable ELFs and
existing driver files before and after. Preserve original qualification receipts.

52 fresh six-second processes, fixed PROCESS_ORDER.json, seed20261108. Stream:
six variants (candidate exact/owner ingress times initial0/190, ZGX initial0/190)
in six balanced Williams groups. Scroll/mixed: candidate initial0 and ZGX initial0
in four balanced alternating groups each. Existing GPUI_LAB_INGRESS=owner selects
an equivalent-work coarse callback; scroll/mixed already use that route. Existing
ZGX_INITIAL_TICKS=190 seeds both text and scroll before launch, so this is a state
intervention, not an interchangeable performance benchmark. Trace GPUI_ACK using
existing GPUI_LAB_TRACE=1, keeping all repeated acknowledgements. ACKs measure
publication callbacks, not admissions, GPU completion or display scanout.

Record every observation and failure, without retry, dropped member, passing
subset or performance acceptance threshold. Capture process CPU/RSS and all
/proc task identities (TID plus creation time), names and CPU every50ms. Report
whole process and main/named llvmpipe/other task rates for visible+1..4 seconds,
require >=2.8s observed interval; new/disappeared tasks and process-minus-task
residual are explicit. Thread names do not establish source stacks or blocked
waits. Preserve loaded driver maps/hashes, geometry/font identity, whole-run
admitted updates and presentation ACK sequences. Summarize ACK gaps separately
for [0,1),[1,2),[2,4),[4,6) seconds since first presentation, plus entire trace;
count gaps >25ms, maximum and median, and retain exact source/presentation epochs.
A gap is assigned by its ending timestamp; counts are not model update counts.
All fixed groups are retained even if startup hypotheses fail.

Same X11 :94, software Vulkan, LP_NUM_THREADS=4, 960x720, scale1 and exact font.
No compilation, tests, source edits, analysis or cleanup overlap observation.
Freeze protocol/order/runner/analyzer/independent verifier before running. Seal
raw evidence and a SHA256 manifest, independently rederive task charges, CPU
intervals and ACK statistics. Report diagnosis and next testable hypothesis only;
no ZGX superiority, cache-hit, physical GPU, scanout or rendering-quality claim.
BBTree's admitted continuation state and Solid/Ripple publication boundaries guide
which ownership boundaries to inspect; async syntax is not assumed to save work.
''')
print('prepared',len(orders),'groups',sum(len(o['order']) for o in orders),'processes')
