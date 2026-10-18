package dev.gpui.mobile;

import android.app.Activity;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import java.lang.ref.WeakReference;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/**
 * UI-thread bridge for native GPUI platform views.
 *
 * <p>Views are attached above the NativeActivity surface. Custom view types can
 * be installed with {@link #registerViewFactory(String, ViewFactory)}. The
 * built-in types are {@code container} and {@code webview} (also
 * {@code web_view}). Video, camera, and map views are deliberately not
 * fabricated here; an application must register a real factory for them.</p>
 *
 * <p>All Android View mutations happen on the main thread. The synchronous
 * create method is called from GPUI's native thread and has a bounded wait;
 * it executes inline when already on the main thread.</p>
 */
public final class GpuiPlatformView {
    private static final String TAG = "GpuiPlatformView";
    private static final long CREATE_TIMEOUT_MILLIS = 5_000L;
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final Object STATE_LOCK = new Object();
    private static final Map<Long, Entry> ENTRIES = new HashMap<>();
    private static final Map<String, ViewFactory> FACTORIES = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<Long, CreateRequest> CREATES = new ConcurrentHashMap<>();
    private static final int REQUEST_PENDING = 0;
    private static final int REQUEST_CANCELLED = 1;
    private static final int REQUEST_SUCCEEDED = 2;
    private static final int REQUEST_FAILED = 3;

    private static volatile WeakReference<Activity> host = new WeakReference<>(null);
    private static final AtomicLong HOST_GENERATION = new AtomicLong();
    // Main-thread only. This static view retains its Activity through Context,
    // so every Activity destruction path detaches it in unbindActivity().
    private static FrameLayout root;
    private static boolean paused;
    // Main-thread only; reentrant lifecycle callbacks invalidate stale loops.
    private static long lifecycleGeneration;

    private GpuiPlatformView() {}

    /** Creates a platform view from application-provided Android Views. */
    public interface ViewFactory {
        /** Return a real Android View, or throw to report a creation failure. */
        View create(Activity activity, Map<String, String> creationParams) throws Exception;

        /** Release any resources owned by a custom view. Called on the UI thread. */
        /** Pause view-owned work when the host Activity pauses. Called on the UI thread. */
        default void onPause(View view) throws Exception {
            if (view instanceof WebView) ((WebView) view).onPause();
        }

        /** Resume view-owned work when the host Activity resumes. Called on the UI thread. */
        default void onResume(View view) throws Exception {
            if (view instanceof WebView) ((WebView) view).onResume();
        }

        /** Release any resources owned by a custom view. Called on the UI thread. */
        default void dispose(View view) {
            if (view instanceof WebView) {
                WebView web = (WebView) view;
                web.stopLoading();
                web.destroy();
            } else if (view instanceof ViewGroup) {
                ((ViewGroup) view).removeAllViews();
            }
        }
    }

    /** Register or replace a factory. Registration is safe from any thread. */
    public static void registerViewFactory(String viewType, ViewFactory factory) {
        if (viewType == null || viewType.trim().isEmpty() || factory == null) {
            throw new IllegalArgumentException("viewType and factory are required");
        }
        FACTORIES.put(viewType, factory);
    }

    /** Remove an application-registered factory. Built-in types remain available. */
    public static void unregisterViewFactory(String viewType) {
        if (viewType != null) FACTORIES.remove(viewType);
    }

