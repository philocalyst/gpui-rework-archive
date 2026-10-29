# Matched mapping-instrumentation control for the exact pixel discrepancy

Parent521c61f7c5813449ae59a50cbd693a411e4be2da. The semantic mapping observations
remain separate from qualification; mixed exact pixels are FAILED. No tolerance,
shader/paint optimization, scene simplification or timing campaign.

Run the same three-frame rounded-clip/text/background/shared-image fixture in
isolated candidate/control source trees. Share identical fixture/oracle source,
Cargo profile/features/dependencies, source toolchain and shader generation.
Candidate retains mapping instrumentation. Control removes only Runtime mapping
module/state/event construction/install/report; the Canvas observer feature stays
compiled with the same feature set but is not called. All older instrumentation
and the actual renderer remain identical. The fixture checks expected mapping
presence/absence separately; Source updates and all four pixel captures are the
same. Record the exact source diff and hashes of shared build/fixture inputs.

Capture all three frames before the final exact assertion in each process. The
assertion stays strict; a failed pixel gate stays FAILED. Compare candidate and
control outputs byte-for-byte in each backend, in addition to CPU/fresh CPU and
retained/full GPU within each. Compare actual scene draw geometry/colors/resource
contents, accounting for process-local identities only when necessary and
explicitly reported. Do not treat delta1 as harmless or an allowed threshold.

If the same CPU/GPU discrepancy reproduces without mapping, label it an inherited
unresolved cross-backend gate relative to this instrumentation. Do not infer a
shader cause, lifetime safety, or complete historical uninstrumented GPUI parity.
If it does not reproduce, investigate the mapping before using it as a qualified
basis. Build/strict-Clippy/source/ELF/shader guards remain; no broad structural or
rendering campaign is requested here. Keep every failed/preflight attempt.

Only after this diagnostic, trace semantic identity versus command ordinal,
physical packet address and shared resource identity to attribute relocations.
No persistent GPU extent representation is selected by this control.
