package dev.gpui.mobile;

import android.app.Activity;
import android.os.Bundle;
import android.widget.FrameLayout;

/** Debug-only host used by the Android instrumentation platform-view probe. */
public final class GpuiPlatformViewProbeActivity extends Activity {
    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        GpuiPlatformView.bindActivity(this);
        setContentView(new FrameLayout(this));
    }

    @Override protected void onDestroy() {
        GpuiPlatformView.unbindActivity(this);
        super.onDestroy();
    }
}
