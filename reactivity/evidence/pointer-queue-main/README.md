# Integrated rapid pointer and Hummingbird queue

Source `8c17a763ee` combines the main CSR/lazy-indirect source with the exact
reviewed rapid-pointer producer6021 and Hummingbird queue producer365, followed
by removal of the redundant entry key from the opaque playback occurrence stamp.
The source patches, command transcripts, exact artifact and input guards, both
unchanged external clients and their CPU/GPU output are retained here.

## Main qualification

* Full GPUI/GPU tests and docs:667 passed,30 ignored across62 result groups.
  Features include desktop/X11/Wayland, Canvas parallel, Cephal verify-cache,
  offline shader validation and actual Vulkan readbacks.
* Hummingbird:33 default and33 native cases pass, including source delivery,
  navigation/undo, duplicate identity, stale EOS and the public queue consumer.
* GPUI/GPU and application all-target strict checks pass, with both application
  feature sets; scoped formatting passes. All2104 tracked input guards match.
* Both unchanged Registry/input clients pass on the frozen ordinary application
  using explicit CPU and GPU policies:four private-bus X11/Xvfb executions,
  including immediate press/release loops. Two additional executions force
  WGPU_BACKEND=vulkan, avoiding an assumption about default backend selection.
  The configured Vulkan ICD is software llvmpipe; these six native executions
  establish behavior, not hardware performance. Owned displays stop.

The first native command failed before the app because the runner used bare
python3 absent from PATH. That failed command/log/metadata remain in qualification;
the separate native-only runner verifies the completed prefix, all source guards
and the same binary, then uses the known absolute Python interpreter. No successful
test prefix was rerun or relabelled. Producer foreign library compilation remains
separate; no merged foreign application or runtime qualification is claimed.

## Behavior and costs

The pointer proof admits only its own pending caret-focus paint, with exact token,
source, viewport and namespace guards and a fresh acknowledged hit. It does not
weaken the general presentation gate. Session and optional session remain32B.
The built-in inspector still uses strict ACK admission on this source; its
point-specific P/C successor is isolated and not adopted.

Hummingbird now has an exclusively owned queue, shared immutable track payloads,
distinct duplicate occurrences, current/lookahead plans, selection and range
controls, reorder/remove/undo/shuffle/repeat operations and source-qualified rows.
The queue plan is a decoder boundary: this slice does not attach audio output.
Original behavior fixtures and explicit desired differences remain in the
producer archive. Native held-button success was insufficient; the rapid clients
now execute against the integrated fix.

Each controller has a globally unique checked session and strictly increasing
checked serial. Their pair already identifies an occurrence, including same-entry
restart and repeat, so its stamp need not duplicate the current entry key. On this
64-bit build PlanStamp24->16B, Plan/OptionPlan56->48B and controller200->192B.
Late/duplicate/foreign EOS and exhaustion revocation remain tested. These are
carrier sizes, not measured process RSS or summed dynamic stack peaks.

The six shipping first-party libraries measure30599 code lines including18 build
lines, +86 from89ae. Tests, comments, blanks, apps, vendors and support tools are
excluded. App source and tests remain separate; this source bill does not predict
final feature-complete size or claim the overall rewrite complete.
