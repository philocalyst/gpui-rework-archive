#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)

: "${LUNA_PAINT_RUN_ID:?set a new output-directory name}"
: "${LUNA_DISPLAY:?set the reviewed persistent private Xvfb display}"
: "${LUNA_GPUI_CONTROL_BINARY:?set full-rebuild GPUI executable path}"
: "${LUNA_GPUI_CONTROL_SHA:?set full-rebuild GPUI executable SHA-256}"
: "${LUNA_GPUI_DIRECT_BINARY:?set direct-port GPUI executable path}"
: "${LUNA_GPUI_DIRECT_SHA:?set direct-port GPUI executable SHA-256}"
: "${LUNA_MYGO_BINARY:?set pinned MyGo executable path}"
: "${LUNA_MYGO_SHA:?set MyGo executable SHA-256}"
: "${LUNA_NANOUI_BINARY:?set pinned NanoUI executable path}"
: "${LUNA_NANOUI_SHA:?set NanoUI executable SHA-256}"
: "${LUNA_OBSERVER_BINARY:?set reviewed X11 observer executable path}"
: "${LUNA_OBSERVER_SHA:?set observer executable SHA-256}"
: "${LUNA_GPUI_SOURCE_TREE:?set nested reactivity worktree used for both GPUI builds}"
: "${LUNA_GPUI_SOURCE_COMMIT:?set exact GPUI production commit}"
: "${LUNA_GPUI_EXPECTED_COMMIT:?set reviewer-approved GPUI source commit}"
: "${LUNA_CONTROL_FIXTURE_SHA:?set reviewed control fixture SHA-256}"
: "${LUNA_DIRECT_FIXTURE_SHA:?set reviewed direct fixture SHA-256}"
: "${LUNA_GPUI_CONTROL_RECORD:?set control build and pixel-preflight record}"
: "${LUNA_GPUI_DIRECT_RECORD:?set direct build and pixel-preflight record}"
: "${LUNA_GPUI_CONTROL_BUILD_MANIFEST:?set immutable control build manifest}"
: "${LUNA_GPUI_DIRECT_BUILD_MANIFEST:?set immutable direct build manifest}"
: "${LUNA_MYGO_SOURCE_TREE:?set pinned MyGo comparator checkout}"
: "${LUNA_NANOUI_SOURCE_TREE:?set pinned NanoUI comparator checkout}"
: "${LUNA_MYGO_RECORD:?set MyGo binary and preflight record}"
: "${LUNA_NANOUI_RECORD:?set NanoUI binary and preflight record}"
: "${LUNA_PEER_BUILD_MANIFEST:?set pinned MyGo/NanoUI build manifest}"
: "${LUNA_GPUI_FEATURE_SET:?set the exact reviewed Cargo feature set from both builds}"
: "${LUNA_RUNTIME_BACKEND_STATUS:?record reviewed actual backend selected by each app}"
: "${LUNA_SESSION_A11Y_STATUS:?record reviewed active session accessibility status}"

MYGO_COMMIT=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3
NANOUI_COMMIT=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f
NANOUI_PATCH_SHA=c698367086a8d17feeceae6f99d0abda2fce273f35c3e4f8f0e0a32fab586224
CONTROL_FIXTURE_PIN=a414736810a4fc89320f6964226d938a2f3a868164afd6125ac5f121d102ff1c
DIRECT_FIXTURE_PIN=a8c994a4a5e2f83770fd24e135ab457e924d6e544ed4c68ce5a4b4bb28324354
MYGO_FIXTURE_PIN=d05239655152b3354bacededa984d4f2ad8c4e1519ef30940e7f19cc55d7150b
NANOUI_FIXTURE_PIN=46061d578913885f42ca2e38bce6ad6714f47de70a36608bbeb673d9e822df1c
PEER_FONT=/root/.local/share/fonts/luna-bench/DejaVuSans.ttf
PEER_FONT_SHA=58568c88a01b80dfc056daca3eeafd434a0380df1a48dda53f0de0d716109bbd
OBSERVER_PIN=b4f84c80caa854d974643a2c20823537601a04745a7bcf320be356732b42f88b
CONTROL_FIXTURE="$DIR/fixtures/gpui-paint-control.rs"
DIRECT_FIXTURE="$DIR/fixtures/gpui-paint-direct.rs"
GPUI_COMMIT=$LUNA_GPUI_EXPECTED_COMMIT
CONTROL_FIXTURE_SHA=$LUNA_CONTROL_FIXTURE_SHA
DIRECT_FIXTURE_SHA=$LUNA_DIRECT_FIXTURE_SHA
OBSERVER_PATH=/tmp/gpui-bench-observer-target/release/luna-x11-observer

