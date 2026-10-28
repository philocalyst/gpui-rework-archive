# Legacy packet coverage variant

Base: 277473219bcf4add23d36126e70be1d72ceec1f6. This is an isolated
implementation; no timed qualification or adoption claim is authorized.

The packet ABI remains five shared common words plus two placement words,
or six inline words. Globals, color-bank flags, correction indices, resource
admission and the fused reverse resource patch remain the legacy implementation.
Ordinary warm render rebuilds/validates and uploads these records. No scene
header identity, record comparison, change envelopes or uniform planes exist.

Coverage is exactly the previously qualified a81/6158 state machine: a tile
starts constant; any uncovered retained draw permanently clears that tag until
a later safe opaque cover resets both the cutoff and constant tag. Logical
reference caps apply before filtering. Reverse CSR still retains ordered source
over cutoff and never infers coverage from a draw AABB. Rounded, image and mask
sources cannot produce a coverage proof. Empty ranges compare against a masked
end. A later sampled tail starts with the opaque recurrence including its old
clear multiplication/addition. Constant ranges perform each original ordered
recurrence once per pixel, then normalize negative zero with integer bits to
match the unchanged sample-major reduction. No float algebra regrouping occurs.

The exact borrowed 6158 interval kernel is copied byte-for-byte, including all
five exhaustive/adversarial/unit tests. It certifies every old rounded geometry
predicate at the exact union of visited tiles, including the last partial row
and column, using one arithmetic policy for canonical and packed-high paths.
It assumes strict Rust IEEE operations, not externally altered DAZ/FTZ. It can
fail conservatively. Setup is lazily cached only after a second actual eligible
proof request; no heap allocation or retained state is added. Alpha/sign safety
now belongs to per-draw opaque classification; full_tile itself proves solid
geometry and is shared by opaque and translucent constant eligibility.

Minimal load_paint reads only legacy color and flag words. Inline uses word4
and word5.w; compact uses the placement common address in word1.w, common3
and common4.x. Existing load_color performs bank indirection from the flag's
high bit. Correction low bits are irrelevant to paint and remain unmodified.
Existing paint/slot admission keeps alpha unchanged and declines exceptional
opaque proof colors. Translucent constant tags depend on geometry/source class,
not RGB; their negative zero is normalized by the shader after ordered blending.
A failed ordinary preparation still revokes replay before validation.

Unfavorable bills must remain explicit: shared common records cost 16 bytes per
group more than uniform planes; full records upload on every ordinary warm
render. There is no promise of lower memory, code size, host time, or tiny-draw
branch cost. Existing mutable paint/slot APIs may upload less by their own
explicit admission contract, but the public performance fixture does not use
them to hide warm validation.
