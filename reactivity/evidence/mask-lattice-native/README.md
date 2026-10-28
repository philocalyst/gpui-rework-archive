# Mask lattice native screen: rejected

The revised exact mask-address certificate does not meet its preregistered
end-to-end CPU admission gate. All64 processes exit normally; all active runs
produce479 updates and all idle runs produce0. One candidate mixed-update run
has a late ACK gap>25ms, suppressing the whole mode's comparative CPU ratio.
No retries, exclusions or threshold changes. No cost-matrix admission.

| Mode | Median paired CPU candidate/baseline | Paired bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | undefined (both observed medians0) | — | no added CPU/updates | pass |
| scroll | 1.009169198 | [0.983605372, 1.085601962] | <= 1.05 | pass |
| stream | 0.960680128 | [0.884411214, 0.995055403] | <= 0.8 | fail |
| both | suppressed | — | equal work/cadence | fail |

The stream point improvement is about3.9%, below the20% target. Scroll's point
passes but its uncertainty interval extends above1.05; no statistical upper-bound
claim. Qualified whole-run counts do not establish identical work specifically
inside the fixed visible+1..6s CPU interval. Raw CPU/RSS/cold visibility samples
and all acknowledgement timestamps are preserved in raw/.

Correctness remains qualified at677b1fb7a51a7bab12dbad0bf4e8815fcd254b74,
production9e4ef386f193a17d74bda63867b0ca4c86e0e59e. This screen compiled
ca5a289640b8cd60525fbe599a0a19c3e184a503 against the unchanged suffix baseline
compiled2684821f4519cab4fb14185be92edb2eb55bc84e, sealedbea6c4cf. Both use
nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse.
All34 workload tests pass,10 native preflights exit normally,initial0/190 images
match exactly. Generated and embedded candidate WGSL matches the independently
qualified shader; baseline retains its original shader. Source/artifact guards
pass before and after timing.

The workload's normal ingress selection is precise source ingress for stream,
owner ingress for idle/scroll/both. The runner's `route=exact` denotes the
requested knob; it does not override the unchanged workload's mode selection.
The initial independent verifier assumed all modes used exact ingress. That
assertion was corrected after preflight and before timing; the original script,
script hashes and correction receipt are preserved. No workload or runner change.

Failed work-gate cell: [{"mode": "both", "group": 2, "name": "candidate", "late": 1}].

Native matched-profile ELF sizes: baseline 22523464, candidate 22525608 bytes. Qualification records +61 shipping lines, +1,232 default-profile ELF bytes, unchanged hot headers, no API/dependency/unsafe/pipeline addition. The rejected screen does not authorize carrying the new mask bit/lowering into the qualified suffix baseline.

Run `python3 verify_dossier.py` for independent rederivation of all64 raw
observations, work gates, CPU intervals, paired bootstrap, executable/shader
identities and qualification reference. Canonical executable storage is external
and hash-addressed. All changes remain local. This software-Vulkan result proves
no ZGX advantage,physical GPU performance,scanout latency or quality parity.
The overall architecture goal remains open; prior failures retain their verdicts.