[[ "$LUNA_PAINT_RUN_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || {
  echo 'run ID must be a simple filename component' >&2; exit 2;
}
[[ "$LUNA_DISPLAY" =~ ^:[0-9]+(\.[0-9]+)?$ ]] || {
  echo 'LUNA_DISPLAY must name the reviewed persistent private Xvfb display' >&2; exit 2;
}
DISPLAY_NUMBER=${LUNA_DISPLAY#:}
DISPLAY_NUMBER=${DISPLAY_NUMBER%%.*}
[[ -S "/tmp/.X11-unix/X$DISPLAY_NUMBER" ]] || {
  echo "no X11 socket for $LUNA_DISPLAY" >&2; exit 2;
}
[[ "$LUNA_OBSERVER_SHA" == "$OBSERVER_PIN" ]] || {
  echo 'observer hash differs from the reviewed X11 observer build' >&2; exit 2;
}
[[ "$LUNA_OBSERVER_BINARY" == "$OBSERVER_PATH" ]] || {
  echo "observer path must be $OBSERVER_PATH" >&2; exit 2;
}

sha_is() {
  local path=$1 expected=$2 actual
  [[ -n "$expected" && -f "$path" ]] || { echo "missing binary or SHA: $path" >&2; return 1; }
  actual=$(sha256sum "$path" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || {
    echo "SHA mismatch for $path: expected $expected, got $actual" >&2; return 1;
  }
}
has_line() { rg -Fxq "$2" "$1" || { echo "record $1 missing: $2" >&2; return 1; }; }
record_ok() {
  local record=$1 sha=$2 fixture=$3 source=$4
  [[ -f "$record" ]] || { echo "missing reviewed record $record" >&2; return 1; }
  has_line "$record" 'status=pass'
  has_line "$record" "binary_sha256=$sha"
  has_line "$record" "fixture_sha256=$fixture"
  has_line "$record" "source_commit=$source"
  has_line "$record" 'workloads=eager-0,eager-1000,eager-10000,virtual-250000'
  has_line "$record" 'checks=observer-preflight,800x600-client,exact-marker,button-and-row-ink,one-click-exact-marker-transition'
}
gpui_build_manifest_ok() {
  local manifest=$1 binary=$2 sha=$3 fixture=$4 fixture_sha=$5
  [[ -f "$manifest" ]] || { echo "missing immutable build manifest $manifest" >&2; return 1; }
  has_line "$manifest" "source_commit=$GPUI_COMMIT"
  has_line "$manifest" "source_tree=$LUNA_GPUI_SOURCE_TREE"
  has_line "$manifest" "fixture_path=$fixture"
  has_line "$manifest" "fixture_sha256=$fixture_sha"
  has_line "$manifest" "binary=$binary"
  has_line "$manifest" "binary_sha256=$sha"
  has_line "$manifest" 'profile=release'
  has_line "$manifest" "cargo_features=$LUNA_GPUI_FEATURE_SET"
  has_line "$manifest" 'workspace=reactivity/Cargo.toml'
  has_line "$manifest" 'locked=true'
}

verify_source() {
  local worktree=$1 commit=$2 top item
  top=$(git -C "$worktree" rev-parse --show-toplevel)
  [[ "$worktree" == "$top/reactivity" ]] || {
    echo "GPUI path is not the nested reactivity workspace: $worktree" >&2; return 1;
  }
  [[ $(git -C "$top" rev-parse HEAD) == "$commit" ]] || {
    echo "GPUI source commit mismatch at $top" >&2; return 1;
  }
  local pathspecs=(.cargo/ reactivity/.cargo/ rust-toolchain rust-toolchain.toml rust-toolchain.yaml reactivity/rust-toolchain reactivity/rust-toolchain.toml reactivity/rust-toolchain.yaml reactivity/Cargo.toml reactivity/Cargo.lock reactivity/crates/ reactivity/vendor/)
  git -C "$top" diff --quiet "$commit" -- "${pathspecs[@]}" || {
    echo "compiled GPUI source/config changed since $commit" >&2; return 1;
  }
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == reactivity/crates/gpui/examples/luna_paint_control.rs || \
       "$item" == reactivity/crates/gpui/examples/luna_paint_direct.rs ]] || {
      echo "unexpected GPUI source/config input: $item" >&2; return 1;
    }
  done < <(git -C "$top" ls-files --others --ignored --exclude-standard -- "${pathspecs[@]}")
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == reactivity/crates/gpui/examples/luna_paint_control.rs || \
       "$item" == reactivity/crates/gpui/examples/luna_paint_direct.rs ]] || {
      echo "unexpected GPUI untracked source/config input: $item" >&2; return 1;
    }
  done < <(git -C "$top" ls-files --others --exclude-standard -- "${pathspecs[@]}")
  [[ $(sha256sum "$CONTROL_FIXTURE" | cut -d' ' -f1) == "$CONTROL_FIXTURE_SHA" ]]
  [[ $(sha256sum "$DIRECT_FIXTURE" | cut -d' ' -f1) == "$DIRECT_FIXTURE_SHA" ]]
  cmp "$CONTROL_FIXTURE" "$worktree/crates/gpui/examples/luna_paint_control.rs"
  cmp "$DIRECT_FIXTURE" "$worktree/crates/gpui/examples/luna_paint_direct.rs"
}

