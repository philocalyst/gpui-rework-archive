from pathlib import Path
import shutil,json,hashlib
r=Path(__file__).parent;d=Path('/home/user/gpui-damage-suffix-lab/reactivity/evidence/damage-suffix-qualification');d.mkdir(exist_ok=False)
(d/'README.md').write_text('''# Exact suffix comparison — correctness qualified; performance pending

Production source df8ca59f69813e7dd05711fead98ed4278f1688d, preregistration
0a7f3b822b09744e7e45a1ac9961d8aaa183a416. Base41a67473 passes the earlier local
workspace matrix but fails native ZGX comparison344c7f8ddd55. Startup diagnosis
is sealed at a34b61c86fbbc6906d834e071bdb7c4fb70aac8d. No earlier result changes.

When complete display streams differ in length, the new Canvas comparison removes
only an exactly equal common suffix before the existing positional comparison.
This avoids pairing inserted glyphs with unrelated following draws. Both supports
of the first unequal reverse pair remain in damage, as do every unmatched old/new
contribution. Equal-length behavior, exact material/geometry/lease equality,
publication tokens, full-packet rebuilding and shaders stay unchanged. No API,
new storage, dependency/vendor or unsafe change. This is not the rejected global
scene-support representation and not an async/cache-hit performance claim.

349 Canvas/GPU tests (3 ignored),1108 full-native library tests (45 ignored),329
minimal library tests (25 ignored),1015 default tests (13 ignored),79 offline GPU
tests, strict Clippy in each configuration,17 workload tests in each native feature
configuration,11 full and4 minimal actual X11 scripts pass. The actual native
renderer additionally checks100 growing-text frames against independently fresh
full scenes: two routes,25 frames each, repeated through the existing script.
Skipped ACKs exercise retained damage relative to older publication. Existing
failed-newer/eligible-older, stale-image, namespace and resource tests pass.
The bounded omission mutant4b10759040a705a6604517a279f65ec491719c72 fails an actual
changed pixel outside damage at44,2. No tolerance or reduced-work oracle.

Shipping code38028 (+12). Default-release native ELF26390120 (+864). Runtime1824,
Prepared40, TextPatch96, TextResources168 and SceneDamage40 bytes stay unchanged.
Canvas damage_from machine code1860→2499B and local sub-rsp reservation936→1272B;
native Lab present_walk remains26880B and [4096,200]. These are local prologue
observations, excluding callees, driver/GPU stacks and register saves. There is no
new persistent collection; complete allocation/timing probes remain outstanding.
Canonical WGSL is unchanged;28 generated files,three executed binaries and all
five validated/embedded SPIR-V modules have exact receipts.

Two stage-reserve stops are preserved. Full-native and default tests completed
successfully, but preserving169/152 executable artifacts reduced free space below
8GiB before the next command. Example/Clippy remainders ran separately after sealed
checkpoints e6f35b6671 and342e9495b1 and verified cache reclamation. No successful
performance cohort was retried, and no timing has run. The initial cleanup process
guard also rejected its own launching here-document before mutation; standalone
retry passed unchanged guard. Every removed executable remains byte-identical in
canonical raw/gzip stores. Duplicate ancestor evidence checkout copies now map to
one verified committed-source archive; each own sealed dossier and production
input remains available. Restore ancestor paths before a historical full-checkout
guard. All storage operations have receipts and the shared archive is verified.

Next is the frozen32-process matched-profile initial0 cadence screen (eight pairs
per route,8s each): every candidate must admit464–488 updates and have<=2 first-
second ACK gaps>25ms. Only a pass admits the4160-process unchanged28-case regression
matrix. Those results and a new ZGX native comparison are still pending. There is
no adoption, ZGX, physical-GPU, two-hardware-class, scanout or render-quality win.
All changes remain local. verify_qualification.py reconstructs counts, artifact
and shader identities, negative witness and cache/archive preservation from raw.
''')
shutil.copytree(r,d/'raw',ignore=shutil.ignore_patterns('__pycache__','dossier-verification*','seal*'))
shutil.copy2(r/'verify_qualification.py',d/'verify_qualification.py')
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
