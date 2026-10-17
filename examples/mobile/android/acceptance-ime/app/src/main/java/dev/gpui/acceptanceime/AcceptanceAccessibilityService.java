package dev.gpui.acceptanceime;

import android.accessibilityservice.AccessibilityService;
import android.os.Bundle;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

public final class AcceptanceAccessibilityService extends AccessibilityService {
    private static volatile AcceptanceAccessibilityService active;

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        active = this;
    }

    @Override
    public void onDestroy() {
        if (active == this) active = null;
        super.onDestroy();
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) { }

    @Override
    public void onInterrupt() { }

    static String selectEditor(int start, int end) {
        AcceptanceAccessibilityService service = active;
        if (service == null) return "no-active-accessibility-service";
        AccessibilityNodeInfo root = service.getRootInActiveWindow();
        if (root == null) return "no-active-window";
        try {
            AccessibilityNodeInfo editor = findEditor(root);
            if (editor == null) return "editor-not-found";
            Bundle args = new Bundle();
            args.putInt(AccessibilityNodeInfo.ACTION_ARGUMENT_SELECTION_START_INT, start);
            args.putInt(AccessibilityNodeInfo.ACTION_ARGUMENT_SELECTION_END_INT, end);
            try {
                boolean accepted = editor.performAction(AccessibilityNodeInfo.ACTION_SET_SELECTION, args);
                String result = accepted ? "ok" : "action-rejected";
                Log.i(AcceptanceImeService.TAG, "a11y-select=" + result + " range=" + start + "," + end);
                return result;
            } finally {
                editor.recycle();
            }
        } finally {
            root.recycle();
        }
    }

    static String setEditorText(String text) {
        AcceptanceAccessibilityService service = active;
        if (service == null) return "no-active-accessibility-service";
        AccessibilityNodeInfo root = service.getRootInActiveWindow();
        if (root == null) return "no-active-window";
        try {
            AccessibilityNodeInfo editor = findEditor(root);
            if (editor == null) return "editor-not-found";
            Bundle args = new Bundle();
            args.putCharSequence(AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE, text);
            try {
                boolean accepted = editor.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args);
                String result = accepted ? "ok" : "action-rejected";
                Log.i(AcceptanceImeService.TAG, "a11y-set-text=" + result);
                return result;
            } finally {
                editor.recycle();
            }
        } finally {
            root.recycle();
        }
    }

    private static AccessibilityNodeInfo findEditor(AccessibilityNodeInfo node) {
        CharSequence description = node.getContentDescription();
        String viewId = node.getViewIdResourceName();
        if ((description != null && "Editor".contentEquals(description))
                || (viewId != null && viewId.endsWith("acceptance.editor"))) {
            return AccessibilityNodeInfo.obtain(node);
        }
        for (int i = 0; i < node.getChildCount(); i++) {
            AccessibilityNodeInfo child = node.getChild(i);
            if (child == null) continue;
            AccessibilityNodeInfo found = findEditor(child);
            child.recycle();
            if (found != null) return found;
        }
        return null;
    }
}