verify_peer_source() {
  local worktree=$1 commit=$2 fixture=$3 fixture_sha=$4 build_config_sha=${5:-} top item changed repo_fixture
  top=$(git -C "$worktree" rev-parse --show-toplevel)
  [[ "$top" == "$worktree" ]] || {
    echo "peer source path must name its repository root: $worktree" >&2; return 1;
  }
  [[ $(git -C "$top" rev-parse HEAD) == "$commit" ]] || {
    echo "peer source commit mismatch at $top" >&2; return 1;
  }
  [[ $(sha256sum "$fixture" | cut -d' ' -f1) == "$fixture_sha" ]] || {
    echo "peer fixture SHA mismatch: $fixture" >&2; return 1;
  }
  if [[ -n "$build_config_sha" ]]; then
    repo_fixture=examples/luna-bench/main.zig
    [[ $(sha256sum "$top/build.zig" | cut -d' ' -f1) == "$build_config_sha" ]] || {
      echo "NanoUI build.zig SHA mismatch at $top" >&2; return 1;
    }
    changed=$(git -C "$top" diff --name-only "$commit" --)
    [[ "$changed" == build.zig ]] || {
      echo "unexpected tracked NanoUI source/config changes: ${changed:-<none>}" >&2; return 1;
    }
    local patch_sha
    patch_sha=$(git -C "$top" diff --binary "$commit" -- build.zig | sha256sum | cut -d' ' -f1)
    [[ "$patch_sha" == "$NANOUI_PATCH_SHA" ]] || {
      echo "NanoUI build.zig patch differs from the reviewed example filter" >&2; return 1;
    }
  else
    repo_fixture=examples/luna-bench/main.go
    git -C "$top" diff --quiet "$commit" -- || {
      echo "tracked MyGo source/config changed since $commit" >&2; return 1;
    }
  fi
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == "$repo_fixture" ]] || {
      echo "unexpected peer source input: $item" >&2; return 1;
    }
  done < <(git -C "$top" ls-files --others --exclude-standard)
  cmp "$fixture" "$top/$repo_fixture"
}

