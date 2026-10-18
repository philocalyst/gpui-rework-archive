import sys
import unittest
from unittest.mock import patch
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
    def test_missing_font_scale_restoration_accepts_only_absent_effective_default(self):
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "null", "1.0", "1.0", "1.0", None, None))
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "null", "null", "1.0", "1.0", None, None))
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "1.0", "1.0", "1.0", "1.0", None, None))
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "null", "null", "1.0", "1.0", None, "1.0"))
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "1.0", "1.0", "1.0", "1.0", None, "1.0"))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "null", "1.0", "1.0", "1.1", None, None))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "null", "1.0", "1.0", "1.0", None, "2.0"))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "1.0", "1.0", "1.1", "1.0", None, None))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "null", "2.0", "1.0", "2.0", None, "2.0"))

    def test_explicit_font_scale_must_restore_raw_entry_and_effective_value(self):
        self.assertTrue(android_acceptance.font_scale_restore_matches(
            "1.15", "1.15", "1.15", "1.15", "1.15", "1.15"))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "1.15", "1.0", "1.15", "1.0", "1.15", "1.0"))
        self.assertFalse(android_acceptance.font_scale_restore_matches(
            "1.15", "1.15", "1.15", "1.10", "1.15", "1.15"))

    def test_effective_font_scale_requires_one_consistent_activity_configuration(self):
        dump = """ActivityRecord:
  CurrentConfiguration={1.0 310mcc260mnc [en_US] ldltr}
  mLastReportedConfiguration:
  CurrentConfiguration={1.0 310mcc260mnc [en_US] ldltr}"""
        self.assertEqual(android_acceptance.effective_font_scale(dump), "1.0")
        with self.assertRaisesRegex(RuntimeError, "inconsistent effective font scales"):
            android_acceptance.effective_font_scale(
                "CurrentConfiguration={1.0 a}\nCurrentConfiguration={1.1 b}")
        with self.assertRaisesRegex(RuntimeError, "did not expose"):
            android_acceptance.effective_font_scale("no configuration")

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


    def test_api29_am_callbacks_are_correlated_by_component_pid_and_order(self):
        log = """10-18 16:58:27.247 1966 1988 I am_relaunch_resume_activity: [0,218790825,9,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity]
10-18 16:58:27.309 6768 6768 I am_on_destroy_called: [0,dev.gpui.mobile.GpuiInputActivity,performDestroy]
10-18 16:58:27.356 6768 6768 I am_on_create_called: [0,dev.gpui.mobile.GpuiInputActivity,performCreate]"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 6768, api=29)
        android_acceptance.validate_activity_recreation_events(log, events, api=29)
        self.assertEqual(len(events["relaunch"]), 1)
        wrong_component = log.replace("GpuiInputActivity]", "GpuiInputActivitySuffix]")
        wrong_events = android_acceptance.activity_recreation_events(
            wrong_component, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 6768, api=29)
        with self.assertRaisesRegex(RuntimeError, "same Activity/PID"):
            android_acceptance.validate_activity_recreation_events(wrong_component, wrong_events, api=29)

    def test_api29_rejects_wrong_process_and_missing_relaunch(self):
        log = """10-18 16:58:27.247 1966 1988 I am_relaunch_resume_activity: [0,218790825,9,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity]
10-18 16:58:27.309 9999 9999 I am_on_destroy_called: [0,dev.gpui.mobile.GpuiInputActivity,performDestroy]
10-18 16:58:27.356 9999 9999 I am_on_create_called: [0,dev.gpui.mobile.GpuiInputActivity,performCreate]"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 6768, api=29)
        with self.assertRaisesRegex(RuntimeError, "same Activity/PID"):
            android_acceptance.validate_activity_recreation_events(log, events, api=29)
        no_relaunch = "\\n".join(log.splitlines()[1:])
        events = android_acceptance.activity_recreation_events(
            no_relaunch, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 9999, api=29)
        with self.assertRaisesRegex(RuntimeError, "same Activity/PID"):
            android_acceptance.validate_activity_recreation_events(no_relaunch, events, api=29)

    def test_api26_requires_native_generation_relaunch_and_resume_sequence(self):
        log = """10-18 16:56:19.742 1701 1716 I am_relaunch_resume_activity: [0,137211794,9,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity]
10-18 16:56:19.806 5131 5150 I gpui-android: gpui_mobile::android::jni: MainEvent::Destroy
10-18 16:56:19.807 5131 5150 I gpui-android: gpui_mobile::android::jni: run_event_loop: exiting main loop
10-18 16:56:19.830 5131 5131 I android-activity: Creating: Activity = 0x21d2, saved state size = 0
10-18 16:56:19.833 5131 5253 I gpui-android: gpui_mobile::android::jni: init_platform: started Activity session generation=2
10-18 16:56:19.980 5131 5253 I gpui-android: gpui_mobile::android::jni: MainEvent::Start
10-18 16:56:19.981 5131 5253 I gpui-android: gpui_mobile::android::jni: deferred: Resume (iter=2)"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 5131, api=26)
        android_acceptance.validate_activity_recreation_events(
            log, events, api=26, baseline_generation=1)
        self.assertEqual(len(events["relaunch"]), 1)

    def test_api26_rejects_missing_correlation_and_wrong_generation(self):
        log = """10-18 16:56:19.742 1701 1716 I am_relaunch_resume_activity: [0,137211794,9,dev.gpui.mobile.example/dev.gpui.mobile.GpuiInputActivity]
