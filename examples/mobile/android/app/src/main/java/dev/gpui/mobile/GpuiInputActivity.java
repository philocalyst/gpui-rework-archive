package dev.gpui.mobile;

import android.app.NativeActivity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Build;
import android.graphics.Rect;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.graphics.Color;
import android.view.ViewGroup;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputConnectionWrapper;
import android.view.inputmethod.InputMethodManager;
import android.view.inputmethod.SurroundingText;
import android.widget.EditText;

/** NativeActivity with a UI-thread InputConnection for multistage IMEs. */
public class GpuiInputActivity extends NativeActivity {
    private InputProxy input;
    private volatile InputSnapshot inputSnapshot = new InputSnapshot(0, "", 0, 0, -1, -1, 0);

    private static final class InputSnapshot {
        final long session, generation;
        final String text;
        final int selectionStart, selectionEnd, markedStart, markedEnd;
        InputSnapshot(long session, String text, int selectionStart, int selectionEnd,
                      int markedStart, int markedEnd, long generation) {
            this.session = session;
            this.text = text;
            this.selectionStart = selectionStart;
            this.selectionEnd = selectionEnd;
            this.markedStart = markedStart;
            this.markedEnd = markedEnd;
            this.generation = generation;
        }
    }

    // Called from the GPUI thread. Publishing immutable volatile state avoids
    // synchronous UI-thread queries into GPUI while the IME holds framework locks.
    public synchronized void gpuiUpdateInputSnapshot(long session, String text, int selectionStart,
                                                     int selectionEnd, int markedStart, int markedEnd,
                                                     long generation) {
        InputSnapshot old = inputSnapshot;
        if (session == old.session && generation >= old.generation) {
            inputSnapshot = new InputSnapshot(session, text, selectionStart, selectionEnd,
                    markedStart, markedEnd, generation);
        }
    }

    @Override protected void onCreate(Bundle state) {
        // NativeActivity's dlopen alone does not register JNI native methods.
        try {
            String library = getPackageManager().getActivityInfo(getComponentName(),
                    PackageManager.GET_META_DATA).metaData.getString("android.app.lib_name");
            if (library != null) System.loadLibrary(library);
        } catch (PackageManager.NameNotFoundException error) {
            throw new IllegalStateException(error);
        }
        super.onCreate(state);
        GpuiPlatformView.bindActivity(this);
        installWindowInsets();
        if (Build.VERSION.SDK_INT >= 33) Api33Back.register(this);
    }

    private final int[] lastSafeInsets = new int[4];

