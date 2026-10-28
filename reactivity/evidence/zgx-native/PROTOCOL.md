# Equivalent native lab: preregistration

Local diagnostic campaign, not a hardware victory. Candidate starts at
c7194c74e6 (retained output, sparse text publication, owned text planning).
Reference ZGX a3678578980ef239058c557338ef9c544d356b0c, unmodified desktop
`component_workload`. Copy its MIT shared workload verbatim, including font and
license; use the same 960x720 geometry, text, colors, row range, overscan, period,
modes, bounded stream and control results. Count admitted work and successful
native acknowledgements separately. Do not treat a timer callback as a frame.

GPUI port uses ordinary public View/Window/Remote APIs; no privileged renderer
or runtime access. Match controls and compare semantic geometry and screenshots
before timing. A port limitation is an equivalence failure, not an exemption.
Use private X11 and software Vulkan for local diagnosis only. This establishes
neither physical GPU behavior nor display latency. Keep screenshots, all failures,
source/binary hashes and exact command/environment receipts.

For comparative measurements use equal fat LTO/one-codegen-unit builds, five
interleaved process pairs per idle/stream/scroll/both mode, 10 seconds each,
identical fonts, driver thread limit and screen. Record whole-process CPU time,
RSS, tick counts, native presentation acknowledgements when exposed, and external
pixel/cadence observations. Do not time while building or running other tests.
Admission requires matching visible output/content and at least 95% of scheduled
ticks; CPU advantage must exceed 20% in active modes, no mode regress over 5%,
no missed-content/frame-quality regression. Failures remain in the report.
Startup, steady state, memory, teardown, latency and rendering are separate costs.
No ZGX victory until equivalent feature/workload gates pass on two real hardware
classes. Additional heavy/animate/variable-list coverage remains required.