10-18 16:56:19.806 5131 5150 I gpui-android: gpui_mobile::android::jni: MainEvent::Destroy
10-18 16:56:19.807 5131 5150 I gpui-android: gpui_mobile::android::jni: run_event_loop: exiting main loop
10-18 16:56:19.830 5131 5131 I android-activity: Creating: Activity = 0x21d2, saved state size = 0
10-18 16:56:19.833 5131 5253 I gpui-android: gpui_mobile::android::jni: init_platform: started Activity session generation=2
10-18 16:56:19.980 5131 5253 I gpui-android: gpui_mobile::android::jni: MainEvent::Start
10-18 16:56:19.981 5131 5253 I gpui-android: gpui_mobile::android::jni: deferred: Resume (iter=2)"""
        events = android_acceptance.activity_recreation_events(
            log, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 5131, api=26)
        with self.assertRaisesRegex(RuntimeError, "does not expose an ActivityRecord token"):
            android_acceptance.validate_activity_recreation_events(
                log, events, api=26, baseline_generation=0)
        wrong_process = "\\n".join(
            line.replace("5131", "9999") if "5131" in line else line
            for line in log.splitlines()
        )
        events = android_acceptance.activity_recreation_events(
            wrong_process, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 5131, api=26)
        with self.assertRaisesRegex(RuntimeError, "does not expose an ActivityRecord token"):
            android_acceptance.validate_activity_recreation_events(
                wrong_process, events, api=26, baseline_generation=1)
        no_relaunch = "\\n".join(line for line in log.splitlines() if "am_relaunch_resume_activity" not in line)
        events = android_acceptance.activity_recreation_events(
            no_relaunch, "dev.gpui.mobile.example", "dev.gpui.mobile.GpuiInputActivity", 5131, api=26)
        with self.assertRaisesRegex(RuntimeError, "does not expose an ActivityRecord token"):
            android_acceptance.validate_activity_recreation_events(
                no_relaunch, events, api=26, baseline_generation=1)

    def test_modern_ime_visibility_reads_geometry_then_input_method(self):
        calls = []
        _, ime, geometry = android_acceptance.modern_ime_visibility_sample(
            lambda: calls.append("window") or
                "InsetsSource id=0x2 type=ime frame=[0,1200][1080,1920] visible=true",
            lambda: calls.append("input_method") or "mInputShown=true",
        )
        self.assertEqual(calls, ["window", "input_method"])
        self.assertTrue(geometry)
        self.assertTrue(android_acceptance.input_method_is_shown(ime))

    def test_modern_ime_visibility_skips_slow_input_dump_until_geometry_exists(self):
        calls = []
        _, ime, geometry = android_acceptance.modern_ime_visibility_sample(
            lambda: calls.append("window") or
                "InsetsSource id=0x2 type=ime frame=[0,1920][1080,1920] visible=false",
            lambda: calls.append("input_method") or "mInputShown=true",
        )
        self.assertEqual(calls, ["window"])
        self.assertEqual(ime, "")
        self.assertEqual(geometry, [])

    def test_modern_ime_visibility_still_requires_true_input_method_state(self):
        calls = []
        _, ime, geometry = android_acceptance.modern_ime_visibility_sample(
            lambda: calls.append("window") or
                "InsetsSource id=0x2 type=ime frame=[0,1200][1080,1920] visible=true",
            lambda: calls.append("input_method") or "mInputShown=false",
        )
        self.assertEqual(calls, ["window", "input_method"])
        self.assertTrue(geometry)
        self.assertFalse(android_acceptance.input_method_is_shown(ime))
        self.assertFalse(android_acceptance.ime_visibility_matches(True, ime, geometry))


    def test_api36_visible_poll_respects_one_deadline_without_ime_dump_until_geometry(self):
        now = [0.0]
        calls = []
        timeouts = []

        def fake_adb(serial, *args, timeout=30, **kwargs):
            calls.append(args)
            timeouts.append(timeout)
            if args == ("shell", "getprop", "ro.build.version.sdk"):
                return "36"
            if args == ("shell", "dumpsys", "window", "displays"):
                return "InsetsSource id=0x2 type=ime frame=[0,1920][1080,1920] visible=false"
            if args == ("shell", "dumpsys", "input_method"):
                self.fail("slow input_method dump must not run without visible geometry")
            self.fail(f"unexpected adb command: {args}")

        def fake_sleep(duration):
            now[0] += duration

        with patch.object(android_acceptance, "adb", side_effect=fake_adb), \
             patch.object(android_acceptance.time, "monotonic", side_effect=lambda: now[0]), \
             patch.object(android_acceptance.time, "sleep", side_effect=fake_sleep):
            with self.assertRaisesRegex(RuntimeError, "did not become visible within 0.3s"):
                android_acceptance.check_ime_shown("emulator-test", timeout=0.3)
        self.assertNotIn(("shell", "dumpsys", "input_method"), calls)
        self.assertTrue(timeouts)
        self.assertTrue(all(0 < timeout <= 0.3 for timeout in timeouts))
        self.assertLessEqual(now[0], 0.3)


if __name__ == "__main__":
    unittest.main()
