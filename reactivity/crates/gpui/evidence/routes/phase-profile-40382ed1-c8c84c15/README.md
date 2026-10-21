# Route-storage phase profile

This directory preserves the read-only diagnostic investigation of the dense captured-route mount anomaly. It includes the instrumentation patches, the identical fixture hash and Cargo.lock hash, profile binaries' SHA-256s, all raw outputs, and the phase summary. The experiment did not edit a production worktree.

Sources and artifacts:

- Baseline source: `40382ed1d9ce1c01b556df062f3ab94b52e71dbe`.
- Candidate source: `c8c84c15be1cbd35c67ca07015d3df31c13ea367`.
- Fixture (`route_storage_measure.rs`) SHA-256: `bec398e11843352bb2aaf96dd54947181be5585e98ed1cd26f856c6912be9a30`.
- Cargo.lock SHA-256: `d4835c0d54448d6c5560b9fde1a3a43a9b5497e0d707140ce7c58f13b81ce99f`.
- Baseline instrumentation patch SHA-256: `e035a94c19cc872dc91a9661f223bef8bd72308ec939951c15e79cd3be935960`.
- Candidate instrumentation patch SHA-256: `9ffe2304f97abccaf651f0522b67dec3786ab6c1ed0ea570f25ba3c7dbc12e7e`.
- Baseline binary SHA-256: `2c89182413bae60b51977ac27563d08b6bbb4d76794ed134a5347c87c16076f8`.
- Candidate binary SHA-256: `8eabe2a9f5f444378f20a712592d6e90cb671cfeec76a4fa15156523c4ebe166`.
- `environment.txt`, `raw-sha256.txt`, and `artifact-sha256.txt` preserve machine and file provenance.

The instrumentation is guarded by the diagnostic-only `route-profile` Cargo feature. The CLI filter is optional; unfiltered default fixture behavior and its verification/pixel preflight remain unchanged. Timers are stack-local and occur only at phase boundaries, never in per-node or per-route loops. Describe phases are flatten, preflight, reconciliation (including all route-vector work), and identity-index construction/finalization. Present phases are canvas/font/layout setup, layout compute, and paint/commit. Each completed describe or present emits one diagnostic line.

The `run-pairs.sh` recipe ran 11 fresh-process alternating pairs of `route_storage_measure --case=4096,1,true`. Each process performed the normal preflight first. The first `mount=true` describe/present pair is that preflight; the second is the measured mount. Full logs are retained under `raw/`.

The phase data is diagnostic localization evidence only. The fixture's outer `mount` duration is excluded because diagnostic output runs inside that timed closure. Do not compare its outer time to the prior uninstrumented capture. See [RESULTS.md](RESULTS.md) for medians, ranges, and limitations. `strace` was not run.
