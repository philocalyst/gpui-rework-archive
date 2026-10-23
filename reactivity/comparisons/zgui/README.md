This comparison ports the ordinary GPUI Todo application to
[zeronsh/zgui](https://github.com/zeronsh/zgui). GPUI is based on
`3ca3a86e07163ffeb3504ad43f683f57c91b46f0`; zgui is based on
`c077cd3bc2e63311e04ecc0e7b484c7e1192d595`. Results belong to these concrete
application adapters, build settings and rendering backends.

The GPUI adapter is `crates/gpui/examples/todo_comparison.rs`, with its model
in `examples/support/todo_comparison.rs`. It copies the existing Todo example's
trimmed add, checked IDs, completion, filtering, deletion and single undo. The
comparison adds deterministic seeds, a fixed 56-pixel Add button, a 360-pixel list viewport, a combined
remaining-count/filter footer and animation. It uses ordinary public APIs;
shipping library source is unchanged. The default empty comparison therefore
has a different viewport structure from the original unmodified example.

Both windows are 540 × 620 logical pixels at scale one. The list is eager:
10,000 retained rows really produce all the row descriptions, rather than a
virtualized viewport. Seed row `index` has ID `index`, title
`format!("Task {:04}", index + 1)` and completion `index % 3 == 1`.
The explicit Add width avoids an existing GPUI intrinsic-width padding-roundtrip
wrap defect; the original example is not silently treated as visually qualified.
That core defect is investigated separately. zgui line heights are normalized to
Noto Sans metrics (body 21.792, heading 38.136, small count 19.068 logical pixels).
Typography, padding, row sizes, colors and control order must be checked before
the capture. Font provisioning and accessibility differences are reported
explicitly; matching an ASCII workload does not establish complete text or
accessibility parity.

The registered workloads are:

| Workload | Retained rows | Activity |
| --- | ---: | --- |
| Idle | 0 | Settle after first presentation, then leave the window unchanged. |
| Busy | 0 initially | Repeat the eight-operation UI macro below. |
| Heavy | 10,000 initially | Repeat the same UI macro against the full list. |
| Animation | 1,000 | Translate the list content vertically by a 12-pixel sinusoid at 60 scheduled samples/second, inside its stationary viewport. |

The busy/heavy macro targets one operation every 250 ms, using absolute
deadlines: focus/type `bench-{cycle}`, Add, Complete/Reopen the first row,
Active, Done, All, Delete the first row, Undo. Each two-second cycle has one
input operation and seven button callbacks. Samples record requested,
dispatched and completed work. A missed deadline or lost callback is retained
as a failure or overload, never hidden by reducing one adapter's workload.

Animation phase is the scheduled sample index divided by 60, multiplied by
`TAU`. A missed sample advances phase; neither adapter should replay a backlog
or slow the apparent animation. GPUI uses its public bounded `Remote`/`Inbox`
delivery. That API currently gives an ordinary owner edit to its receiver, so
this adapter includes its conservative owner invalidation. A direct `Win::set`
microbenchmark would be a different workload.

The primary native comparison selects GPU rendering in both adapters and the
same software Vulkan driver, with `LP_NUM_THREADS=4`. GPUI's software renderer
or automatic startup are separate optional measurements. Their results must
not be pooled into the native GPU series. Each adapter retains its committed
dependency lockfile. Release settings, compiler, effective rustflags, binary
hashes, source hashes and backend logs accompany the captures.

The fifteen requested categories use these definitions:

| Category | Measurement |
| --- | --- |
| CPU · sitting idle | Process user + system CPU over wall time after settling; 100% means one occupied logical CPU. |
| CPU · busy app | The same measure during Busy, together with delivered work. |
| CPU · heavy app | The same measure during Heavy, together with delivered work. |
| CPU · animation | The same measure during Animation, together with sample/frame counts. |
| GPU · busy app | Hardware GPU utilization/time requires a hardware-backed run; software Vulkan does not establish it. |
| GPU · heavy app | Same restriction, using Heavy. |
| GPU · animation | Same restriction, using Animation. |
| Memory · idle | Process RSS and PSS after settling; observer storage is included. |
| Memory · heavy app | Sampled RSS/PSS and peak during Heavy, distinct from lifetime high-water. |
| Memory · animation | Sampled RSS/PSS and peak during Animation. |
| Smoothness · busy app | Host submission intervals and action delivery are diagnostic proxies; physical display cadence requires a real display. |
| Smoothness · heavy app | Same boundary and restriction, using Heavy. |
| Smoothness · animation | Same boundary and restriction, using Animation, including missed target intervals. |
| Startup work | External spawn-to-first-successful-present marker, CPU work and minor/major faults; warm page cache is labeled honestly. |
| App size | Stripped release executable bytes, with embedded and external assets and required dynamic libraries distinguished. |

The Linux host has a Ryzen 7 3700X, 16 available logical CPUs and approximately
64 GiB physical memory. Its only DRM card is ASPEED AST; there is no render
node. Native runs use owned Xvfb displays and Mesa llvmpipe. Hardware GPU
rankings, photon latency and physical display smoothness remain unmeasured.

Frame observers buffer timestamps and emit them on normal window close; they
do not perform per-frame I/O. `TODO_FIRST_PRESENT` is emitted immediately after
the first successful native presentation. GPUI's callback is after host
submission and runtime acknowledgement. It is not a scanout timestamp. Linux
zgui's existing `present_log::now_ns()` returns zero, so its benchmark observer
must use a real monotonic clock at the successful `Presented` boundary.

The planned capture rotates app order across three paired 30-second trials per
workload, preserving every trial and its samples. Startup uses separate launches.
Compilation, functional probes and screenshots happen before the quiet capture.
No result is accepted solely because a process consumed little CPU: callback,
animation and presentation counts must explain what it actually delivered.