verify_pins() {
  [[ $(git -C "$LUNA_MYGO_SOURCE_TREE" rev-parse HEAD) == "$MYGO_COMMIT" ]]
  [[ $(git -C "$LUNA_NANOUI_SOURCE_TREE" rev-parse HEAD) == "$NANOUI_COMMIT" ]]
  local mygo_fixture_sha nanoui_fixture_sha nanoui_build_config_sha
  mygo_fixture_sha=$(sha256sum "$BASE/fixtures/mygo-main.go" | cut -d' ' -f1)
  nanoui_fixture_sha=$(sha256sum "$BASE/fixtures/nanoui-main.zig" | cut -d' ' -f1)
  [[ "$mygo_fixture_sha" == "$MYGO_FIXTURE_PIN" && "$nanoui_fixture_sha" == "$NANOUI_FIXTURE_PIN" ]] || {
    echo 'peer fixture files differ from their reviewed pins' >&2; return 1;
  }
  nanoui_build_config_sha=$(awk -F= '$1=="build_config_sha256"{print $2}' "$LUNA_NANOUI_RECORD")
  [[ -n "$nanoui_build_config_sha" ]] || { echo 'NanoUI preflight record lacks build_config_sha256' >&2; return 1; }
  sha_is "$LUNA_GPUI_CONTROL_BINARY" "$LUNA_GPUI_CONTROL_SHA"
  sha_is "$LUNA_GPUI_DIRECT_BINARY" "$LUNA_GPUI_DIRECT_SHA"
  sha_is "$LUNA_MYGO_BINARY" "$LUNA_MYGO_SHA"
  sha_is "$LUNA_NANOUI_BINARY" "$LUNA_NANOUI_SHA"
  sha_is "$LUNA_OBSERVER_BINARY" "$LUNA_OBSERVER_SHA"
  record_ok "$LUNA_GPUI_CONTROL_RECORD" "$LUNA_GPUI_CONTROL_SHA" "$CONTROL_FIXTURE_SHA" "$GPUI_COMMIT"
  record_ok "$LUNA_GPUI_DIRECT_RECORD" "$LUNA_GPUI_DIRECT_SHA" "$DIRECT_FIXTURE_SHA" "$GPUI_COMMIT"
  record_ok "$LUNA_MYGO_RECORD" "$LUNA_MYGO_SHA" "$mygo_fixture_sha" "$MYGO_COMMIT"
  record_ok "$LUNA_NANOUI_RECORD" "$LUNA_NANOUI_SHA" "$nanoui_fixture_sha" "$NANOUI_COMMIT"
  [[ $(sha256sum "$LUNA_NANOUI_SOURCE_TREE/build.zig" | cut -d' ' -f1) == "$nanoui_build_config_sha" ]] || {
    echo 'NanoUI record build_config_sha256 does not match the actual build.zig' >&2; return 1;
  }
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_source_commit=$MYGO_COMMIT"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_source_worktree=$LUNA_MYGO_SOURCE_TREE"
  has_line "$LUNA_PEER_BUILD_MANIFEST" 'mygo_fixture=reactivity/benchmarks/nanoui-mygo-gpui/fixtures/mygo-main.go'
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_fixture_sha256=$mygo_fixture_sha"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_binary=$LUNA_MYGO_BINARY"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_binary_sha256=$LUNA_MYGO_SHA"
  has_line "$LUNA_PEER_BUILD_MANIFEST" 'mygo_toolchain=go1.27.1 linux/amd64'
  has_line "$LUNA_PEER_BUILD_MANIFEST" "mygo_build_command=go build -trimpath -o $LUNA_MYGO_BINARY ./examples/luna-bench"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_source_commit=$NANOUI_COMMIT"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_source_worktree=$LUNA_NANOUI_SOURCE_TREE"
  has_line "$LUNA_PEER_BUILD_MANIFEST" 'nanoui_fixture=reactivity/benchmarks/nanoui-mygo-gpui/fixtures/nanoui-main.zig'
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_fixture_sha256=$nanoui_fixture_sha"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_binary=$LUNA_NANOUI_BINARY"
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_binary_sha256=$LUNA_NANOUI_SHA"
  has_line "$LUNA_PEER_BUILD_MANIFEST" 'nanoui_toolchain=zig 0.17.0'
  has_line "$LUNA_PEER_BUILD_MANIFEST" 'nanoui_build_command=zig build -Doptimize=ReleaseFast --prefix /tmp/luna-nanoui-pinned-output'
  has_line "$LUNA_PEER_BUILD_MANIFEST" "nanoui_build_zig_patch_sha256=$NANOUI_PATCH_SHA"
  sha_is "$PEER_FONT" "$PEER_FONT_SHA"
  verify_peer_source "$LUNA_MYGO_SOURCE_TREE" "$MYGO_COMMIT" "$BASE/fixtures/mygo-main.go" "$mygo_fixture_sha"
  verify_peer_source "$LUNA_NANOUI_SOURCE_TREE" "$NANOUI_COMMIT" "$BASE/fixtures/nanoui-main.zig" "$nanoui_fixture_sha" "$nanoui_build_config_sha"
  verify_source "$LUNA_GPUI_SOURCE_TREE" "$LUNA_GPUI_SOURCE_COMMIT"
  gpui_build_manifest_ok "$LUNA_GPUI_CONTROL_BUILD_MANIFEST" "$LUNA_GPUI_CONTROL_BINARY" \
    "$LUNA_GPUI_CONTROL_SHA" "$CONTROL_FIXTURE" "$CONTROL_FIXTURE_SHA"
  gpui_build_manifest_ok "$LUNA_GPUI_DIRECT_BUILD_MANIFEST" "$LUNA_GPUI_DIRECT_BINARY" \
    "$LUNA_GPUI_DIRECT_SHA" "$DIRECT_FIXTURE" "$DIRECT_FIXTURE_SHA"
  [[ "$LUNA_GPUI_CONTROL_SHA" != "$LUNA_GPUI_DIRECT_SHA" ]] || {
    echo 'control and direct binaries are identical; refusing an uninformative paired run' >&2; return 1;
  }
}