    /** Bind the current NativeActivity. Call from Activity.onCreate on the UI thread. */
    public static void bindActivity(Activity activity) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("bindActivity must run on the UI thread");
        }
        if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
            throw new IllegalArgumentException("activity is not live");
        }
        Activity old = host.get();
        if (old != activity) {
            invalidateCreates();
            HOST_GENERATION.incrementAndGet();
            clearViewsAndRoot();
            host = new WeakReference<>(activity);
            paused = false;
        }
    }

    /** Unbind and release all view trees before the Activity can be retained by a View context. */
    public static void unbindActivity(Activity activity) {
        Runnable cleanup = () -> {
            if (host.get() != activity) return;
            invalidateCreates();
            HOST_GENERATION.incrementAndGet();
            clearViewsAndRoot();
            host = new WeakReference<>(null);
            paused = false;
        };
        runOnMain(cleanup);
    }

    /**
     * JNI entry point. Creation is synchronous and returns false on unsupported
     * types, invalid bounds, factory errors, timeout, or host replacement.
     */
    public static boolean createView(
            Activity activity,
            String viewType,
            long viewId,
            float x,
            float y,
            float width,
            float height,
            String creationParams) {
        if (activity == null || viewType == null || viewType.isEmpty() || viewId <= 0
                || !validLogicalBounds(x, y, width, height)) {
            return false;
        }

        CreateRequest request = new CreateRequest(viewId, activity, HOST_GENERATION.get());
        if (CREATES.putIfAbsent(viewId, request) != null) {
            Log.e(TAG, "duplicate create request for id=" + viewId);
            return false;
        }

        Runnable create = () -> createOnMain(request, viewType, x, y, width, height, creationParams);
        if (Looper.myLooper() == Looper.getMainLooper()) {
            create.run();
        } else if (!MAIN.post(create)) {
            finishRequest(request, false);
            return false;
        }

        try {
            if (!request.done.await(CREATE_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS)) {
                if (request.status.compareAndSet(REQUEST_PENDING, REQUEST_CANCELLED)) {
                    CREATES.remove(viewId, request);
                    Log.e(TAG, "createView timed out; request cancelled id=" + viewId);
                }
                return request.status.get() == REQUEST_SUCCEEDED;
            }
        } catch (InterruptedException interrupted) {
            boolean cancelled = request.status.compareAndSet(REQUEST_PENDING, REQUEST_CANCELLED);
            if (cancelled) CREATES.remove(viewId, request);
            Thread.currentThread().interrupt();
            Log.e(TAG, "createView interrupted; request cancelled id=" + viewId);
            return request.status.get() == REQUEST_SUCCEEDED;
        }
        return request.status.get() == REQUEST_SUCCEEDED;
    }

    private static void createOnMain(
            CreateRequest request,
            String viewType,
            float x,
            float y,
            float width,
            float height,
            String encodedParams) {
        View child = null;
        ViewFactory factory = null;
        FrameLayout container = null;
        Entry createdEntry = null;
        try {
            if (request.status.get() != REQUEST_PENDING) {
                finishRequest(request, false);
                return;
            }
            Activity activity = request.activity.get();
            if (!isCurrentHost(activity, request.generation)) {
                finishRequest(request, false);
                return;
            }

            float density = activity.getResources().getDisplayMetrics().density;
            if (!validBounds(x, y, width, height, density)) {
                finishRequest(request, false);
                return;
            }
            Map<String, String> params = parseCreationParams(encodedParams);
            factory = FACTORIES.get(viewType);
            if (factory == null) factory = builtinFactory(viewType);
            if (factory == null) {
                Log.e(TAG, "no registered platform view factory for type='" + viewType + "'");
                finishRequest(request, false);
                return;
            }

            // Factory work runs on main because Android Views must be created there.
            child = factory.create(activity, Collections.unmodifiableMap(params));
            if (child == null) throw new IllegalStateException("factory returned null View");
            container = new FrameLayout(activity);
            container.setClipChildren(true);
            container.setClipToPadding(true);
            container.addView(child, new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            applyBounds(activity, container, x, y, width, height);

            // Lifecycle and View operations may synchronously call application
            // code. None run while holding a cancellation or registry lock.
            Entry entry = new Entry(request.id, container, child, factory);
            createdEntry = entry;
            if (!prepareDetachedEntry(entry, request, activity)) {
                disposeEntry(entry);
                finishRequest(request, false);
                return;
            }

            FrameLayout parent = ensureRoot(activity);
            if (!requestIsCurrent(request, activity)) {
                disposeEntry(entry);
                finishRequest(request, false);
                return;
            }
            boolean duplicate;
            synchronized (STATE_LOCK) {
                duplicate = ENTRIES.containsKey(request.id);
                // Install before addView: onAttachedToWindow can synchronously
                // dispose this id and must find the pending entry.
                if (!duplicate) ENTRIES.put(request.id, entry);
            }
            if (duplicate) {
                finishRequest(request, false);
                disposeEntry(entry);
                return;
            }
            parent.addView(container);
            if (!requestIsCurrent(request, activity) || entry(request.id) != entry) {
                removeEntryIfSame(request.id, entry);
                finishRequest(request, false);
                return;
            }

            applyVisibility(entry);
            if (!requestIsCurrent(request, activity) || entry(request.id) != entry) {
                removeEntryIfSame(request.id, entry);
                finishRequest(request, false);
                return;
            }
            if (!request.status.compareAndSet(REQUEST_PENDING, REQUEST_SUCCEEDED)) {
                removeEntryIfSame(request.id, entry);
                return;
            }
        } catch (Throwable error) {
            if (createdEntry != null) {
                if (!removeEntryIfSame(request.id, createdEntry)) disposeEntry(createdEntry);
            } else if (factory != null && child != null) {
                disposeDetached(factory, child);
            }
            Log.e(TAG, "failed to create platform view type='" + viewType + "'", error);
            finishRequest(request, false);
        } finally {
            request.done.countDown();
            CREATES.remove(request.id, request);
        }
    }

    private static boolean isCurrentHost(Activity activity, long generation) {
        return activity != null
                && !activity.isFinishing()
                && !activity.isDestroyed()
                && activity == host.get()
                && generation == HOST_GENERATION.get();
    }

    private static FrameLayout ensureRoot(Activity activity) {
        if (root != null && root.getParent() != null) return root;
        FrameLayout next = new FrameLayout(activity);
        next.setClipChildren(false);
        next.setClipToPadding(false);
        next.setFocusable(false);
        next.setFocusableInTouchMode(false);
        activity.addContentView(next, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));
        root = next;
        return next;
    }

    private static void applyBounds(
            Activity activity, FrameLayout container,
            float x, float y, float width, float height) {
        float density = activity.getResources().getDisplayMetrics().density;
        if (!validBounds(x, y, width, height, density)) {
            throw new IllegalArgumentException("bounds exceed Android pixel limits");
        }
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                pixels(width, density), pixels(height, density));
        lp.leftMargin = pixels(x, density);
        lp.topMargin = pixels(y, density);
        container.setLayoutParams(lp);
    }

    private static int pixels(float logical, float density) {
        return (int) Math.round((double) logical * (double) density);
    }

    private static boolean validLogicalBounds(float x, float y, float width, float height) {
        return Float.isFinite(x) && Float.isFinite(y) && Float.isFinite(width)
                && Float.isFinite(height) && width >= 0 && height >= 0;
    }

    private static boolean validBounds(
            float x, float y, float width, float height, float density) {
        if (!validLogicalBounds(x, y, width, height) || !Float.isFinite(density) || density <= 0) {
            return false;
        }
        return fitsPixel(x, density) && fitsPixel(y, density)
                && fitsPixel(width, density) && fitsPixel(height, density);
    }

    private static boolean fitsPixel(float logical, float density) {
        double pixels = (double) logical * (double) density;
        return Double.isFinite(pixels) && pixels >= Integer.MIN_VALUE
                && pixels <= Integer.MAX_VALUE;
    }

    private static ViewFactory builtinFactory(String type) {
        if ("container".equals(type)) {
            return (activity, params) -> {
                FrameLayout frame = new FrameLayout(activity);
                frame.setBackgroundColor(Color.TRANSPARENT);
                return frame;
            };
        }
        if ("webview".equals(type) || "web_view".equals(type)) {
            return GpuiPlatformView::createWebView;
        }
        return null;
    }

    private static View createWebView(Activity activity, Map<String, String> params) {
        WebView web = new WebView(activity);
        try {
            WebSettings settings = web.getSettings();
            settings.setJavaScriptEnabled(boolParam(params, "javascript_enabled", true));
            settings.setDomStorageEnabled(boolParam(params, "dom_storage_enabled", true));
            boolean zoom = boolParam(params, "zoom_enabled", true);
            settings.setBuiltInZoomControls(zoom);
            settings.setDisplayZoomControls(false);
            settings.setLoadWithOverviewMode(true);
            settings.setUseWideViewPort(true);
            web.setWebViewClient(new WebViewClient());
            web.setWebChromeClient(new WebChromeClient());

            String html = params.get("html");
            String url = params.get("url");
            if (html != null && !html.isEmpty()) {
                web.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null);
            } else if (url != null && !url.isEmpty()) {
                web.loadUrl(url);
            }
            return web;
        } catch (RuntimeException error) {
            web.destroy();
            throw error;
        }
    }

    private static boolean boolParam(Map<String, String> params, String key, boolean fallback) {
        String value = params.get(key);
        return value == null ? fallback : Boolean.parseBoolean(value);
    }

    private static Map<String, String> parseCreationParams(String encoded) {
        Map<String, String> params = new HashMap<>();
        if (encoded == null || encoded.isEmpty()) return params;
        for (String part : encoded.split("\\|")) {
            int equals = part.indexOf('=');
            if (equals > 0) params.put(part.substring(0, equals), part.substring(equals + 1));
        }
        return params;
    }

    /** JNI entry point: update logical-pixel bounds. */
    public static void setBounds(long viewId, float x, float y, float width, float height) {
        runOnMain(() -> {
            Activity activity = host.get();
            Entry entry = entry(viewId);
            if (activity == null || entry == null) return;
            float density = activity.getResources().getDisplayMetrics().density;
            if (!validBounds(x, y, width, height, density)) return;
            applyBounds(activity, entry.container, x, y, width, height);
        });
    }

    /** JNI entry point: requested visibility is retained across pause/resume. */
    public static void setVisible(long viewId, boolean visible) {
        runOnMain(() -> {
            Entry entry = entry(viewId);
            if (entry == null) return;
            entry.requestedVisible = visible;
            applyVisibility(entry);
        });
    }

    /** JNI entry point: higher z-indices draw above lower ones. */
    public static void setZIndex(long viewId, int zIndex) {
        runOnMain(() -> {
            Entry entry = entry(viewId);
            if (entry != null) entry.container.setZ((float) zIndex);
        });
    }

    /** JNI entry point: dispose one view and invalidate any queued creation. */
    public static void disposeView(long viewId) {
        CreateRequest request = CREATES.get(viewId);
        if (request != null) request.status.compareAndSet(REQUEST_PENDING, REQUEST_CANCELLED);
        runOnMain(() -> removeEntry(viewId));
    }

    /** JNI lifecycle entry point. */
    public static void pauseAll() {
        runOnMain(() -> transitionAll(true));
    }

    /** JNI lifecycle entry point. */
    public static void resumeAll() {
        runOnMain(() -> transitionAll(false));
    }

    /** JNI shutdown entry point; safe to call repeatedly. */
    public static void disposeAll() {
        invalidateCreates();
        HOST_GENERATION.incrementAndGet();
        runOnMain(GpuiPlatformView::clearViewsAndRoot);
    }

    /** Return a view for application integration; call only on the UI thread. */
    public static View getView(long viewId) {
        return Looper.myLooper() == Looper.getMainLooper() && entry(viewId) != null
                ? entry(viewId).child : null;
    }

    /** Return its positioned host container; call only on the UI thread. */
    public static FrameLayout getContainer(long viewId) {
        Entry entry = Looper.myLooper() == Looper.getMainLooper() ? entry(viewId) : null;
        return entry == null ? null : entry.container;
    }

    /** UI-thread hit test for Java-side integrations. */
    public static boolean hitTest(float x, float y) {
        if (Looper.myLooper() != Looper.getMainLooper()) return false;
        for (Entry entry : snapshotEntries()) {
            View view = entry.container;
            if (view.getVisibility() != View.VISIBLE) continue;
            int[] location = new int[2];
            view.getLocationOnScreen(location);
            if (x >= location[0] && x < location[0] + view.getWidth()
                    && y >= location[1] && y < location[1] + view.getHeight()) return true;
        }
        return false;
    }

    /** Dispose root and all native children, releasing Activity contexts. UI thread only. */
    private static void clearViewsAndRoot() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("cleanup must run on UI thread");
        }
        for (Entry entry : snapshotEntries()) disposeEntry(entry);
        synchronized (STATE_LOCK) {
            ENTRIES.clear();
        }
        FrameLayout oldRoot = root;
        root = null;
        if (oldRoot != null && oldRoot.getParent() instanceof ViewGroup) {
            ((ViewGroup) oldRoot.getParent()).removeView(oldRoot);
        }
        paused = false;
        lifecycleGeneration++;
    }

    private static void removeEntry(long id) {
        Entry entry;
        synchronized (STATE_LOCK) {
            entry = ENTRIES.remove(id);
        }
        if (entry != null) disposeEntry(entry);
    }

    private static void disposeEntry(Entry entry) {
        if (entry.disposed.compareAndSet(false, true)) {
            if (entry.container.getParent() instanceof ViewGroup) {
                ((ViewGroup) entry.container.getParent()).removeView(entry.container);
            }
            entry.container.removeAllViews();
            try {
                entry.factory.dispose(entry.child);
            } catch (Throwable error) {
                Log.e(TAG, "custom platform view disposal failed", error);
            }
        }
    }

    private static void disposeDetached(ViewFactory factory, View child) {
        try {
            factory.dispose(child);
        } catch (Throwable error) {
            Log.e(TAG, "failed to release unattached platform view", error);
        }
    }

    private static void transitionAll(boolean shouldPause) {
        if (paused == shouldPause) return;
        paused = shouldPause;
        long generation = ++lifecycleGeneration;
        for (Entry entry : snapshotEntries()) {
            if (generation != lifecycleGeneration) return;
            transitionLifecycle(entry, shouldPause, generation);
            if (generation != lifecycleGeneration) return;
            if (entry(entry.id) == entry) applyVisibility(entry);
            if (generation != lifecycleGeneration) return;
        }
    }

    private static boolean prepareDetachedEntry(
            Entry entry, CreateRequest request, Activity activity) {
        // Visibility and lifecycle callbacks may reenter host lifecycle methods.
        // Retry against the newest generation, but fail closed if a hostile
        // callback keeps changing state instead of blocking the UI indefinitely.
        for (int attempts = 0; attempts < 8; attempts++) {
            if (!requestIsCurrent(request, activity)) return false;
            if (entry.lifecyclePaused != paused) {
                long generation = lifecycleGeneration;
                transitionLifecycle(entry, paused, generation);
                if (!requestIsCurrent(request, activity)) return false;
                if (generation != lifecycleGeneration) continue;
            }
            long generation = lifecycleGeneration;
            applyVisibility(entry);
            if (!requestIsCurrent(request, activity)) return false;
            if (generation == lifecycleGeneration && entry.lifecyclePaused == paused) return true;
        }
        Log.e(TAG, "platform view lifecycle kept changing during create id=" + request.id);
        return false;
    }

    private static void transitionLifecycle(Entry entry, boolean shouldPause, long generation) {
        if (generation != lifecycleGeneration || entry.disposed.get()
                || entry.lifecyclePaused == shouldPause) return;
        entry.lifecyclePaused = shouldPause;
        try {
            if (shouldPause) entry.factory.onPause(entry.child);
            else entry.factory.onResume(entry.child);
        } catch (Throwable error) {
            Log.e(TAG, "custom platform view lifecycle callback failed", error);
        }
    }

    private static boolean requestIsCurrent(CreateRequest request, Activity activity) {
        return request.status.get() == REQUEST_PENDING
                && isCurrentHost(activity, request.generation);
    }

    private static boolean removeEntryIfSame(long id, Entry expected) {
        if (expected == null) return false;
        boolean removed = false;
        synchronized (STATE_LOCK) {
            if (ENTRIES.get(id) == expected) {
                ENTRIES.remove(id);
                removed = true;
            }
        }
        if (removed) disposeEntry(expected);
        return removed;
    }

    private static void applyVisibility(Entry entry) {
        entry.container.setVisibility(entry.requestedVisible && !paused ? View.VISIBLE : View.GONE);
    }

    private static Entry entry(long id) {
        synchronized (STATE_LOCK) {
            return ENTRIES.get(id);
        }
    }

    private static Entry[] snapshotEntries() {
        synchronized (STATE_LOCK) {
            return ENTRIES.values().toArray(new Entry[0]);
        }
    }

    private static void invalidateCreates() {
        for (CreateRequest request : CREATES.values()) {
            request.status.compareAndSet(REQUEST_PENDING, REQUEST_CANCELLED);
        }
        CREATES.clear();
    }

    private static void runOnMain(Runnable action) {
        if (Looper.myLooper() == Looper.getMainLooper()) action.run();
        else if (!MAIN.post(action)) Log.e(TAG, "main looper rejected platform view operation");
    }

    private static void finishRequest(CreateRequest request, boolean success) {
        request.status.compareAndSet(REQUEST_PENDING,
                success ? REQUEST_SUCCEEDED : REQUEST_FAILED);
        request.done.countDown();
        CREATES.remove(request.id, request);
    }

    private static final class CreateRequest {
        final long id;
        final WeakReference<Activity> activity;
        final long generation;
        final CountDownLatch done = new CountDownLatch(1);
        final java.util.concurrent.atomic.AtomicInteger status =
                new java.util.concurrent.atomic.AtomicInteger(REQUEST_PENDING);

        CreateRequest(long id, Activity activity, long generation) {
            this.id = id;
            this.activity = new WeakReference<>(activity);
            this.generation = generation;
        }
    }

    private static final class Entry {
        final long id;
        final FrameLayout container;
        final View child;
        final ViewFactory factory;
        final AtomicBoolean disposed = new AtomicBoolean();
        volatile boolean requestedVisible = true;
        volatile boolean lifecyclePaused;

        Entry(long id, FrameLayout container, View child, ViewFactory factory) {
            this.id = id;
            this.container = container;
            this.child = child;
            this.factory = factory;
        }
    }
}
