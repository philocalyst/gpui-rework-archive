// Keep WASI clock waits off the Worker event loop. Immediate polls stay
// synchronous; only a future deadline suspends the WASM stack through JSPI.
import { Subscription, Event, EVENTTYPE_CLOCK, CLOCKID_MONOTONIC, CLOCKID_REALTIME,
  SUBCLOCKFLAGS_SUBSCRIPTION_CLOCK_ABSTIME, ERRNO_SUCCESS } from "./wasi/wasi_defs.js";

export function pollClock(wasi, input, output, subscriptions, count) {
  const fallback = () => wasi.wasiImport.poll_oneoff(input, output, subscriptions, count);
  if (subscriptions !== 1) return fallback();
  const subscription = Subscription.read_bytes(new DataView(wasi.inst.exports.memory.buffer), input);
  if (subscription.eventtype !== EVENTTYPE_CLOCK) return fallback();
  const now = subscription.clockid === CLOCKID_MONOTONIC
    ? () => BigInt(Math.round(performance.now() * 1e6))
    : subscription.clockid === CLOCKID_REALTIME ? () => BigInt(Date.now()) * 1_000_000n : undefined;
  if (!now) return fallback();
  const deadline = subscription.flags & SUBCLOCKFLAGS_SUBSCRIPTION_CLOCK_ABSTIME
    ? subscription.timeout : now() + subscription.timeout;
  if (deadline <= now()) return fallback();
  return (async () => {
    for (let remaining; (remaining = deadline - now()) > 0n;) {
      // Timers may wake early and are limited to signed 32-bit milliseconds.
      const milliseconds = Number((remaining + 999_999n) / 1_000_000n);
      await new Promise(resolve => setTimeout(resolve, Math.min(milliseconds, 2_147_483_647)));
    }
    // Reacquire the view after suspension; a WebAssembly memory can grow.
    const view = new DataView(wasi.inst.exports.memory.buffer);
    new Event(subscription.userdata, ERRNO_SUCCESS, EVENTTYPE_CLOCK).write_bytes(view, output);
    view.setUint32(count, 1, true);
    return ERRNO_SUCCESS;
  })();
}
