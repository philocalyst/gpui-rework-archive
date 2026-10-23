# Statistics traversal experiment, preserved and unadopted

Source b3123ea1b4df2d144108d25499780217aac5b470 folds the statistics pass
into tile normalization relative to 299c6aca30c1245c15c2da6a5ccabb41dd435d17.
The shipping renderer is 7a5e1619a27010ec63f6c27506a6d1fcd113f67c; this
candidate does not replace it. The prior 299c timing regression remains in its
own complete campaign and is not repaired by this untimed experiment.

Functional, strict, Apple/Windows compilation and exact named-image checks
pass. The deliberate wrong-counter control fails and recovery passes. There
is no shader ABI or retained state change. The static bill is unfavorable:
four fewer core lines relative to its own baseline, but 48 additional linked
text bytes, 411 additional render bytes and 64 additional fixed frame bytes.
No runtime timing or overall speed improvement is established.

Root independently reopened all 2,891 archive payloads (77,419,272 bytes)
and all 9 external ELF/compiler identities, checking lengths and SHA256.
The complete archive, manifest and verification report are retained. Raw
ELFs remain at their manifest paths. The archive includes complete commands,
guards, failures, images, static cost evidence and the producer's detailed
scope; no production patch is applied to Main.
