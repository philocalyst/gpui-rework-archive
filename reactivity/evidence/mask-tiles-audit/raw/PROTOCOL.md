# Selected literal mask traversal: native diagnostic audit

Prerequisite to the mask-tiles native timing screen,per preregistration5d37f245.
Base productiond63782dd,with only optional packet logging added. Shader and
complete workload example remain byte-identical to that candidate. Use the
corrected dimensional mask classifier from09bd0c1f; clear MASK_TILE from range
ends before traversing references. Record selected tile count and planned
sample calls within selected tiles,plus bank count,actual banked packet tag,
mask placements and uploaded lowering bits. Original Stats sample sum must
match decoded counts. No shader instrumentation or performance interpretation.

Fresh matched native profile,17 workload tests,source/artifact/generated-embedded
shader checks. Main GPU/Clippy/336-pixel/mutant admission must independently pass
before observations. Run8 processes in fixed order:initial0 then190;within each
idle,scroll,stream,both;3s,trace,normal ingress,same font,960x720,X11:94,llvmpipe4.
Capture both idle images and require exact equality with uninstrumented native
reference images. Normal exits/font/geometry and source guards mandatory.
Every packet with lowered mask references must select at least one literal tile;
all lowered planned sample references must lie in selected tiles on this literal
workload. Count/correctness gate only,never a CPU speed comparison. Keep all
failures and no altered thresholds. Preserve8GiB reserve. All changes local;
no adoption,ZGX,hardware,scanout or quality claim.
