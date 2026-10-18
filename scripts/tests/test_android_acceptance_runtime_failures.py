import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import android_acceptance


class RuntimeFailureClassificationTests(unittest.TestCase):
    def test_exact_api36_velvet_debug_optional_library_warning_is_ignored(self):
        line = (
            '10-18 10:20:42.719  5295  5383 D nativeloader: Load '
            'libgeller_jni_lib_split.so using class loader ns product-clns-10 '
            '(caller=/product/priv-app/Velvet/Velvet.apk!classes3.dex): '
            'dlopen failed: library "libgeller_jni_lib_split.so" not found'
        )
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [])

    def test_same_missing_library_from_gpui_remains_fatal(self):
        line = (
            '10-18 10:20:42.719  5295  5383 D nativeloader: Load '
            'libgeller_jni_lib_split.so (caller=/data/app/dev.gpui.mobile.example/lib/'
            'libgpui_mobile.so): dlopen failed: library '
            '"libgeller_jni_lib_split.so" not found'
        )
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])

    def test_other_velvet_library_remains_fatal(self):
        line = (
            '10-18 10:20:42.719  5295  5383 D nativeloader: Load libother.so '
            '(caller=/product/priv-app/Velvet/Velvet.apk!classes3.dex): '
            'dlopen failed: library "libother.so" not found'
        )
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])

    def test_velvet_caller_suffix_near_match_remains_fatal(self):
        line = (
            '10-18 10:20:42.719  5295  5383 D nativeloader: Load '
            'libgeller_jni_lib_split.so (caller=/product/priv-app/Velvet/'
            'Velvet.apk!classes3.dex.extra): dlopen failed: library '
            '"libgeller_jni_lib_split.so" not found'
        )
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])

    def test_exact_velvet_lookup_at_error_and_fatal_levels_remains_fatal(self):
        payload = (
            'Load libgeller_jni_lib_split.so using class loader ns product-clns-10 '
            '(caller=/product/priv-app/Velvet/Velvet.apk!classes3.dex): '
            'dlopen failed: library "libgeller_jni_lib_split.so" not found'
        )
        for priority in ("E", "F"):
            with self.subTest(priority=priority):
                line = f"10-18 10:20:42.719 5295 5383 {priority} nativeloader: {payload}"
                self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])

    def test_unsatisfied_link_error_remains_fatal(self):
        line = "java.lang.UnsatisfiedLinkError: missing libgeller_jni_lib_split.so"
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])

    def test_anr_remains_fatal(self):
        line = "10-18 10:20:42.719 5295 5383 E ActivityManager: ANR in dev.gpui.mobile.example"
        self.assertEqual(android_acceptance.runtime_failure_lines(line), [line])


class FontScaleRecreationTests(unittest.TestCase):
    def test_font_scale_uses_a_distinct_value_and_handles_missing_setting(self):
        self.assertEqual(android_acceptance.distinct_font_scale("null"), "1.10")
        self.assertEqual(android_acceptance.distinct_font_scale("1.0"), "1.10")
        self.assertEqual(android_acceptance.distinct_font_scale("1.10"), "1.15")
        self.assertEqual(android_acceptance.distinct_font_scale("1.15"), "1.10")

    def test_activity_recreation_requires_same_process_destroy_and_create(self):
        log = """10-18 10:38:48.683  545  567 I wm_relaunch_resume_activity: [0,68170572,10,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity,40000000]
10-18 10:38:49.193 3230 3230 I wm_on_destroy_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,5]
10-18 10:38:49.316 3230 3230 I wm_on_create_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performCreate,68]
10-18 10:38:49.500 9999 9999 I wm_on_create_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performCreate,68]
"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 3230)
        self.assertEqual(len(events["relaunch"]), 1)
        self.assertEqual(len(events["destroy"]), 1)
        self.assertEqual(len(events["create"]), 1)
        self.assertLess(log.index(events["destroy"][0]), log.index(events["create"][0]))
        android_acceptance.validate_activity_recreation_events(log, events)

    def test_activity_recreation_does_not_accept_destroy_without_recreated_activity(self):
        log = """10-18 10:38:49.193 3230 3230 I wm_on_destroy_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,5]
