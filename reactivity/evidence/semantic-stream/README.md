# Borrowed semantic serialization

Source: `c894ff7c410b404dabc744e35090d6fc7e062940`; isolated source
`d5325f6480` in `/root/gpui-semantic-stream/reactivity`. The integrated crate
sources, manifests and lockfile are identical to the tested isolated versions.
[checks.json](checks.json) records commands, successful exits, raw log hashes
and counts. The 298 default cases include six public serialization cases and
the borrowed-snapshot lifetime compile-fail check. Strict accessible X11/Wayland
all-target Clippy, formatting and the actual layout ledger also pass.

`Win::semantics()` and `Serialize for Part` borrow the existing semantic
presentation. There is no retained diagnostic tree or new runtime field. Node
40 B, Presented 80 B, Runtime header 2,384 B and TextSite 80 B are unchanged.
Thirty-two complete writes to `std::io::sink()` allocate zero framework bytes;
an application writer can have its own allocation behavior. `to_json()` allocates
its returned string. Writer failure can leave partial output and does not mutate
the window.

The projection exposes current interaction focus and frozen acknowledged node
data, with source/presentation/prepared epochs and requested/acknowledged viewport
settings. Tests exercise pending and failed candidates, logical removal, virtual
250K realization, writer failure, quarantine and close. Serialized targets are
process-local diagnostic identities, with no deserialization capability. Platform
adapters may synthesize additional nodes: this is the GPUI Part projection, not
a byte dump of an OS accessibility tree. Source persistence and deterministic
replay remain separate APIs/contracts.

No timing, startup, click-latency or RSS improvement is claimed. Counts overlap
and must not be added together.
