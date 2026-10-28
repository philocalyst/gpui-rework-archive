# Native coverage diagnosis: the four-cell path was not selected

Corrected diagnostic source09bd0c1f17fc0febe1024d757b58770748195b31 executes
all8 frozen native processes normally:idle/scroll/stream/both atinitial0/190,
3s each. Across1,082 prepared packets,paint-bank count is always0 and the actual
packet banked tag is alwaysfalse. The four-cell shader cache is reachable only
through banked_fragment,so the native mask-quad screen never exercises that
cache. This explains absence of its intended mechanism,not an attribution of
small CPU ratio differences to any specific instruction or cache-hit effect.
Both failed performance screens remain rejected.

The corrected full-packet plan contains2,779,389 mask references,of which
2,587,037 carry the LOWERED_MASK certificate (about93.1%). Every observed mask
placement has unit inverse axes and matching mask/logical dimensions. These
are accumulated planned CSR references,not distinct glyphs,actual shader load
counts,hardware cache events or work cropped to native repair regions. The
shader itself is byte-identical to qualified four-cell production7565d788;
its generated WGSL bytes are checked inside both instrumented executables.

All17 workload tests pass for each diagnostic source. Both corrected frozen
native images exactly match the uninstrumented initial0/190 images; source,
profile,artifact and driver guards pass. Logging is instrumented and deliberately
not timed for performance. No API or adopted production change is proposed by
this diagnostic.

Initialsource3d06af57 also recorded1,082 packets with zero bank counts, but its
reference classifier checked only high material bits and mislabeled untextured
solids as masks. Its mask-reference totals are rejected. Correctedsource also
requires nonzero packed mask dimensions. All initial data,frozen scripts,
canonical executables and guards remain under raw/; the corrected cohort is
raw/corrected/. The initial verifier checked arithmetic without validating that
semantic classification and was not run as a qualification claim. No failures
or observations were removed. See CORRECTION.md.

Run `python3 verify.py` to independently validate the corrected cohort and the
preserved initial bank-selection fact. A next experiment may decouple traversal
choice from paint-bank representation using a bounded tile flag,retaining all16
sample blends and original fallback. That hypothesis needs separate preregistration,
exact GPU/mutant gates and the fixed full performance/cost gates. The old generic
draw-major7–9% text improvement and pixel-uniform flat regression remain rejected.
No ZGX,physical GPU,scanout or quality victory; all changes local.