    private void installWindowInsets() {
        Window window = getWindow();
        window.setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);
        View decor = window.getDecorView();
        if (Build.VERSION.SDK_INT >= 30) {
            Api30Insets.configure(window);
            Api30Insets.installAnimation(decor, this);
        } else {
            // API 26-29 lacks typed IME insets. Keep a stable edge-to-edge
            // surface and estimate the keyboard from the visible display frame.
            decor.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
        }
        decor.setOnApplyWindowInsetsListener((view, insets) -> {
            publishInsets(insets);
            return insets;
        });
        decor.requestApplyInsets();
    }

    private void publishInsets(android.view.WindowInsets insets) {
        if (Build.VERSION.SDK_INT >= 30) {
            Api30Insets.publish(this, insets);
            return;
        }

        int top = Math.max(0, insets.getSystemWindowInsetTop());
        int right = Math.max(0, insets.getSystemWindowInsetRight());
        int bottom = Math.max(0, insets.getSystemWindowInsetBottom());
        int left = Math.max(0, insets.getSystemWindowInsetLeft());
        lastSafeInsets[0] = top;
        lastSafeInsets[1] = right;
        lastSafeInsets[2] = bottom;
        lastSafeInsets[3] = left;

        View decor = getWindow().getDecorView();
        View root = decor.getRootView();
        Rect visible = new Rect();
        decor.getWindowVisibleDisplayFrame(visible);
        int[] rootLocation = new int[2];
        root.getLocationOnScreen(rootLocation);
        int rootBottom = rootLocation[1] + root.getHeight();
        // Use the obscured bottom edge, not rootHeight-visible.height():
        // that height difference also includes the status-bar top inset.
        int obscuredBottom = Math.max(0, rootBottom - visible.bottom);
        int imeBottom = Math.max(0, obscuredBottom - bottom);
        nativeInsets(top, right, bottom, left, 0, 0, imeBottom, 0);
    }

    @Override protected void onStart() {
        super.onStart();
        getWindow().getDecorView().requestApplyInsets();
    }

    @Override protected void onDestroy() {
        // Release static overlay Views even when native initialization failed.
        GpuiPlatformView.unbindActivity(this);
        super.onDestroy();
    }

    @Override protected void onStop() {
        nativeInsets(lastSafeInsets[0], lastSafeInsets[1], lastSafeInsets[2],
                lastSafeInsets[3], 0, 0, 0, 0);
        super.onStop();
    }

    private boolean backStartedWithIme;
    // Android can hide the IME before dispatching Back to the Activity. Keep
    // one pending input-session dismissal so that Back cannot also finish the
    // NativeActivity in the same gesture.
    private boolean keyboardSessionActive;

    private boolean isImeVisible() {
        if (Build.VERSION.SDK_INT >= 30) return Api30Insets.isVisible(this);
        ViewGroup decor = (ViewGroup) getWindow().getDecorView();
        Rect visible = new Rect();
        decor.getWindowVisibleDisplayFrame(visible);
        int obscured = decor.getRootView().getHeight() - visible.height();
        return obscured > (int) (160 * getResources().getDisplayMetrics().density);
    }

    private void handleSystemBack() {
        boolean imeWasVisible = backStartedWithIme || isImeVisible();
        boolean dismissInputSession = keyboardSessionActive;
        backStartedWithIme = false;
        if (input != null && input.hasFocus() && (imeWasVisible || dismissInputSession)) {
            keyboardSessionActive = false;
            android.util.Log.i("gpui-android", "Back dismissed visible IME; keeping Activity alive");
            input.keyboardHiddenByBack();
            InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(input.getWindowToken(), 0);
            return;
        }
        android.util.Log.i("gpui-android", "Back with hidden IME; finishing Activity");
        finish();
    }

    @Override public void onBackPressed() {
        // NativeActivity's legacy path can receive KEYCODE_BACK even when the
        // platform dispatcher callback is bypassed by a device IME.
        handleSystemBack();
    }

    // Keep API 33 types in a nested class so API 26-32 don't resolve them.
    private static final class Api33Back implements android.window.OnBackInvokedCallback {
        private final GpuiInputActivity activity;
        private Api33Back(GpuiInputActivity activity) { this.activity = activity; }
        static void register(GpuiInputActivity activity) {
            activity.getOnBackInvokedDispatcher().registerOnBackInvokedCallback(
                    android.window.OnBackInvokedDispatcher.PRIORITY_OVERLAY, new Api33Back(activity));
        }
        @Override public void onBackInvoked() { activity.handleSystemBack(); }
    }

    private static final class Api30Insets {
        static void configure(Window window) {
            window.setDecorFitsSystemWindows(false);
            window.setStatusBarColor(Color.TRANSPARENT);
            window.setNavigationBarColor(Color.TRANSPARENT);
        }

        static void installAnimation(View decor, GpuiInputActivity activity) {
            decor.setWindowInsetsAnimationCallback(new android.view.WindowInsetsAnimation.Callback(
                    android.view.WindowInsetsAnimation.Callback.DISPATCH_MODE_CONTINUE_ON_SUBTREE) {
                @Override public android.view.WindowInsets onProgress(android.view.WindowInsets insets,
                        java.util.List<android.view.WindowInsetsAnimation> runningAnimations) {
                    publish(activity, insets);
                    return insets;
                }
            });
        }

        static void publish(GpuiInputActivity activity, android.view.WindowInsets insets) {
            android.graphics.Insets safe = insets.getInsets(
                    android.view.WindowInsets.Type.systemBars()
                            | android.view.WindowInsets.Type.displayCutout());
            android.graphics.Insets ime = insets.getInsets(android.view.WindowInsets.Type.ime());
            activity.lastSafeInsets[0] = safe.top;
            activity.lastSafeInsets[1] = safe.right;
            activity.lastSafeInsets[2] = safe.bottom;
            activity.lastSafeInsets[3] = safe.left;
            nativeInsets(safe.top, safe.right, safe.bottom, safe.left,
                    ime.top, ime.right, ime.bottom, ime.left);
        }

        static boolean isVisible(GpuiInputActivity activity) {
            android.view.WindowInsets insets = activity.getWindow().getDecorView().getRootWindowInsets();
            return insets != null && insets.isVisible(android.view.WindowInsets.Type.ime());
        }
    }

    public void gpuiShowKeyboard(int keyboardType, long session) {
        runOnUiThread(() -> {
            keyboardSessionActive = true;
            if (input == null) {
                input = new InputProxy();
                input.setAlpha(0f);
                input.setPadding(0, 0, 0, 0);
                addContentView(input, new ViewGroup.LayoutParams(1, 1));
            }
            input.reset(session, false);
            int type = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE;
            switch (keyboardType) {
                case 1: type = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS; break;
                case 2: type = InputType.TYPE_CLASS_PHONE; break;
                case 3: type = InputType.TYPE_CLASS_NUMBER; break;
                case 4: type = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI; break;
                case 5: type = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL; break;
            }
            input.setInputType(type);
            input.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI);
            input.requestFocus();
            InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
            imm.restartInput(input);
            imm.showSoftInput(input, InputMethodManager.SHOW_IMPLICIT);
        });
    }

    public void gpuiHideKeyboard(long session) {
        runOnUiThread(() -> {
            keyboardSessionActive = false;
            if (input == null) return;
            input.reset(session, false);
            InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(input.getWindowToken(), 0);
            input.clearFocus();
        });
    }

    public void gpuiResetComposition(long session) {
        runOnUiThread(() -> {
            if (input == null) return;
            input.reset(session, true);
            ((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE)).restartInput(input);
        });
    }

    private final class InputProxy extends EditText {
        private long session;
        private int depth;
        private boolean marked;
        // An empty commit is meaningful: it replaces the GPUI selection with nothing.
        private boolean forceEmptyCommit;
        private long generation;

        private void sendIme(int kind, String text, int start, int end) {
            nativeIme(session, kind, text, start, end, ++generation);
        }

        private InputSnapshot currentSnapshot() {
            InputSnapshot current = inputSnapshot;
            return current.session == session
                    ? current : new InputSnapshot(session, "", 0, 0, -1, -1, generation);
        }

        private InputSnapshot currentSnapshot(long requestedSession) {
            InputSnapshot current = inputSnapshot;
            return current.session == requestedSession
                    ? current : new InputSnapshot(requestedSession, "", 0, 0, -1, -1, 0);
        }

        private void updateSnapshot(String text, int selectionStart, int selectionEnd,
                                    int markedStart, int markedEnd) {
            synchronized (GpuiInputActivity.this) {
                InputSnapshot old = inputSnapshot;
                if (old.session != session || generation < old.generation) return;
                int length = text.length();
                int[] selection = clampSelection(text, selectionStart, selectionEnd);
                selectionStart = selection[0];
                selectionEnd = selection[1];
                inputSnapshot = new InputSnapshot(session, text, selectionStart, selectionEnd,
                        markedStart, markedEnd, generation);
            }
        }

        private int clampBoundary(String text, int offset) {
            int clamped = Math.max(0, Math.min(offset, text.length()));
            if (clamped > 0 && clamped < text.length()
                    && Character.isLowSurrogate(text.charAt(clamped))
                    && Character.isHighSurrogate(text.charAt(clamped - 1))) {
                return clamped - 1;
            }
            return clamped;
        }

        private int clampBoundaryUp(String text, int offset) {
            int clamped = Math.max(0, Math.min(offset, text.length()));
            if (clamped > 0 && clamped < text.length()
                    && Character.isLowSurrogate(text.charAt(clamped))
                    && Character.isHighSurrogate(text.charAt(clamped - 1))) {
                return clamped + 1;
            }
            return clamped;
        }

        // Match GPUI's UTF-16-to-UTF-8 mapping: normalize each endpoint forward
        // independently, preserving anchor/focus order and avoiding split scalars.
        private int[] clampSelection(String text, int start, int end) {
            return new int[] { clampBoundaryUp(text, start), clampBoundaryUp(text, end) };
        }

        private void deleteSnapshot(int before, int after, boolean codePoints) {
            InputSnapshot current = currentSnapshot();
            int protectedStart = Math.min(current.selectionStart, current.selectionEnd);
            int protectedEnd = Math.max(current.selectionStart, current.selectionEnd);
            if (current.markedStart >= 0 && current.markedEnd >= 0) {
                protectedStart = Math.min(protectedStart, current.markedStart);
                protectedEnd = Math.max(protectedEnd, current.markedEnd);
            }

            int start;
            int end;
            if (codePoints) {
                int[] boundaries = new int[current.text.codePointCount(0, current.text.length()) + 1];
                int offset = 0;
                for (int i = 0; i < boundaries.length; i++) {
                    boundaries[i] = offset;
                    if (offset < current.text.length()) {
                        offset += Character.charCount(current.text.codePointAt(offset));
                    }
                }
                int protectedStartIndex = 0;
                while (protectedStartIndex < boundaries.length
                        && boundaries[protectedStartIndex] < protectedStart) protectedStartIndex++;
                int protectedEndIndex = 0;
                while (protectedEndIndex < boundaries.length
                        && boundaries[protectedEndIndex] < protectedEnd) protectedEndIndex++;
                protectedStart = boundaries[Math.min(protectedStartIndex, boundaries.length - 1)];
                protectedEnd = boundaries[Math.min(protectedEndIndex, boundaries.length - 1)];
                start = boundaries[Math.max(0, protectedStartIndex - Math.max(0, before))];
                end = boundaries[Math.min(boundaries.length - 1,
                        protectedEndIndex + Math.max(0, after))];
            } else {
                int requestedStart = Math.max(0, protectedStart - Math.max(0, before));
                int requestedEnd = Math.min(current.text.length(), protectedEnd + Math.max(0, after));
                start = clampBoundary(current.text, requestedStart);
                end = clampBoundaryUp(current.text, requestedEnd);
            }

            // Mirrors AOSP BaseInputConnection.deleteSurroundingText:
            // https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/BaseInputConnection.java
            // It protects selection/composition and deletes the two surrounding ranges.
            String next = current.text.substring(0, start)
                    + current.text.substring(protectedStart, protectedEnd)
                    + current.text.substring(end);
            int removedBefore = protectedStart - start;
            int selectionStart = Math.max(0, current.selectionStart - removedBefore);
            int selectionEnd = Math.max(0, current.selectionEnd - removedBefore);
            int markedStart = current.markedStart >= 0
                    ? Math.max(0, current.markedStart - removedBefore) : -1;
            int markedEnd = current.markedEnd >= 0
                    ? Math.max(0, current.markedEnd - removedBefore) : -1;
            long nextGeneration = ++generation;
            updateSnapshot(next, selectionStart, selectionEnd, markedStart, markedEnd);
            nativeIme(session, codePoints ? 3 : 2, "", before, after, nextGeneration);
        }

        private void replaceSnapshot(int start, int end, String insertion, boolean composing,
                                     int composingSelectionStart, int composingSelectionEnd) {
            InputSnapshot old = currentSnapshot();
            int lo = Math.max(0, Math.min(start, old.text.length()));
            int hi = Math.max(lo, Math.min(end, old.text.length()));
            String next = old.text.substring(0, lo) + insertion + old.text.substring(hi);
            if (composing) {
                updateSnapshot(next, lo + composingSelectionStart, lo + composingSelectionEnd,
                        lo, lo + insertion.length());
            } else {
                int caret = lo + insertion.length();
                updateSnapshot(next, caret, caret, -1, -1);
            }
        }

        InputProxy() {
            super(GpuiInputActivity.this);
            addTextChangedListener(new TextWatcher() {
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
                public void onTextChanged(CharSequence s, int start, int before, int count) {}
                public void afterTextChanged(Editable text) {
                    // Hardware keyboards edit the widget directly, outside its
                    // InputConnection. IME mutations are batched by depth below.
                    if (depth == 0) { depth++; endEdit(); }
                }
            });
        }

        @Override public boolean onKeyDown(int code, KeyEvent event) {
            if (code == KeyEvent.KEYCODE_DEL && getText().length() == 0 && !marked) {
                sendIme(3, "", 1, 0);
                return true;
            }
            return super.onKeyDown(code, event);
        }

        void reset(long nextSession, boolean preserveDocument) {
            synchronized (GpuiInputActivity.this) {
                InputSnapshot previous = inputSnapshot;
                depth++;
                getText().clear();
                marked = false;
                forceEmptyCommit = false;
                session = nextSession;
                generation = 0;
                String text = preserveDocument ? previous.text : "";
                int start = preserveDocument ? previous.selectionStart : 0;
                int end = preserveDocument ? previous.selectionEnd : 0;
                inputSnapshot = new InputSnapshot(nextSession, text, start, end, -1, -1, 0);
                depth = 0;
            }
        }

        private void endEdit() {
            if (--depth != 0) return;
            Editable text = getText();
            boolean composing = BaseInputConnection.getComposingSpanStart(text) >= 0;
            if (composing || marked || text.length() > 0 || forceEmptyCommit) {
                String inserted = text.toString();
                InputSnapshot current = currentSnapshot();
                int replaceStart = current.markedStart >= 0
                        ? current.markedStart : Math.min(current.selectionStart, current.selectionEnd);
                int replaceEnd = current.markedStart >= 0
                        ? current.markedEnd : Math.max(current.selectionStart, current.selectionEnd);
                int selectedStart = Math.max(0, Selection.getSelectionStart(text));
                int selectedEnd = Math.max(0, Selection.getSelectionEnd(text));
                long nextGeneration = ++generation;
                replaceSnapshot(replaceStart, replaceEnd, inserted, composing,
                        selectedStart, selectedEnd);
                nativeIme(session, composing ? 0 : 1, inserted, selectedStart, selectedEnd,
                        nextGeneration);
                marked = composing;
                forceEmptyCommit = false;
                if (!composing) {
                    depth++;
                    text.clear();
                    depth--;
                }
            }
        }

        private void keyboardHiddenByBack() { sendIme(5, "", 0, 0); }

        @Override public boolean onKeyPreIme(int code, KeyEvent event) {
            if (code == KeyEvent.KEYCODE_BACK) {
                if (event.getAction() == KeyEvent.ACTION_DOWN) backStartedWithIme = isImeVisible();
                else if (event.getAction() == KeyEvent.ACTION_UP && (backStartedWithIme || isImeVisible())) {
                    keyboardHiddenByBack();
                    InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(getWindowToken(), 0);
                    // Consume this Back so NativeActivity cannot finish after
                    // the IME has already hidden and visibility reports false.
                    return true;
                }
            }
            return super.onKeyPreIme(code, event);
        }

        @Override public InputConnection onCreateInputConnection(EditorInfo info) {
            InputConnection connection = super.onCreateInputConnection(info);
            if (connection == null) return null;
            final long connectionSession = session;
            InputConnection wrapped = new InputConnectionWrapper(connection, false) {
                @Override public boolean beginBatchEdit() {
                    if (connectionSession != session) return false;
                    depth++;
                    return super.beginBatchEdit();
                }
                @Override public boolean endBatchEdit() {
                    if (connectionSession != session) return false;
                    boolean result = super.endBatchEdit();
                    if (depth > 0) endEdit();
                    return result;
                }
                @Override public boolean setComposingText(CharSequence text, int cursor) {
                    if (connectionSession != session) return false;
                    depth++;
                    try { return super.setComposingText(text, cursor); }
                    finally { endEdit(); }
                }
                @Override public boolean setComposingRegion(int start, int end) {
                    if (connectionSession != session) return false;
                    depth++;
                    try { return super.setComposingRegion(start, end); }
                    finally { endEdit(); }
                }
                @Override public boolean finishComposingText() {
                    if (connectionSession != session) return false;
                    depth++;
                    try { return super.finishComposingText(); }
                    finally { endEdit(); }
                }
                @Override public boolean commitText(CharSequence text, int cursor) {
                    if (connectionSession != session) return false;
                    depth++;
                    try {
                        boolean result = super.commitText(text, cursor);
                        if (result && text != null && text.length() == 0) forceEmptyCommit = true;
                        return result;
                    } finally { endEdit(); }
                }
                @Override public boolean setSelection(int start, int end) {
                    if (connectionSession != session) return false;
                    depth++;
                    try {
                        boolean result = super.setSelection(start, end);
                        if (result) {
                            InputSnapshot current = currentSnapshot();
                            int[] selection = clampSelection(current.text, start, end);
                            int lo = selection[0];
                            int hi = selection[1];
                            long nextGeneration = ++generation;
                            updateSnapshot(current.text, lo, hi, current.markedStart, current.markedEnd);
                            nativeIme(session, 6, "", lo, hi, nextGeneration);
                        }
                        return result;
                    } finally { endEdit(); }
                }
                @Override public CharSequence getTextBeforeCursor(int length, int flags) {
                    InputSnapshot current = currentSnapshot();
                    // Match BaseInputConnection: before-cursor text ends at the
                    // lower selection edge, even for a non-collapsed selection.
                    int cursor = Math.min(current.selectionStart, current.selectionEnd);
                    int start = Math.max(0, cursor - Math.max(0, length));
                    if (start > 0 && start < current.text.length()
                            && Character.isLowSurrogate(current.text.charAt(start))) start--;
                    return current.text.substring(start, cursor);
                }

                @Override public CharSequence getTextAfterCursor(int length, int flags) {
                    InputSnapshot current = currentSnapshot();
                    // Match BaseInputConnection: after-cursor text starts at the
                    // upper selection edge, even for a non-collapsed selection.
                    int cursor = Math.max(current.selectionStart, current.selectionEnd);
                    int end = Math.min(current.text.length(), cursor + Math.max(0, length));
                    if (end > 0 && end < current.text.length()
                            && Character.isHighSurrogate(current.text.charAt(end - 1))) end++;
                    return current.text.substring(cursor, end);
                }

                @Override public CharSequence getSelectedText(int flags) {
                    InputSnapshot current = currentSnapshot();
                    int start = Math.min(current.selectionStart, current.selectionEnd);
                    int end = Math.max(current.selectionStart, current.selectionEnd);
                    return start == end ? null : current.text.substring(start, end);
                }

                @Override public ExtractedText getExtractedText(ExtractedTextRequest request, int flags) {
                    InputSnapshot current = currentSnapshot();
                    ExtractedText extracted = new ExtractedText();
                    extracted.text = current.text;
                    extracted.startOffset = 0;
                    extracted.partialStartOffset = -1;
                    extracted.partialEndOffset = -1;
                    extracted.selectionStart = current.selectionStart;
                    extracted.selectionEnd = current.selectionEnd;
                    extracted.flags = current.selectionStart != current.selectionEnd
                            ? ExtractedText.FLAG_SELECTING : 0;
                    return extracted;
                }

                @Override public boolean deleteSurroundingText(int before, int after) {
                    if (connectionSession != session) return false;
                    deleteSnapshot(before, after, false);
                    return true;
                }
                @Override public boolean deleteSurroundingTextInCodePoints(int before, int after) {
                    if (connectionSession != session) return false;
                    deleteSnapshot(before, after, true);
                    return true;
                }
                @Override public boolean sendKeyEvent(KeyEvent event) {
                    if (connectionSession != session) return false;
                    if (event.getKeyCode() == KeyEvent.KEYCODE_DEL) {
                        if (event.getAction() == KeyEvent.ACTION_DOWN) deleteSurroundingText(1, 0);
                        return true;
                    }
                    if (event.getKeyCode() == KeyEvent.KEYCODE_ENTER) {
                        if (event.getAction() == KeyEvent.ACTION_DOWN) commitText("\n", 1);
                        return true;
                    }
                    return super.sendKeyEvent(event);
                }
                @Override public boolean performEditorAction(int action) {
                    if (connectionSession != session) return false;
                    if (action == EditorInfo.IME_ACTION_DONE) {
                        finishComposingText();
                        sendIme(4, "", 0, 0);
                        return true;
                    }
                    return commitText("\n", 1);
                }
            };
            if (Build.VERSION.SDK_INT >= 31) {
                return new Api31InputConnection(wrapped, this, connectionSession);
            }
            return wrapped;
        }
    }

    @android.annotation.TargetApi(31)
    private final class Api31InputConnection extends InputConnectionWrapper {
        private final InputProxy proxy;
        private final long connectionSession;

        Api31InputConnection(InputConnection target, InputProxy proxy, long session) {
            super(target, false);
            this.proxy = proxy;
            this.connectionSession = session;
        }

        @Override public SurroundingText getSurroundingText(
                int beforeLength, int afterLength, int flags) {
            InputSnapshot current = proxy.currentSnapshot(connectionSession);
            int selectedStart = Math.min(current.selectionStart, current.selectionEnd);
            int selectedEnd = Math.max(current.selectionStart, current.selectionEnd);
            int start = Math.max(0, selectedStart - Math.max(0, beforeLength));
            int end = Math.min(current.text.length(), selectedEnd + Math.max(0, afterLength));
            start = proxy.clampBoundary(current.text, start);
            end = proxy.clampBoundaryUp(current.text, end);
            return new SurroundingText(current.text.substring(start, end),
                    current.selectionStart - start, current.selectionEnd - start, start);
        }
    }

    private static native void nativeIme(long session, int kind, String text, int start, int end, long generation);
    private static native void nativeInsets(int safeTop, int safeRight, int safeBottom, int safeLeft,
                                            int imeTop, int imeRight, int imeBottom, int imeLeft);
}
