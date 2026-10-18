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


if __name__ == "__main__":
    unittest.main()