[[ "$LUNA_GPUI_EXPECTED_COMMIT" == "$LUNA_GPUI_SOURCE_COMMIT" ]] || {
  echo 'GPUI build source commit differs from reviewed expected commit' >&2; exit 2;
}
[[ "$CONTROL_FIXTURE_SHA" == "$CONTROL_FIXTURE_PIN" && "$DIRECT_FIXTURE_SHA" == "$DIRECT_FIXTURE_PIN" ]] || {
  echo 'GPUI fixture hashes differ from the reviewed paint-only fixtures' >&2; exit 2;
}

# Guard every planned cell before making output or launching a process.
workloads=('eager 0' 'eager 1000' 'eager 10000' 'virtual 250000')
variants=(gpui-control gpui-direct mygo nanoui)
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  verify_pins
  for variant in "${variants[@]}"; do echo "GUARD_PASS,$variant,$mode,$rows"; done
done
if [[ "${LUNA_GUARD_ONLY:-0}" == 1 ]]; then
  echo 'GUARD_ONLY_PASS,all 16 cells validated; no output or observer started'
  exit 0
fi

: "${LUNA_STARTS:=100}"
: "${LUNA_CLICKS_PER_START:=10}"
: "${LUNA_MEMORY_STARTS:=5}"
: "${LUNA_IDLE_MS:=750}"
[[ "$LUNA_STARTS" == 100 && "$LUNA_CLICKS_PER_START" == 10 && \
   "$LUNA_MEMORY_STARTS" == 5 && "$LUNA_IDLE_MS" == 750 ]] || {
  echo 'capture protocol is fixed at 100 starts, 10 clicks/start, 5 memory samples, 750 ms' >&2; exit 2;
}
OUT="$DIR/results/$LUNA_PAINT_RUN_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }
mkdir -p "$OUT"
source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY PROFILE=native-default
unset LUNA_INTERPRETER LUNA_LIBRARY_PATH || true
export LUNA_STARTS LUNA_CLICKS_PER_START LUNA_MEMORY_STARTS LUNA_IDLE_MS
export LUNA_REQUIRE_BINARY_IDENTITY=1
unset LUNA_STAGES LUNA_PREFLIGHT LUNA_SCREENSHOT_PATH || true

