# Fixed public caller code/frame review (no timings)

All builds use the fixed public external crate and source paths in registration.json. The fixture has no inline attributes; shipping source is unchanged a50 versus exact bd09 (test-only a760). Normal roots are v0/tokio_unstable; codegen appends only -Zemit-stack-sizes using RUSTC_BOOTSTRAP=1. Both source trees, fixture/lock/manifests, fresh:false GPUI+consumer artifacts, exact fingerprint flags and frozen binaries passed before/after guards. No counting allocator/dependency is linked to the normal binaries.

| Linked control/function | Baseline code bytes / fixed frame | Candidate code bytes / fixed frame |
| --- | ---: | ---: |
| public_hit | 264 /72 |264 /72 |
| public_query (ordinary P, public geometry/text visitor) |1653 /376 |1653 /376 |
| public_prepare (Win.update) |316 /152 |316 /152 |
| Input Runtime::pointer_hit |93 /8 |93 /8 |
| Input Runtime::present_inner |21547 /3624 |21452 /3560 |
| Model Runtime::present_inner |21547 /3624 |21452 /3560 |
| Input Runtime::acknowledge |1452 /184 |1452 /184 |
| Model Runtime::acknowledge |1446 /184 |1446 /184 |
| TextResources::acknowledge |336 /104 |71 /24 |
| text_geometry::append |absent |731 /120 |
| Main public caller |21602 /3704 |21602 /3704 |

public_input was naturally inlined; its absence is not a zero-cost claim. The actual pointer path and encompassing main caller remain observable in the linked output. Equal linked sizes/frames are not a claim of identical relocated instruction bytes or equal runtime cost.

The helper is genuinely out of line. Its prologue saves six registers and reserves 72 bytes; compiler fixed-stack metadata is 120 bytes. helper-call-proof.json resolves the indirect call's GOT relocation to append and records the call within both public Runtime present_inner text-row loops. Unchanged-column early return checks exact row/origin/map identity without an Arc retain. Full fallback clones the prefix and retains remaining maps as source specifies. The callee frame, call/prologue/branches and extra P-entry reads must be priced by the registered CPU cells. The caller's 64-byte smaller frame is not a whole-path stack-saving claim.

Whole codegen .text is 3,582,791→3,583,543 (+752 B); .rodata 6,513,496→6,513,624 (+128 B); .eh_frame 222,576→222,800 (+224 B); .data.rel.ro 132,344→132,512 (+168 B). Stack metadata section 33,401→33,428 (+27 B) is compiler instrumentation, not a runtime allocation. Normal ELF files are 15,541,944→15,543,992 (+2,048 B); instrumented codegen files 15,575,424→15,577,504 (+2,080 B).

Frames are compiler fixed-frame observations for this opt3/noLTO/units1/debug0/default-features=false public consumer. They exclude missing/inlined frames, dynamic stack and dependency call depth, and are not added into an invented summed frame or performance estimate. No sample/timing command has run.
