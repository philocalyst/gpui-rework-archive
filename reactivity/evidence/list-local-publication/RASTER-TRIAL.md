# Exact raster clip follow-up

Preregistered after the first candidate failed representative admission and
before changing the clip reconstruction. The frozen first candidate is
`7afc8a2dad076bc6c6bb33cea59db27f182c4265`. Its `admission-clip-bits`
gate reports zero patches in all five 80-update cases. Both stream cases had
80 unchanged layouts. The stream's canonical clip is
`[1101004800,1121714176,1147535360,1126170624]`, while the semantic bound is
`[1101004799,1121714175,1147535362,1126170626]`; the canonical group has no
remaining clip chain. This rejects the first candidate's actual-workload
hypothesis; passing small fixtures does not override that result.

The next candidate reconstructs the sample-lattice clip using the existing
Canvas `sampled_rect_clip` operation and exact admitted transforms from the
same acknowledged P. Walk only the selected row's P ancestors. Include explicit
clip ancestors and ordinary/list viewport nodes; reject nonzero rounded clip
radii or unsupported maps. Intersections of the finite quarter-pixel lattice
intervals are exact, so walking ancestors in reverse order preserves membership.
Do not use semantic outward bounds as a raster certificate. The original Canvas
bit-equality/material/run/resource proof remains unchanged and authoritative.

This adds no retained index, API, dependency, shader or unsafe code. P-row search
and ancestor walk costs are charged, with no O(changed) complexity claim. Active
editing/inspector state and unsupported rounded/sheared clips still fall back.
The ordinary feature-free path remains direct. Do not weaken numerical checks
or mutate retained commands before complete validation.

The independent image-placement prerequisite has reproduced an actual baseline
pixel failure and a two-line correction has passed focused independent Canvas
oracles. Complete its separate qualification before composing it here. Use that
same correction in both timing alternatives; missing images are not cheaper
correct rendering. Keep the original failed image and admission evidence.

Reuse all stages, adversaries and fixed performance thresholds from PROTOCOL.md.
Add nested rectangular clips, fractional and reflected transforms, clipped text
under ordinary scroll, and rounded/sheared fallback comparisons. Verify actual
Workload admission again before authorizing timing. In particular, stream and
stream-owner must each admit at least one of their 80 updates; other cases may
fall back. Keep all counts rather than reporting only admitted operations.
The exact timing manifest remains due before measurement. No performance or
ZGX parity claim is authorized by an admission-count improvement.
