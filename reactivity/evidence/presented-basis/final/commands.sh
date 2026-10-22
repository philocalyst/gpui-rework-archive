#!/usr/bin/env bash
# Historical qualification commands; rerun from the qualified source worktree.
# This file documents commands; it is not an automatically executing test runner.
source /tmp/gpui-native-env.sh
export CARGO_BUILD_JOBS=2
export CARGO_TARGET_DIR=/tmp/gpui-presented-basis-target
cargo test --manifest-path reactivity/Cargo.toml -p gpui --offline --locked -- --test-threads=1
cargo test --manifest-path reactivity/Cargo.toml -p gpui --features desktop,x11,wayland,gpui_canvas/parallel --lib --offline --locked -- --nocapture --test-threads=1
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --features desktop,x11,wayland,gpui_canvas/parallel --all-targets --offline --locked -- -D warnings
RUSTC_BOOTSTRAP=1 cargo check --manifest-path reactivity/Cargo.toml -p gpui --features desktop,gpui_canvas/parallel --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort --offline --locked
RUSTC_BOOTSTRAP=1 cargo check --manifest-path reactivity/Cargo.toml -p gpui --features desktop,gpui_canvas/parallel --all-targets --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort --offline --locked
cargo test --manifest-path reactivity/Cargo.toml -p gpui --no-default-features --lib basis_ --offline --locked -- --nocapture --test-threads=1
# Held private foreground Xvfb :160 existed during these separate sessions.
DISPLAY=:160 dbus-run-session -- /tmp/gpui-presented-basis-native-9c1d-frozen native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy --ignored --exact --nocapture --test-threads=1
DISPLAY=:160 dbus-run-session -- /tmp/gpui-presented-basis-native-9c1d-frozen native::accessibility::linux_tests::checkbox::native_atspi_checkbox_action_state_and_events --ignored --exact --nocapture --test-threads=1
# Auxiliary original-owner probe: base619 + exact raw/baseline-context.patch only.
cargo test --manifest-path /tmp/gpui-presented-basis-baseline-sol/reactivity/Cargo.toml -p gpui --no-default-features --lib original_borrowed_geometry_context_layout --offline --locked -- --nocapture --test-threads=1
