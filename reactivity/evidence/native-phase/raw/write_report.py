from pathlib import Path
import json,statistics
r=Path(__file__).parent;d=Path('/home/user/gpui-native-phase-lab/reactivity/evidence/native-phase');a=json.loads((r/'analysis.json').read_text());lines=[]
for mode,items in a['aggregates'].items():
 for label,x in items.items():
  rates=x['task_cores_median'];lines.append(f"| {mode} | {label} | {min(x['ticks'])}–{max(x['ticks'])} | {x['process_cores_median']:.6f} | {rates['main']:.6f} | {rates['raster']:.6f} | {rates['other']:.6f} |")
(d/'README.md').write_text('''# Native startup and thread attribution — diagnostic complete

All52 fixed observations exit normally with unchanged source, scripts, driver and
executable identities. Preregistration d8ca07eb04bc520c77a5c79193ee667990cf3e02.
No production/API/workload/shader change or compilation. This diagnostic uses the
exact two native-profile binaries qualified in native-workspace dossier
344c7f8ddd55326dca2c88322f67530914c97733. That complete native goal remains failed.

## Findings and their limits

Every candidate empty-start stream observation, through both exact-source and
owner ingress, has exactly17 ACK gaps >25ms in the first second and zero in the
remaining five seconds. Exact ingress admits323–332 updates; owner322–333.
Both candidate prefilled variants and both ZGX variants admit359 in all six
observations each. Candidate prefilled traces have no >25ms gap in any phase.
This supports a startup/state-dependent cadence loss, not a persistent exact-
source delivery failure. Initial190 seeds both text and list offset, so the
intervention does not uniquely identify text growth as its cause. Source inspection
shows the warm cost fixture uses the same190-update seed. Fixed-width visible
text reaches its bound after early growth; rejecting variable-length sparse
updates is a hypothesis to inspect, not a measured fallback count here.

ACK gaps are timed from the first presentation callback. They do not measure
admission, GPU completion or scanout, and repeated acknowledgements are retained.
All raw source/presentation epochs, timestamps and per-phase gap distributions
are in analysis.json. Model admissions remain independently recorded. The prior
warm offscreen matrix has no candidate frame >16.667ms in any of four primary
cases (1280 warm frames per case); that post-trial read is preserved separately
and is not a new benchmark or a correction of the failed native trial.

Named llvmpipe workers dominate the candidate's sampled steady CPU. Main-thread
medians are ~.071–.130 cores across variants; raster medians ~.557–.992. Scroll
and mixed remain dominated by raster work despite successful update cadence.
This suggests inspecting raster/support work before expecting an owner-tree
scheduler change to close the gap. Thread names do not establish source stacks,
cache misses or GPU hardware behavior. The main thread can include driver work.

## All variant summaries

Six-second lifetime; CPU sampled visible+1..4, >=2.8s observed. These are descriptive
medians of independently recorded runs, not paired superiority estimates. Trace
logging and thread sampling are additional instrumentation. Do not compare these
absolute CPU rates directly to the uninstrumented earlier eight-second trial.
The label exact-0 selects exact ingress only in stream; scroll/mixed use their
existing owner callback. One scroll candidate and one scroll ZGX run admit358,
all other scroll/mixed observations359. No observation is dropped.

| Mode | Variant | Whole-run updates | Process cores | Main cores | Named llvmpipe cores | Other cores |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
'''+ '\n'.join(lines)+'''

Task identities include creation time as well as TID. New/disappeared tasks and
process-minus-task residuals are retained; the residual range is -.02 to .04
CPU-seconds, reflecting OS counter resolution and non-atomic sampling. No missing
thread time is assigned to UI work. Loaded driver maps/hashes are archived.
Original profile/build/test/shader receipts accompany both preserved ELFs.

## Next architectural question

Inspect whether growing glyph counts revoke only the sparse packet certificate
or unnecessarily lose precise pixel support as well. Solid/Ripple separate
publication authority from retained resources; BBTree retains admitted per-lane
state across stages. A corresponding GPUI change could preserve exact changed
support through a required full packet rebuild, without pretending variable-
length glyph storage is an in-place transaction. It must preserve old/new glyph
coverage, failed-preparation/ack authority, fallback and immutable scene lifetime.
This is a hypothesis, not an implemented or accepted optimization.

There is no ZGX, physical GPU, two-machine, scanout or rendering-quality victory.
All changes and evidence stay local. Independent verifier reconstructs process
intervals, per-thread charges, all ACK statistics and the fixed52-run schedule
from raw records; manifest hashes cover the complete dossier.
''')
print('report written')
