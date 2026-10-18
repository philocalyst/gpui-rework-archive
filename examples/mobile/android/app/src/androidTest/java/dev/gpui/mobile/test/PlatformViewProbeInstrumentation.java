package dev.gpui.mobile.test;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Instrumentation;
import android.content.Intent;
import android.os.Bundle;
import android.os.Process;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.TextView;

import dev.gpui.mobile.GpuiInputActivity;
import dev.gpui.mobile.GpuiPlatformView;
import dev.gpui.mobile.GpuiPlatformViewProbeActivity;

import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

/** No-dependency instrumentation probe for the debug-only Android platform-view bridge. */
public final class PlatformViewProbeInstrumentation extends Instrumentation {
    private static final String TAG = "GpuiPlatformViewProbe";
    private boolean preFixNoNativeHooks;

    @Override public void onCreate(Bundle arguments) {
        super.onCreate(arguments);
        String preFixValue = arguments == null ? null : arguments.getString("pre_fix_no_native_hooks");
        if (preFixValue != null && !"true".equals(preFixValue) && !"false".equals(preFixValue)) {
            throw new IllegalArgumentException("pre_fix_no_native_hooks must be the string true or false");
        }
        preFixNoNativeHooks = "true".equals(preFixValue);
        // Custom Instrumentation classes must explicitly start their runner thread.
        start();
    }

    @Override public void onStart() {
        super.onStart();
        Bundle result = new Bundle();
        Activity first = null;
        Activity second = null;
        try {
            first = launchProbeActivity();
            Activity firstActivity = first;
            runOnUi(() -> exerciseViewLifecycle(firstActivity));
            runOnUi(() -> check(GpuiPlatformView.createView(firstActivity, "container",
                    0x4750554906L, 11f, 12f, 80f, 40f, ""), "geometry probe create failed"));
            waitForIdleSync();
            runOnUi(() -> {
                FrameLayout actual = GpuiPlatformView.getContainer(0x4750554906L);
                float density = firstActivity.getResources().getDisplayMetrics().density;
                check(actual != null && actual.getWidth() == Math.round(80f * density)
                        && actual.getHeight() == Math.round(40f * density),
                        "attached Android View did not receive requested bounds");
                GpuiPlatformView.disposeView(0x4750554906L);
            });
            exerciseDisposeCancelsQueuedCreation(firstActivity, 0x4750554904L);
            waitForIdleSync();
            runOnMainSync(firstActivity::finish);
            waitForIdleSync();

            second = launchProbeActivity();
            Activity reopened = second;
            runOnUi(() -> exerciseRecreatedHost(reopened));
            waitForIdleSync();
            runOnMainSync(reopened::finish);
            waitForIdleSync();

            exerciseNativeActivityRecreation(result);

            result.putString("status", "PASS");
            result.putString("detail",
                    "platform view lifecycle/layout/visibility/z-order/factory/cancellation passed; "
                            + "NativeActivity recreation, generation-scoped presentation, same-process identity, and Back passed");
            Log.i(TAG, result.getString("detail"));
            finish(Activity.RESULT_OK, result);
        } catch (Throwable failure) {
            if (first != null) {
                Activity failedFirst = first;
                runOnMainSync(failedFirst::finish);
            }
            if (second != null) {
                Activity failedSecond = second;
                runOnMainSync(failedSecond::finish);
            }
            result.putString("status", "FAIL");
            result.putString("detail", failure.toString());
            Log.e(TAG, "platform view probe failed", failure);
            finish(Activity.RESULT_CANCELED, result);
        }
    }

