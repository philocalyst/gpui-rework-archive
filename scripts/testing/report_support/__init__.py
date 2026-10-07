"""Forge-neutral public report API; adapters only consume this interface."""
from .assets import read_asset, report_assets, sanitize_svg
from .common import validate_relative, validate_site_base, json_request
from .comparison import comparison_summary
from .manifest import load_report, validate_report_head
from .metrics import metric, format_ms, markdown_text, checkpoint_metric_values, markdown_metrics_table, markdown_platform_checks
from .presentation import markdown_change_summary, markdown_report, hosted_report_asset_url, preview_checkpoints, checkpoint_preview_text, trusted_index, pages_index, validate_records, pull_index
