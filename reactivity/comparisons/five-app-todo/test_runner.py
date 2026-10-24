"""Offline checks for the new evidence boundary, not synthetic performance data."""
import unittest
from pathlib import Path
import run as runner


class EvidenceBoundary(unittest.TestCase):
    def setUp(self):
        runner.core.EXPECTED_WINDOW_TITLES.update({name:name for name in runner.APPS})
    def cell(self,mode="busy"):
        return {"variant":"mygo","mode":mode,"repeat":1,"source_and_binary_unchanged":True,"interactive_work_matched":True,"drawable_work_acknowledged":True,"full_model_matched":True,"ordered_callbacks_matched":True}
    def test_model_success_without_pixel_acknowledgment_is_rejected(self):
        cell=self.cell();cell["drawable_work_acknowledged"]=False
        self.assertFalse(runner.accepted(cell))
    def test_pixels_without_completed_work_are_rejected(self):
        cell=self.cell();cell["interactive_work_matched"]=False
        self.assertFalse(runner.accepted(cell))
    def test_failed_resource_values_do_not_enter_passing_medians(self):
        row=self.cell();row.update(interactive_work_matched=False,process_metrics={"process_cpu_percent_one_core_100":0.0})
        metrics=runner.fifteen_metrics([row],{},{} )
        self.assertIsNone(metrics["mygo"]["cpu-busy"]["median"])
        self.assertEqual(metrics["mygo"]["cpu-busy"]["status"],"no-passing-workload")
        self.assertEqual(len(metrics["mygo"]),15)
    def test_unsupported_gpu_and_physical_display_never_become_zero(self):
        metrics=runner.fifteen_metrics([],{},{} )
        self.assertIsNone(metrics["gpui"]["gpu-busy"]["value"])
        self.assertEqual(metrics["gpui"]["smoothness-heavy"]["status"],"unsupported-physical-display")
    def test_middle_row_corruption_is_detected_by_full_model(self):
        state,actions=runner.expected_state("heavy",30)
        changed={**state,"rows":[dict(row) for row in state["rows"]]}
        changed["rows"][5000]["title"]="corrupt"
        self.assertNotEqual(runner.canonical_model_digest(state),runner.canonical_model_digest(changed))
        self.assertEqual(len(actions),105)
        self.assertEqual(state["rows"][0],{"id":0,"title":"Task 0001","done":True})
        self.assertEqual(state["rows"][-1],{"id":10014,"title":"bench-014","done":False})
    def test_out_of_order_callbacks_are_rejected_even_if_endpoint_matches(self):
        cell=self.cell();cell["ordered_callbacks_matched"]=False
        self.assertFalse(runner.accepted(cell))


if __name__=="__main__":unittest.main()