    private void exerciseNativeActivityRecreation(Bundle result) throws Throwable {
        GpuiInputActivity original = null;
        GpuiInputActivity recreated = null;
        ActivityMonitor monitor = null;
        try {
            result.putString("pre_fix_no_native_hooks_argument",
                    preFixNoNativeHooks ? "true" : "false");
            result.putString("native_recreation_mode", preFixNoNativeHooks
                    ? "explicit-prefixed-pre-fix-no-hooks" : "strict-native-hooks-required");
            NativeHooks hooks = findNativeHooks();
            if (preFixNoNativeHooks) {
                check(hooks == null,
                        "pre-fix mode is only valid with an artifact that lacks native test hooks");
                result.putString("native_hooks", "absent as explicitly requested for pre-fix reproduction");
            } else {
                check(hooks != null,
                        "strict native recreation gate requires all three private native test hooks");
                result.putString("native_hooks", "present");
            }

            original = launchNativeActivity();
            awaitWindowFocused(original, 15_000);
            int originalPid = activityPid(original);
            result.putInt("instrumentation_process_pid", Process.myPid());
            result.putInt("original_activity_pid", originalPid);
            result.putString("original_activity_identity", Integer.toHexString(System.identityHashCode(original)));
            NativeSnapshot before = null;
            if (hooks != null) {
                before = awaitRendered(original, hooks, -1, 20_000);
                result.putLong("original_runtime_generation", before.generation);
                result.putLong("original_presented_generation", before.presentedGeneration);
                result.putBoolean("original_runtime_initialized", before.initialized);
            }

            monitor = new ActivityMonitor(GpuiInputActivity.class.getName(), null, false);
            addMonitor(monitor);
            GpuiInputActivity oldActivity = original;
            runOnUi(oldActivity::recreate);
            Activity observed = waitForMonitorWithTimeout(monitor, 20_000);
            check(observed instanceof GpuiInputActivity,
                    "Activity.recreate did not launch a distinct GpuiInputActivity instance");
            recreated = (GpuiInputActivity) observed;
            check(recreated != original, "Activity.recreate returned the original Java instance");
            result.putString("recreated_activity_identity", Integer.toHexString(System.identityHashCode(recreated)));
            boolean originalDestroyed = awaitDestroyed(original, 10_000);
            result.putBoolean("original_destroyed", originalDestroyed);
            check(originalDestroyed, "original Activity was not destroyed by recreate()");
            int recreatedPid = activityPid(recreated);
            result.putInt("recreated_activity_pid", recreatedPid);
            result.putInt("instrumentation_process_pid_after_recreate", Process.myPid());
            check(recreatedPid == originalPid,
                    "configuration recreation changed process PID: " + originalPid + " -> " + recreatedPid);
            awaitWindowFocused(recreated, 10_000);

            if (hooks == null) {
                // This branch is reachable only with the explicit
                // pre_fix_no_native_hooks instrumentation argument. It proves
                // the old Activity remains alive after recreation without
                // silently weakening the final strict gate.
                awaitLiveFor(recreated, 2_000);
                result.putString("native_recreation", "pre-fix Activity survived recreation");
            } else {
                NativeSnapshot after = awaitRendered(recreated, hooks,
                        before.generation + 1, 20_000);
                check(after.generation == before.generation + 1,
                        "native runtime generation did not advance exactly once: "
                                + before.generation + " -> " + after.generation);
                check(after.presentedGeneration == after.generation,
                        "recreated native runtime did not successfully present a frame: runtime="
                                + after.generation + " presented=" + after.presentedGeneration);
                check(after.initialized, "recreated native runtime did not initialize");
                check(!isFinishingOrDestroyed(recreated), "recreated Activity is already finishing or destroyed");
                result.putLong("recreated_runtime_generation", after.generation);
                result.putLong("recreated_presented_generation", after.presentedGeneration);
                result.putBoolean("recreated_runtime_initialized", after.initialized);
                result.putString("native_recreation", "new runtime initialized and presented after Activity.recreate");
            }

            if (hooks != null) {
                BackInputSnapshot beforeBack = readBackInputSnapshot(recreated);
                result.putBoolean("pre_back_ime_visible", beforeBack.imeVisible);
                result.putBoolean("pre_back_keyboard_session_active", beforeBack.keyboardSessionActive);
                result.putBoolean("pre_back_input_proxy_focused", beforeBack.inputProxyFocused);

                boolean hasEditingSession = beforeBack.imeVisible || beforeBack.keyboardSessionActive;
                if (hasEditingSession) {
                    check(beforeBack.inputProxyFocused,
                            "editing/IME state exists but the input proxy is not focused; refusing ambiguous Back test");
                    sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
                    BackInputSnapshot dismissed = awaitInputDismissed(recreated, 5_000);
                    result.putBoolean("first_back_dismissed_ime", !dismissed.imeVisible);
                    result.putBoolean("first_back_cleared_keyboard_session", !dismissed.keyboardSessionActive);
                    result.putBoolean("post_dismiss_input_proxy_focused", dismissed.inputProxyFocused);
                    check(!dismissed.imeVisible && !dismissed.keyboardSessionActive,
                            "first Back did not dismiss the active editing session");
                    check(!awaitFinishing(recreated, 100),
                            "first Back finished the Activity while dismissing an active editing session");
                } else {
                    check(!beforeBack.inputProxyFocused,
                            "input proxy is focused without an IME or keyboard session; refusing ambiguous Back test");
                    result.putBoolean("pre_back_no_editor_state", true);
                }
            }

            sendKeyDownUpSync(KeyEvent.KEYCODE_BACK);
            check(awaitFinishing(recreated, 5_000),
                    "normal Back did not finish the recreated NativeActivity");
            waitForIdleSync();
            result.putBoolean("normal_back_finished_recreated_activity", true);
        } finally {
            if (monitor != null) removeMonitor(monitor);
            if (recreated != null && !isFinishingOrDestroyed(recreated)) {
                GpuiInputActivity activity = recreated;
                runOnMainSync(activity::finish);
            }
            if (original != null && original != recreated && !isFinishingOrDestroyed(original)) {
                GpuiInputActivity activity = original;
                runOnMainSync(activity::finish);
            }
            waitForIdleSync();
        }
    }

