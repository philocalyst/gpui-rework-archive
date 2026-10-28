from pathlib import Path
import json,hashlib,shutil,subprocess
r=Path(__file__).parent;w=Path('/home/user/gpui-mask-lattice-lab');d=w/'reactivity/evidence/mask-lattice';raw=d/'raw'
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()=='9e4ef386f193a17d74bda63867b0ca4c86e0e59e'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert not any(x.strip() in ['cargo','rustc','clippy-driver'] for x in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
shutil.copyfile('/home/user/gpui-damage-suffix-evidence/shipping-lines-candidate.json',r/'shipping-lines-baseline.json')
assert not raw.exists();raw.mkdir()
for p in r.iterdir():
 if p.name in ['__pycache__','qualification-package.out','qualification-package.log']:continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copyfile(p,raw/p.name)
shutil.copyfile(r/'verify_qualification.py',d/'verify.py');shutil.copyfile(r/'qualification.json',d/'QUALIFICATION.json')
(d/'README.md').write_text('''# Mask lattice qualification passes; performance not measured

Production **9e4ef386f193a17d74bda63867b0ca4c86e0e59e** lowers eligible unit-scale
glyph mask addresses in existing GPU packet words. It preserves canonical
geometry, clips/corrections, painter order,16 correlated samples, compositing,
anchor/delta reduction, atlas leases and publication authority. No API, shader
pipeline, dependency, unsafe or retained-storage addition. Ineligible mappings
retain the original generic sampler. This is not a custom async runtime or a
measured cache-hit improvement.

The first scalar certificate837a23d4 passes its tests but fails12/336 exact
independent GPU readbacks near a texel boundary. The revised certificate excludes
phases inside the existing GPU error/correction envelope. All336 frames now match
byte-for-byte across the independently compiled pre-change oracle6faae98a,
revised WGSL and offline-feature builds: three formats, inline/compact, literal/
banked, fractional boundaries, clips, density/transform fallbacks and replay.
Every original failure and image remains. No tolerance, subset or timing retry.

Five configurations pass:353 GPU/canvas tests(3 ignored),1108 full-native(45),
329 minimal(25),1015 default(13),83 offline(0); strict Clippy throughout.17 workload
port tests pass in both native configurations.11 full and4 minimal actual X11
checks pass. The revised width mutant4c53d8d9 fails exact sample authority:
texel1 instead of2 at point0.125. The earlier mutant and its post-execution parser
failure remain preserved; the revised mutant writer and source both pass review.

Shipping code38028→38089(+61). Default-release native ELF26390120→26391352(+1232).
New lowered_mask_rect machine code1086 bytes, local rsp reservation96 bytes;
not whole call-chain or GPU stack. Existing present_walk and damage_from code/
local stack are unchanged. RuntimeUnit1824,Prepared40,native TextPatch96,
TextResources168,SceneDamage40 byte headers remain unchanged. Warm allocations
and runtime CPU/RSS/cold behavior are not yet measured for this candidate.

Generated shader receipts preserve28 files,5 validated SPIR-V identities and
four embedded-shader ELF identities. GPU/ offline render tests and the full-native
unit ELF actually executed; the standalone default-profile native example is
build-qualified only at this checkpoint. The initial shader helper's overbroad
executed-binaries label is explicitly corrected in the extended receipt.

All source guards and actual changed-library freshness checks pass. Earlier
setup faults remain: uninitialized new-worktree index restored from exact base;
duplicate-evidence cone omitted root files, caught/restored by afterguard;
new test omitted opaque SDR clear; new test numeric grouping failed strict
Clippy. No observation from a bad checkout and no performance observations yet.
Completed cache reclamation followed verified checkpoints c505416e and0b01889e.
Every canonical executable, source archive, generated shader/fingerprint and
execution record is retained; only verified duplicate checkout/cache copies or
regenerable inactive libraries were reclaimed. Restore historical checkout cones
before replaying guards that include the omitted inherited evidence paths.

Next: native screen preregistered**ca5a289640b8cd60525fbe599a0a19c3e184a503**,
64 processes against the qualified suffix baseline, fixed20% stream/mixed CPU
improvement and5% scroll regression limits plus cadence/idle gates. No timing
has begun. Only success admits the preregistered28-case complete cost matrix,
then a new matched ZGX comparison. Software Vulkan/private X11 establishes no
hardware GPU,scanout,two-hardware-class or visual-quality victory. The overall
user goal remains active; all changes local.

Run `python3 verify.py` to independently verify every captured gate, exact frame,
failed witness, executable/shader identity, source archive and cost record.
''')
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest={str(p.relative_to(d)):sha(p) for p in d.rglob('*') if p.is_file()};(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('Packaged',len(manifest),'files')
