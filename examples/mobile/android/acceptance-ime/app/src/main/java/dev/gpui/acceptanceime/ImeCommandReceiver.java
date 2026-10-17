package dev.gpui.acceptanceime;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public final class ImeCommandReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String operation = intent.getStringExtra("op");
        String text = intent.getStringExtra("text");
        int first = intent.getIntExtra("first", 0);
        int second = intent.getIntExtra("second", 0);
        String safeOperation = operation == null ? "" : operation;
        String safeText = text == null ? "" : text;
        long commandId = intent.getLongExtra("command_id", 0L);
        String result;
        if ("select_a11y".equals(safeOperation)) {
            result = AcceptanceAccessibilityService.selectEditor(first, second);
        } else if ("set_a11y".equals(safeOperation)) {
            result = AcceptanceAccessibilityService.setEditorText(safeText);
        } else {
            result = AcceptanceImeService.execute(safeOperation, safeText, first, second);
        }
        if ("query".equals(safeOperation) && result.startsWith("q2|")) {
            Log.i(AcceptanceImeService.TAG, "command-id=" + commandId
                    + " operation=query result=ok");
            Log.i(AcceptanceImeService.TAG, "query-id=" + commandId + " data=" + result);
            return;
        }
        Log.i(AcceptanceImeService.TAG, "command-id=" + commandId
                + " operation=" + safeOperation + " result=" + result);
    }
}
