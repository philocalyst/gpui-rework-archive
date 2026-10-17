package dev.gpui.acceptanceime;

import android.inputmethodservice.InputMethodService;
import android.content.res.Configuration;
import android.os.Build;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.SurroundingText;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.TextView;
import java.nio.charset.StandardCharsets;

public final class AcceptanceImeService extends InputMethodService {
    static final String TAG = "GpuiAcceptanceIme";
    private static volatile AcceptanceImeService active;

    @Override
    public void onCreate() {
        super.onCreate();
        active = this;
    }

    @Override
    public void onDestroy() {
        if (active == this) active = null;
        super.onDestroy();
    }

    private String keyboardConfiguration() {
        Configuration configuration = getResources().getConfiguration();
        return "keyboard=" + configuration.keyboard
                + " hardKeyboardHidden=" + configuration.hardKeyboardHidden
                + " orientation=" + configuration.orientation
                + " widthDp=" + configuration.screenWidthDp
                + " heightDp=" + configuration.screenHeightDp;
    }

    @Override
    public boolean onEvaluateInputViewShown() {
        boolean result = super.onEvaluateInputViewShown();
        Log.i(TAG, "onEvaluateInputViewShown super=" + result + " " + keyboardConfiguration());
        return result;
    }

    @Override
    public boolean onShowInputRequested(int flags, boolean configChange) {
        boolean result = super.onShowInputRequested(flags, configChange);
        Log.i(TAG, "onShowInputRequested super=" + result + " flags=" + flags
                + " configChange=" + configChange + " " + keyboardConfiguration());
        return result;
    }

    @Override
    public View onCreateInputView() {
        Log.i(TAG, "onCreateInputView " + keyboardConfiguration());
        TextView view = new TextView(this);
        view.setText("GPUI acceptance IME");
        view.setContentDescription("GPUI acceptance IME");
        view.setPadding(24, 24, 24, 24);
        return view;
    }

    @Override
    public void onStartInputView(EditorInfo info, boolean restarting) {
        super.onStartInputView(info, restarting);
        Log.i(TAG, "onStartInputView restarting=" + restarting
                + " inputType=" + (info == null ? -1 : info.inputType)
                + " imeOptions=" + (info == null ? -1 : info.imeOptions)
                + " " + keyboardConfiguration());
    }

    private static String encode(CharSequence text) {
        if (text == null) return "~";
        return Base64.encodeToString(text.toString().getBytes(StandardCharsets.UTF_8), Base64.NO_WRAP);
    }

    static String execute(String operation, String text, int first, int second) {
        AcceptanceImeService service = active;
        if (service == null) return "no-active-ime-service";
        if ("hide".equals(operation)) {
            service.requestHideSelf(0);
            return "ok";
        }
        if ("show".equals(operation)) {
            service.requestShowSelf(0);
            return "ok";
        }
        InputConnection connection = service.getCurrentInputConnection();
        if (connection == null) return "no-active-input-connection";
        if ("query".equals(operation)) {
            CharSequence before = connection.getTextBeforeCursor(32, 0);
            CharSequence after = connection.getTextAfterCursor(32, 0);
            CharSequence selected = connection.getSelectedText(0);
            ExtractedText extracted = connection.getExtractedText(new ExtractedTextRequest(), 0);
            CharSequence fullText = extracted == null ? null : extracted.text;
            int selectionStart = extracted == null ? -1 : extracted.selectionStart;
            int selectionEnd = extracted == null ? -1 : extracted.selectionEnd;
            SurroundingText surrounding = Build.VERSION.SDK_INT >= 31
                    ? connection.getSurroundingText(32, 32, 0) : null;
            CharSequence surroundingText = surrounding == null ? null : surrounding.getText();
            int surroundingStart = surrounding == null ? -1 : surrounding.getSelectionStart();
            int surroundingEnd = surrounding == null ? -1 : surrounding.getSelectionEnd();
            int surroundingOffset = surrounding == null ? -1 : surrounding.getOffset();
            return "q2|" + encode(before) + "|" + encode(after) + "|" + encode(selected)
                    + "|" + encode(fullText) + "|" + selectionStart + "|" + selectionEnd
                    + "|" + encode(surroundingText) + "|" + surroundingStart + "|"
                    + surroundingEnd + "|" + surroundingOffset;
        }
        boolean accepted;
        switch (operation) {
            case "compose":
                accepted = connection.setComposingText(text, 1);
                break;
            case "commit":
                accepted = connection.commitText(text, 1);
                break;
            case "select":
                accepted = connection.setSelection(first, second);
                break;
            case "delete":
                accepted = connection.deleteSurroundingText(first, second);
                break;
            default:
                return "unknown-operation:" + operation;
        }
        String result = accepted ? "ok" : "input-connection-rejected";
        Log.i(TAG, operation + "=" + result + " selection=" + first + "," + second);
        return result;
    }
}