    private static final class BackInputSnapshot {
        final boolean imeVisible;
        final boolean keyboardSessionActive;
        final boolean inputProxyFocused;
        BackInputSnapshot(boolean imeVisible, boolean keyboardSessionActive, boolean inputProxyFocused) {
            this.imeVisible = imeVisible;
            this.keyboardSessionActive = keyboardSessionActive;
            this.inputProxyFocused = inputProxyFocused;
        }
    }

    private BackInputSnapshot readBackInputSnapshot(GpuiInputActivity activity) throws Throwable {
        AtomicReference<BackInputSnapshot> snapshot = new AtomicReference<>();
        runOnUi(() -> {
            java.lang.reflect.Method imeVisible = GpuiInputActivity.class.getDeclaredMethod("imeVisibleForTest");
            java.lang.reflect.Method keyboardSession = GpuiInputActivity.class.getDeclaredMethod("keyboardSessionActiveForTest");
            java.lang.reflect.Method proxyFocused = GpuiInputActivity.class.getDeclaredMethod("inputProxyFocusedForTest");
            imeVisible.setAccessible(true);
            keyboardSession.setAccessible(true);
            proxyFocused.setAccessible(true);
            check(imeVisible.getReturnType() == boolean.class
                            && keyboardSession.getReturnType() == boolean.class
                            && proxyFocused.getReturnType() == boolean.class,
                    "Back input diagnostic hooks have unexpected return types");
            snapshot.set(new BackInputSnapshot(
                    ((Boolean) imeVisible.invoke(activity)).booleanValue(),
                    ((Boolean) keyboardSession.invoke(activity)).booleanValue(),
                    ((Boolean) proxyFocused.invoke(activity)).booleanValue()));
        });
        return snapshot.get();
    }

    private BackInputSnapshot awaitInputDismissed(GpuiInputActivity activity, long timeoutMs) throws Throwable {
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        BackInputSnapshot last;
        do {
            last = readBackInputSnapshot(activity);
            if (!last.imeVisible && !last.keyboardSessionActive) return last;
            Thread.sleep(50);
        } while (SystemClock.uptimeMillis() < deadline);
        return last;
    }

