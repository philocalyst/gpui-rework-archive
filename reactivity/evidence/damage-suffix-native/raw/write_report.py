from pathlib import Path
import json,statistics
r=Path(__file__).parent;w=Path('/home/user/gpui-damage-suffix-native-lab');d=w/'reactivity/evidence/damage-suffix-native';a=json.loads((r/'analysis.json').read_text());art=json.loads((r/'artifacts.json').read_text());lines=[]
for route,variants in a['aggregates'].items():
 for name,v in variants.items():lines.append(f"| {route} | {name} | {v['gate_passes']}/8 | {min(v['ticks'])}–{max(v['ticks'])} | {min(v['first_second_gaps_over25ms'])}–{max(v['first_second_gaps_over25ms'])} | {v['cpu_cores_median']:.6f} | {v['mean_rss_bytes_median']/1e6:.3f} |")
(d/'README.md').write_text('''# Exact suffix native startup screen — passes; broader gates pending

All16 candidate observations admit479 updates in8seconds and have exactly one
ACK gap>25ms in the first second, passing both unchanged464–488 and<=2 limits.
All16 preserved baseline observations have17 first-second gaps and admit445–455
updates, failing both startup criteria. Every process exits normally; all32
observations are retained, with no retries or subset selection. All source,
script, artifact and environment guards pass. This admits the planned complete
28-case regression matrix; it is not adoption or a ZGX superiority result.

## Sources and causal scope

Native preregistration2684821f4519cab4fb14185be92edb2eb55bc84e adds protocol only
to production df8ca59f69813e7dd05711fead98ed4278f1688d, qualified and sealed at
380db598cdbed2dd81c5a41745473c40a876f148. The original cadence screen and limits
were frozen before implementation at0a7f3b822b09744e7e45a1ac9961d8aaa183a416.
Baseline is the exact qualified native-workspace ELF from03ca419868b0, with its
failed whole-goal dossier344c7f8ddd55326dca2c88322f67530914c97733 unchanged.
Both profiles are identical: nightly-2026-10-23, opt3/fat-LTO/CGU1/debug0/no
stripping/unwind/incremental false, identical Rust flags and locked dependencies.
Both pass17 example tests under this profile. All six untimed preflights pass;
initial190 frozen images match exactly (AE0). Canonical shader bytes are unchanged
and embedded in the actual ELF. No production/API/application/pacing/shader change
beyond Canvas suffix comparison; added example/native functions are cfg(test).

The only production difference trims an exactly equal common suffix when display
command lengths differ, before the existing forward damage comparison. Growing
text had shifted the comparison against unrelated following draws. Both old and
new supports of the first unequal reverse pair remain mandatory; the independently
qualified omission mutant proves an actual missing-pixel failure. This native
intervention supports that overbroad damage as a cause of the startup cadence loss.
It does not identify cache misses or demonstrate an async executor benefit.

## Complete observations

Eight balanced pairs per ingress route, original seed20261109 order, initial0,
8seconds, existing GPUI_LAB_TRACE=1 in both. All>25ms gaps in every observation
occur in the first second. Repeated ACKs remain in raw logs; presentation callbacks
are not admissions, GPU completion or scanout. Final admitted counts are recorded
separately. No observed cadence or CPU data was used to revise a limit.

| Ingress | Variant | Startup gate | Whole-run updates | First-second gaps>25ms | Descriptive median CPU cores | Median mean RSS MB |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
'''+ '\n'.join(lines)+f'''

CPU is process user+system, including llvmpipe, sampled visible+1..6s (>=4.8s).
Those boundaries differ from whole-run updates. No CPU ratio, normalization by
whole-run ticks, or equal-work-in-interval assertion is made. The unchanged warm
regression matrix and a new cadence-qualified ZGX comparison are still required.
This experiment addresses startup; steady raster cost remains a separate lead.

Actual native ELF sizes: baseline{art['baseline']['bytes']}B and
candidate{art['candidate']['bytes']}B, delta{art['candidate']['bytes']-art['baseline']['bytes']}B
under the matched native profile. Do not compare these directly to the default-
release qualification ELFs. Shipping+12 lines and hot headers remain as measured
in the earlier qualification dossier. No new retained collection or shader.

A fresh native-only target was used. Starting free space was below the preferred
12GiB after verified cleanup, but above the fixed8GiB minimum; the known prior
profile used~1.1GiB. Continuous monitoring preserved the hard minimum, and both
build/test completed normally. The exact starting/minimum values are archived.
Cleanup removed only completed qualified library caches after source/evidence seal;
all exact executable, shader and fingerprint bytes remain preserved.

No builds, tests, edits, analysis or cleanup overlapped timed processes. All owned
processes are reaped. Independent verifier rederives schedule, every admission/
ACK gate and process interval, and verifies source/profile/artifact/shader inputs.
Next: the preregistered4160-process regression matrix against the qualified
workspace, then unchanged ZGX native/hardware/quality gates. No physical-GPU,
two-hardware-class, scanout, visual-policy or overall ZGX victory. Local only.
''')
print('report written; native ELF delta',art['candidate']['bytes']-art['baseline']['bytes'])
