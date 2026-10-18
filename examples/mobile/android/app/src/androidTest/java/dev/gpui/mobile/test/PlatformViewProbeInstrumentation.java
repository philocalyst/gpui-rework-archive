package dev.gpui.mobile.test;

import android.app.Activity;
import android.app.Instrumentation;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.TextView;

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

            result.putString("status", "PASS");
            result.putString("detail",
                    "platform view lifecycle, layout, visibility, z-order, factory, cancellation, and Activity rebind passed");
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