{
  echo "run_id=$LUNA_PAINT_RUN_ID"
  echo "started_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "display=$LUNA_DISPLAY"
  echo 'observer_endpoint=X11 drawable exact marker-pixel readback after XDamage'
  echo 'profile=native-default (GPUI Auto; peer native defaults)'
  echo "gpui_source_commit=$LUNA_GPUI_SOURCE_COMMIT"
  echo "gpui_source_tree=$LUNA_GPUI_SOURCE_TREE"
  echo "gpui_cargo_features=$LUNA_GPUI_FEATURE_SET"
  echo "gpui_control_fixture_sha256=$CONTROL_FIXTURE_SHA"
  echo "gpui_direct_fixture_sha256=$DIRECT_FIXTURE_SHA"
  echo "mygo_source_commit=$MYGO_COMMIT"
  echo "mygo_fixture_sha256=$(sha256sum "$BASE/fixtures/mygo-main.go" | cut -d' ' -f1)"
  echo "nanoui_source_commit=$NANOUI_COMMIT"
  echo "peer_font=$PEER_FONT"
  echo "peer_font_sha256=$PEER_FONT_SHA"
  echo "mygo_source_tree=$LUNA_MYGO_SOURCE_TREE"
  echo "nanoui_source_tree=$LUNA_NANOUI_SOURCE_TREE"
  echo "nanoui_fixture_sha256=$(sha256sum "$BASE/fixtures/nanoui-main.zig" | cut -d' ' -f1)"
  echo "nanoui_build_config_sha256=$(awk -F= '$1=="build_config_sha256"{print $2}' "$LUNA_NANOUI_RECORD")"
  echo "gpui_control_binary_sha256=$LUNA_GPUI_CONTROL_SHA"
  echo "gpui_direct_binary_sha256=$LUNA_GPUI_DIRECT_SHA"
  echo "gpui_control_binary=$LUNA_GPUI_CONTROL_BINARY"
  echo "gpui_direct_binary=$LUNA_GPUI_DIRECT_BINARY"
  echo "mygo_binary_sha256=$LUNA_MYGO_SHA"
  echo "nanoui_binary_sha256=$LUNA_NANOUI_SHA"
  echo "mygo_binary=$LUNA_MYGO_BINARY"
  echo "nanoui_binary=$LUNA_NANOUI_BINARY"
  echo "observer_binary_sha256=$LUNA_OBSERVER_SHA"
  echo "runtime_backend_status=$LUNA_RUNTIME_BACKEND_STATUS"
  echo "session_accessibility_status=$LUNA_SESSION_A11Y_STATUS"
  echo "gpui_control_record_sha256=$(sha256sum "$LUNA_GPUI_CONTROL_RECORD" | cut -d' ' -f1)"
  echo "gpui_direct_record_sha256=$(sha256sum "$LUNA_GPUI_DIRECT_RECORD" | cut -d' ' -f1)"
  echo "gpui_control_build_manifest_sha256=$(sha256sum "$LUNA_GPUI_CONTROL_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "gpui_direct_build_manifest_sha256=$(sha256sum "$LUNA_GPUI_DIRECT_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "peer_build_manifest_sha256=$(sha256sum "$LUNA_PEER_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "gpui_control_build_manifest=$LUNA_GPUI_CONTROL_BUILD_MANIFEST"
  echo "gpui_direct_build_manifest=$LUNA_GPUI_DIRECT_BUILD_MANIFEST"
  echo "peer_build_manifest=$LUNA_PEER_BUILD_MANIFEST"
  echo "mygo_record_sha256=$(sha256sum "$LUNA_MYGO_RECORD" | cut -d' ' -f1)"
  echo "nanoui_record_sha256=$(sha256sum "$LUNA_NANOUI_RECORD" | cut -d' ' -f1)"
  echo "starts=$LUNA_STARTS"
  echo "clicks_per_start=$LUNA_CLICKS_PER_START"
  echo "memory_starts=$LUNA_MEMORY_STARTS"
  echo "idle_ms=$LUNA_IDLE_MS"
} > "$OUT/run-manifest.txt"

index=0
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  case $((index % 4)) in
    0) order=(gpui-control gpui-direct mygo nanoui) ;;
    1) order=(gpui-direct gpui-control nanoui mygo) ;;
    2) order=(mygo nanoui gpui-control gpui-direct) ;;
    3) order=(nanoui mygo gpui-direct gpui-control) ;;
  esac
  for variant in "${order[@]}"; do
    verify_pins
    case "$variant" in
      gpui-control)
        export APP=gpui LUNA_GPUI_BINARY=$LUNA_GPUI_CONTROL_BINARY
        export LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_CONTROL_SHA ;;
      gpui-direct)
        export APP=gpui LUNA_GPUI_BINARY=$LUNA_GPUI_DIRECT_BINARY
        export LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_DIRECT_SHA ;;
      mygo)
        export APP=mygo LUNA_MYGO_BINARY=$LUNA_MYGO_BINARY LUNA_MYGO_EXPECTED_SHA=$LUNA_MYGO_SHA ;;
      nanoui)
        export APP=nanoui LUNA_NANOUI_BINARY=$LUNA_NANOUI_BINARY LUNA_NANOUI_EXPECTED_SHA=$LUNA_NANOUI_SHA ;;
    esac
    export MODE=$mode ROWS=$rows LUNA_MODE=$mode LUNA_ROWS=$rows
    echo "RUN,$variant,$mode,$rows" | tee -a "$OUT/order.csv"
    "$BASE/run-one.sh" > "$OUT/$variant-$mode-$rows.raw" 2>&1
    echo "DONE,$variant,$mode,$rows" | tee -a "$OUT/order.csv"
  done
  index=$((index + 1))
done
(cd "$OUT" && sha256sum ./*.raw order.csv run-manifest.txt > sha256.txt)
echo "capture complete: $OUT"