    private GpuiInputActivity launchNativeActivity() {
        Intent intent = new Intent(getTargetContext(), GpuiInputActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        Activity activity = startActivitySync(intent);
        check(activity instanceof GpuiInputActivity,
                "NativeActivity did not start: " + (activity == null ? "null" : activity.getClass()));
        return (GpuiInputActivity) activity;
    }

    private NativeHooks findNativeHooks() throws Exception {
        String[] names = {
                "runtimeGenerationForTest",
                "runtimeInitializedForTest",
                "presentedFrameGenerationForTest"
        };
        java.lang.reflect.Method[] methods = new java.lang.reflect.Method[names.length];
        int found = 0;
        for (int i = 0; i < names.length; i++) {
            try {
                methods[i] = GpuiInputActivity.class.getDeclaredMethod(names[i]);
                methods[i].setAccessible(true);
                found++;
            } catch (NoSuchMethodException missing) {
                // Missing hooks are tolerated only by the explicitly selected
                // pre-fix mode; a partial hook set is never accepted.
            }
        }
        if (found == 0) return null;
        check(found == names.length, "partial native recreation hook set: " + found + "/" + names.length);
        check(methods[0].getReturnType() == long.class
                        && methods[1].getReturnType() == boolean.class
                        && methods[2].getReturnType() == long.class,
                "native recreation hooks have unexpected return types");
        return new NativeHooks(methods[0], methods[1], methods[2]);
    }

    private static final class NativeHooks {
        final java.lang.reflect.Method generation;
        final java.lang.reflect.Method initialized;
        final java.lang.reflect.Method presented;
        NativeHooks(java.lang.reflect.Method generation, java.lang.reflect.Method initialized,
                    java.lang.reflect.Method presented) {
            this.generation = generation;
            this.initialized = initialized;
            this.presented = presented;
        }
        NativeSnapshot read() throws Exception {
            return new NativeSnapshot(((Long) generation.invoke(null)).longValue(),
                    ((Boolean) initialized.invoke(null)).booleanValue(),
                    ((Long) presented.invoke(null)).longValue());
        }
    }

    private static final class NativeSnapshot {
        final long generation;
        final boolean initialized;
        final long presentedGeneration;
        NativeSnapshot(long generation, boolean initialized, long presentedGeneration) {
            this.generation = generation;
            this.initialized = initialized;
            this.presentedGeneration = presentedGeneration;
        }
    }

    private NativeSnapshot awaitRendered(GpuiInputActivity activity, NativeHooks hooks,
                                         long expectedGeneration, long timeoutMs) throws Exception {
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        NativeSnapshot last = new NativeSnapshot(0, false, 0);
        while (SystemClock.uptimeMillis() < deadline) {
            check(!activity.isFinishing(), "NativeActivity began finishing while waiting for a presented frame");
            last = hooks.read();
            if (last.initialized && last.generation > 0
                    && last.presentedGeneration == last.generation
                    && (expectedGeneration < 0 || last.generation == expectedGeneration)) return last;
            Thread.sleep(100);
        }
        throw new AssertionError("timed out waiting for native presentation: expected generation="
                + expectedGeneration + " last generation=" + last.generation + " initialized="
                + last.initialized + " presented=" + last.presentedGeneration);
    }

    private int activityPid(Activity activity) {
        ActivityManager manager = (ActivityManager) activity.getSystemService(Activity.ACTIVITY_SERVICE);
        String processName = activity.getApplicationInfo().processName;
        java.util.List<ActivityManager.RunningAppProcessInfo> processes =
                manager == null ? null : manager.getRunningAppProcesses();
        if (processes != null) {
            for (ActivityManager.RunningAppProcessInfo process : processes) {
                if (processName.equals(process.processName)) return process.pid;
            }
        }
        throw new AssertionError("could not find the NativeActivity process " + processName);
    }

    private boolean isFinishingOrDestroyed(Activity activity) throws Throwable {
        AtomicBoolean unavailable = new AtomicBoolean();
        runOnUi(() -> unavailable.set(activity.isFinishing() || activity.isDestroyed()));
        return unavailable.get();
    }

    private void awaitWindowFocused(Activity activity, long timeoutMs) throws Throwable {
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        AtomicBoolean focused = new AtomicBoolean();
        AtomicBoolean unavailable = new AtomicBoolean();
        while (SystemClock.uptimeMillis() < deadline) {
            runOnUi(() -> {
                unavailable.set(activity.isFinishing() || activity.isDestroyed());
                focused.set(activity.getWindow().getDecorView().hasWindowFocus());
            });
            check(!unavailable.get(), "NativeActivity finished before gaining window focus");
            if (focused.get()) return;
            Thread.sleep(100);
        }
        throw new AssertionError("NativeActivity never gained window focus");
    }

    private boolean awaitDestroyed(Activity activity, long timeoutMs) throws Throwable {
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        AtomicBoolean destroyed = new AtomicBoolean();
        while (SystemClock.uptimeMillis() < deadline) {
            runOnUi(() -> destroyed.set(activity.isDestroyed()));
            if (destroyed.get()) return true;
            Thread.sleep(50);
        }
        runOnUi(() -> destroyed.set(activity.isDestroyed()));
        return destroyed.get();
    }

    private void awaitLiveFor(Activity activity, long durationMs) throws Throwable {
        long deadline = SystemClock.uptimeMillis() + durationMs;
        AtomicBoolean unavailable = new AtomicBoolean();
        while (SystemClock.uptimeMillis() < deadline) {
            runOnUi(() -> unavailable.set(activity.isFinishing() || activity.isDestroyed()));
            check(!unavailable.get(),
                    "recreated Activity did not remain alive after configuration change");
            awaitWindowFocused(activity, Math.min(500, Math.max(1, deadline - SystemClock.uptimeMillis())));
            Thread.sleep(100);
        }
    }

    private boolean awaitFinishing(Activity activity, long timeoutMs) throws Throwable {
        long deadline = SystemClock.uptimeMillis() + timeoutMs;
        AtomicBoolean finished = new AtomicBoolean();
        while (SystemClock.uptimeMillis() < deadline) {
            runOnUi(() -> finished.set(activity.isFinishing() || activity.isDestroyed()));
            if (finished.get()) return true;
            Thread.sleep(50);
        }
        runOnUi(() -> finished.set(activity.isFinishing() || activity.isDestroyed()));
        return finished.get();
    }

    private void runOnUi(UiAction action) throws Throwable {
        AtomicReference<Throwable> failure = new AtomicReference<>();
        runOnMainSync(() -> {
            try {
                action.run();
            } catch (Throwable error) {
                failure.set(error);
            }
        });
        if (failure.get() != null) throw failure.get();
    }

    private interface UiAction {
        void run() throws Throwable;
    }

    private Activity launchProbeActivity() {
        Intent intent = new Intent(getTargetContext(), GpuiPlatformViewProbeActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        Activity activity = startActivitySync(intent);
        check(activity != null, "probe Activity did not start");
        return activity;
    }

    private void exerciseViewLifecycle(Activity activity) throws Throwable {
        GpuiPlatformView.disposeAll();
        GpuiPlatformView.pauseAll();

        final long id = 0x4750554901L;
        String html = "<html><body style='background:#26a269;color:white'>probe</body></html>";
        String params = "html=" + html + "|javascript_enabled=false";
        check(GpuiPlatformView.createView(activity, "webview", id,
                13.25f, 7.5f, 120f, 64f, params), "WebView create failed");
        View child = GpuiPlatformView.getView(id);
        FrameLayout container = GpuiPlatformView.getContainer(id);
        check(child instanceof WebView, "webview factory returned " + child);
        check(container != null && container.getParent() instanceof ViewGroup,
                "positioned container was not attached");
        check(container.getVisibility() == View.GONE,
                "create queued while paused must start GONE");

        AtomicInteger pauseCalls = new AtomicInteger();
        AtomicInteger resumeCalls = new AtomicInteger();
        long lifecycleId = id + 10;
        GpuiPlatformView.registerViewFactory("probe_lifecycle", new GpuiPlatformView.ViewFactory() {
            @Override public View create(Activity host, Map<String, String> creationParams) {
                return new TextView(host);
            }

            @Override public void onPause(View view) {
                pauseCalls.incrementAndGet();
            }

            @Override public void onResume(View view) {
                resumeCalls.incrementAndGet();
            }
        });
        check(GpuiPlatformView.createView(activity, "probe_lifecycle", lifecycleId,
                0f, 0f, 24f, 20f, ""), "lifecycle factory create failed while paused");
        check(pauseCalls.get() == 1 && resumeCalls.get() == 0,
                "view created in paused state did not receive exactly one pause callback");

        float density = activity.getResources().getDisplayMetrics().density;
        FrameLayout.LayoutParams bounds = (FrameLayout.LayoutParams) container.getLayoutParams();
        check(bounds.leftMargin == Math.round(13.25f * density), "x bounds not converted to device pixels");
        check(bounds.topMargin == Math.round(7.5f * density), "y bounds not converted to device pixels");
        check(bounds.width == Math.round(120f * density), "width bounds not converted to device pixels");
        check(bounds.height == Math.round(64f * density), "height bounds not converted to device pixels");

        GpuiPlatformView.resumeAll();
        check(container.getVisibility() == View.VISIBLE, "resume did not restore requested visibility");
        check(resumeCalls.get() == 1 && pauseCalls.get() == 1,
                "resume transition was not delivered exactly once");
        GpuiPlatformView.resumeAll();
        check(resumeCalls.get() == 1, "duplicate resume delivered a duplicate callback");
        GpuiPlatformView.pauseAll();
        check(pauseCalls.get() == 2, "pause transition was not delivered exactly once");
        GpuiPlatformView.pauseAll();
        check(pauseCalls.get() == 2, "duplicate pause delivered a duplicate callback");
        GpuiPlatformView.resumeAll();
        check(resumeCalls.get() == 2, "second resume transition was not delivered");
        GpuiPlatformView.disposeView(lifecycleId);
        GpuiPlatformView.unregisterViewFactory("probe_lifecycle");
        GpuiPlatformView.setVisible(id, false);
        check(container.getVisibility() == View.GONE, "setVisible(false) failed");
        GpuiPlatformView.pauseAll();
        GpuiPlatformView.resumeAll();
        check(container.getVisibility() == View.GONE, "resume incorrectly exposed explicitly hidden view");
        GpuiPlatformView.setVisible(id, true);
        check(container.getVisibility() == View.VISIBLE, "setVisible(true) failed");
        GpuiPlatformView.setZIndex(id, 7);
        check(container.getZ() == 7f, "z index did not reach native container");

        long selfDisposeId = id + 20;
        GpuiPlatformView.registerViewFactory("probe_self_dispose", (host, creationParams) ->
                new View(host) {
                    @Override protected void onAttachedToWindow() {
                        super.onAttachedToWindow();
                        GpuiPlatformView.disposeView(selfDisposeId);
                    }
                });
        check(!GpuiPlatformView.createView(activity, "probe_self_dispose", selfDisposeId,
                        0f, 0f, 30f, 30f, ""),
                "self-dispose from onAttachedToWindow must prevent create success");
        check(GpuiPlatformView.getView(selfDisposeId) == null
                        && GpuiPlatformView.getContainer(selfDisposeId) == null,
                "self-disposed attached view remained registered");
        GpuiPlatformView.unregisterViewFactory("probe_self_dispose");

        AtomicInteger reentrantPauses = new AtomicInteger();
        AtomicInteger reentrantResumes = new AtomicInteger();
        AtomicBoolean reenterResume = new AtomicBoolean(true);
        GpuiPlatformView.registerViewFactory("probe_reentrant_lifecycle", new GpuiPlatformView.ViewFactory() {
            @Override public View create(Activity host, Map<String, String> creationParams) {
                return new TextView(host);
            }

            @Override public void onPause(View view) {
                reentrantPauses.incrementAndGet();
                if (reenterResume.compareAndSet(true, false)) GpuiPlatformView.resumeAll();
            }

            @Override public void onResume(View view) {
                reentrantResumes.incrementAndGet();
            }
        });
        long reentrantOne = id + 21;
        long reentrantTwo = id + 22;
        check(GpuiPlatformView.createView(activity, "probe_reentrant_lifecycle", reentrantOne,
                0f, 0f, 20f, 20f, ""), "first reentrant lifecycle view failed to create");
        check(GpuiPlatformView.createView(activity, "probe_reentrant_lifecycle", reentrantTwo,
                0f, 0f, 20f, 20f, ""), "second reentrant lifecycle view failed to create");
        GpuiPlatformView.pauseAll();
        check(reentrantPauses.get() == 1 && reentrantResumes.get() == 1,
                "reentrant resume did not stop the stale pause transition loop");
        check(GpuiPlatformView.getContainer(reentrantOne).getVisibility() == View.VISIBLE
                        && GpuiPlatformView.getContainer(reentrantTwo).getVisibility() == View.VISIBLE,
                "reentrant pause/resume left a view hidden");
        GpuiPlatformView.pauseAll();
        check(reentrantPauses.get() == 3,
                "a later pause did not reconcile both views after the reentrant transition");
        GpuiPlatformView.resumeAll();
        check(reentrantResumes.get() == 3,
                "a later resume did not reconcile both views after the reentrant transition");
        GpuiPlatformView.disposeView(reentrantOne);
        GpuiPlatformView.disposeView(reentrantTwo);
        GpuiPlatformView.unregisterViewFactory("probe_reentrant_lifecycle");

        GpuiPlatformView.setBounds(id, 3f, 5f, 90f, 45f);
        bounds = (FrameLayout.LayoutParams) container.getLayoutParams();
        check(bounds.leftMargin == Math.round(3f * density) && bounds.topMargin == Math.round(5f * density),
                "updated bounds were not applied");
        check(!GpuiPlatformView.createView(activity, "video_player", id + 1,
                0f, 0f, 20f, 20f, ""), "unregistered video type must fail explicitly");
        check(!GpuiPlatformView.createView(activity, "missing_type", id + 2,
                0f, 0f, 20f, 20f, ""), "unknown type must fail explicitly");

        GpuiPlatformView.disposeView(id);
        check(GpuiPlatformView.getView(id) == null && GpuiPlatformView.getContainer(id) == null,
                "disposeView did not detach the view");
        check(GpuiPlatformView.createView(activity, "web_view", id,
                0f, 0f, 60f, 40f, "html=<html>reopened</html>"),
                "same-ID reopen after disposal failed");
        GpuiPlatformView.disposeView(id);

        GpuiPlatformView.registerViewFactory("probe_custom", (host, creationParams) -> {
            check("registered".equals(creationParams.get("label")), "creation params not parsed");
            return new TextView(host);
        });
        check(GpuiPlatformView.createView(activity, "probe_custom", id + 3,
                0f, 0f, 50f, 30f, "label=registered"),
                "registered custom factory was not used");
        check(GpuiPlatformView.getView(id + 3) instanceof TextView,
                "custom factory view not attached");
        GpuiPlatformView.disposeView(id + 3);
        GpuiPlatformView.unregisterViewFactory("probe_custom");

        GpuiPlatformView.disposeAll();
        check(GpuiPlatformView.getView(id) == null, "disposeAll retained a child");
    }

    private void exerciseDisposeCancelsQueuedCreation(Activity activity, long id) throws Throwable {
        CountDownLatch enteredFactory = new CountDownLatch(1);
        CountDownLatch releaseFactory = new CountDownLatch(1);
        AtomicBoolean disposed = new AtomicBoolean();
        AtomicBoolean result = new AtomicBoolean(true);
        GpuiPlatformView.registerViewFactory("probe_blocking", new GpuiPlatformView.ViewFactory() {
            @Override public View create(Activity host, Map<String, String> params) throws Exception {
                enteredFactory.countDown();
                if (!releaseFactory.await(3, TimeUnit.SECONDS)) {
                    throw new IllegalStateException("probe did not release blocked factory");
                }
                return new TextView(host);
            }

            @Override public void dispose(View view) {
                disposed.set(true);
            }
        });

        Thread creator = new Thread(() -> result.set(GpuiPlatformView.createView(activity,
                "probe_blocking", id, 0f, 0f, 40f, 30f, "")), "platform-view-create-probe");
        creator.start();
        check(enteredFactory.await(2, TimeUnit.SECONDS), "blocking factory was not entered");
        // Cancellation is immediate even while the main-thread factory is running.
        GpuiPlatformView.disposeView(id);
        releaseFactory.countDown();
        creator.join(3_000);
        check(!creator.isAlive(), "create caller did not complete after cancellation");
        check(!result.get(), "cancelled create reported success");
        check(disposed.get(), "late factory result was not disposed");
        check(GpuiPlatformView.getView(id) == null, "cancelled late result attached to root");
        GpuiPlatformView.unregisterViewFactory("probe_blocking");
    }

    private void exerciseRecreatedHost(Activity activity) {
        GpuiPlatformView.disposeAll();
        check(GpuiPlatformView.createView(activity, "container", 0x4750554905L,
                1f, 2f, 32f, 24f, ""), "new Activity could not create a view");
        check(GpuiPlatformView.getContainer(0x4750554905L) != null,
                "new Activity root was not recreated");
        GpuiPlatformView.disposeAll();
    }

    private static void check(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }
}