10-18 10:38:49.735 545 916 I wm_relaunch_resume_activity: [0,183945133,9,com.android.launcher/.Launcher,40000000]
"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 3230)
        self.assertEqual(events["relaunch"], [])
        self.assertEqual(len(events["destroy"]), 1)
        self.assertEqual(events["create"], [])
        with self.assertRaisesRegex(RuntimeError, "did not produce durable"):
            android_acceptance.validate_activity_recreation_events(log, events)

    def test_activity_recreation_rejects_unrelated_record_token(self):
        log = """10-18 10:38:48.683 545 567 I wm_relaunch_resume_activity: [0,68170572,10,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity,40000000]
10-18 10:38:49.193 3230 3230 I wm_on_destroy_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,5]
10-18 10:38:49.316 3230 3230 I wm_on_create_called: [99999999,dev.gpui.mobile.GpuiInputActivity,performCreate,68]
"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 3230)
        with self.assertRaisesRegex(RuntimeError, "different or missing"):
            android_acceptance.validate_activity_recreation_events(log, events)


    def test_font_scale_poll_waits_for_ordered_replacement_after_stale_create(self):
        old_create = (
            "10-18 10:39:11.710 3230 3230 I wm_on_create_called: "
            "[68170572,dev.gpui.mobile.GpuiInputActivity,performCreate,93]"
        )
        relaunch = (
            "10-18 10:39:22.881 545 567 I wm_relaunch_resume_activity: "
            "[0,68170572,45,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity,40000000]"
        )
        destroy = (
            "10-18 10:39:23.809 3230 3230 I wm_on_destroy_called: "
            "[68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,112]"
        )
        new_create = (
            "10-18 10:39:23.871 3230 3230 I wm_on_create_called: "
            "[68170572,dev.gpui.mobile.GpuiInputActivity,performCreate,29]"
        )
        snapshots = [
            "\n".join((old_create, relaunch, destroy)),
            "\n".join((old_create, relaunch, destroy, new_create)),
        ]
        snapshots_last = snapshots[-1]
        now = [0.0]

        def read_logs(_timeout):
            return snapshots.pop(0) if snapshots else snapshots_last

        def sleep(duration):
            now[0] += duration

        logs, events = android_acceptance.wait_for_activity_recreation_events(
            read_logs,
            "dev.gpui.mobile.example",
            "dev.gpui.mobile.GpuiInputActivity",
            3230,
            lambda _timeout: 3230,
            timeout_seconds=1.0,
            poll_interval_seconds=0.15,
            clock=lambda: now[0],
            sleep=sleep,
        )
        self.assertIn(new_create, logs)
        android_acceptance.validate_activity_recreation_events(logs, events)

    def test_font_scale_poll_times_out_when_only_pre_destroy_create_is_present(self):
        log = """10-18 10:39:11.710 3230 3230 I wm_on_create_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performCreate,93]
10-18 10:39:22.881 545 567 I wm_relaunch_resume_activity: [0,68170572,45,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity,40000000]
10-18 10:39:23.809 3230 3230 I wm_on_destroy_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,112]"""
        now = [0.0]

        with self.assertRaisesRegex(RuntimeError, "timed out waiting for ordered Activity recreation"):
            android_acceptance.wait_for_activity_recreation_events(
                lambda _timeout: log,
                "dev.gpui.mobile.example",
                "dev.gpui.mobile.GpuiInputActivity",
                3230,
                lambda _timeout: 3230,
                timeout_seconds=0.3,
                poll_interval_seconds=0.15,
                clock=lambda: now[0],
                sleep=lambda duration: now.__setitem__(0, now[0] + duration),
            )

    def test_font_scale_poll_rejects_wrong_activity_record_token_after_destroy(self):
        log = """10-18 10:39:22.881 545 567 I wm_relaunch_resume_activity: [0,68170572,45,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity,40000000]
10-18 10:39:23.809 3230 3230 I wm_on_destroy_called: [68170572,dev.gpui.mobile.GpuiInputActivity,performDestroy,112]
10-18 10:39:23.871 3230 3230 I wm_on_create_called: [99999999,dev.gpui.mobile.GpuiInputActivity,performCreate,29]"""
        with self.assertRaisesRegex(RuntimeError, "different or missing ActivityRecord tokens"):
            android_acceptance.wait_for_activity_recreation_events(
                lambda _timeout: log,
                "dev.gpui.mobile.example",
                "dev.gpui.mobile.GpuiInputActivity",
                3230,
                lambda _timeout: 3230,
                timeout_seconds=1.0,
                poll_interval_seconds=0.15,
                clock=lambda: 0.0,
                sleep=lambda _: None,
            )


if __name__ == "__main__":
    unittest.main()
