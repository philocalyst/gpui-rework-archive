#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
OBSERVER=/tmp/gpui-bench-observer-target/release/luna-x11-observer
MYGO_COMMIT=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3
NANOUI_COMMIT=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f
NANOUI_PATCH_SHA=c698367086a8d17feeceae6f99d0abda2fce273f35c3e4f8f0e0a32fab586224
CONTROL_FIXTURE_PIN=a414736810a4fc89320f6964226d938a2f3a868164afd6125ac5f121d102ff1c
DIRECT_FIXTURE_PIN=a8c994a4a5e2f83770fd24e135ab457e924d6e544ed4c68ce5a4b4bb28324354
MYGO_FIXTURE_PIN=d05239655152b3354bacededa984d4f2ad8c4e1519ef30940e7f19cc55d7150b
NANOUI_FIXTURE_PIN=46061d578913885f42ca2e38bce6ad6714f47de70a36608bbeb673d9e822df1c
FONT=/root/.local/share/fonts/luna-bench/DejaVuSans.ttf
FONT_SHA=58568c88a01b80dfc056daca3eeafd434a0380df1a48dda53f0de0d716109bbd
OBSERVER_SHA_PIN=b4f84c80caa854d974643a2c20823537601a04745a7bcf320be356732b42f88b
CONTROL_FIXTURE="$DIR/fixtures/gpui-paint-control.rs"
DIRECT_FIXTURE="$DIR/fixtures/gpui-paint-direct.rs"
WORKLOADS='eager-0,eager-1000,eager-10000,virtual-250000'
CHECKS='observer-preflight,800x600-client,exact-marker,button-and-row-ink,one-click-exact-marker-transition'

: "${LUNA_PREFLIGHT_ID:?set a unique preflight output directory name}"
: "${LUNA_DISPLAY:?set the reviewed persistent private Xvfb display}"
: "${LUNA_GPUI_SOURCE_TREE:?set nested reactivity worktree used for both GPUI builds}"
: "${LUNA_GPUI_SOURCE_COMMIT:?set exact GPUI production commit}"
: "${LUNA_GPUI_EXPECTED_COMMIT:?set reviewer-approved GPUI source commit}"
: "${LUNA_GPUI_FEATURE_SET:?set exact Cargo feature set used by both builds}"
: "${LUNA_GPUI_CONTROL_BINARY:?set full-rebuild GPUI binary path}"
: "${LUNA_GPUI_CONTROL_SHA:?set full-rebuild GPUI binary SHA-256}"
: "${LUNA_GPUI_DIRECT_BINARY:?set direct-port GPUI binary path}"
: "${LUNA_GPUI_DIRECT_SHA:?set direct-port GPUI binary SHA-256}"
: "${LUNA_GPUI_CONTROL_BUILD_MANIFEST:?set immutable control build manifest}"
: "${LUNA_GPUI_DIRECT_BUILD_MANIFEST:?set immutable direct build manifest}"
: "${LUNA_MYGO_SOURCE_TREE:?set pinned MyGo checkout}"
: "${LUNA_MYGO_BINARY:?set pinned MyGo binary path}"
: "${LUNA_MYGO_SHA:?set pinned MyGo binary SHA-256}"
: "${LUNA_NANOUI_SOURCE_TREE:?set pinned NanoUI checkout}"
: "${LUNA_NANOUI_BINARY:?set pinned NanoUI binary path}"
: "${LUNA_NANOUI_SHA:?set pinned NanoUI binary SHA-256}"
: "${LUNA_PEER_BUILD_MANIFEST:?set pinned peer build manifest}"
: "${LUNA_OBSERVER_SHA:?set reviewed observer binary SHA-256}"
[[ "$LUNA_OBSERVER_SHA" == "$OBSERVER_SHA_PIN" ]] || {
  echo 'observer hash differs from the reviewed X11 observer build' >&2; exit 2;
}

[[ "$LUNA_PREFLIGHT_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]
[[ "$LUNA_DISPLAY" =~ ^:[0-9]+(\.[0-9]+)?$ ]]
display_number=${LUNA_DISPLAY#:}
display_number=${display_number%%.*}
[[ -S "/tmp/.X11-unix/X$display_number" ]] || {
  echo "no X11 socket for private display $LUNA_DISPLAY" >&2; exit 2;
}
[[ "$LUNA_GPUI_SOURCE_COMMIT" == "$LUNA_GPUI_EXPECTED_COMMIT" ]]
[[ "$LUNA_GPUI_CONTROL_SHA" != "$LUNA_GPUI_DIRECT_SHA" ]] || {
  echo 'control and direct GPUI binaries are identical' >&2; exit 2;
}
[[ $(sha256sum "$CONTROL_FIXTURE" | cut -d' ' -f1) == "$CONTROL_FIXTURE_PIN" ]]
[[ $(sha256sum "$DIRECT_FIXTURE" | cut -d' ' -f1) == "$DIRECT_FIXTURE_PIN" ]]
[[ $(sha256sum "$BASE/fixtures/mygo-main.go" | cut -d' ' -f1) == "$MYGO_FIXTURE_PIN" ]]
[[ $(sha256sum "$BASE/fixtures/nanoui-main.zig" | cut -d' ' -f1) == "$NANOUI_FIXTURE_PIN" ]]

has_line() { rg -Fxq "$2" "$1" || { echo "missing '$2' in $1" >&2; return 1; }; }
sha_is() {
  local path=$1 expected=$2 actual
  [[ -f "$path" ]] || { echo "missing input $path" >&2; return 1; }
  actual=$(sha256sum "$path" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || { echo "SHA mismatch for $path" >&2; return 1; }
}
only_untracked() {
  local tree=$1 allowed_a=$2 allowed_b=${3:-} item
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == "$allowed_a" || ( -n "$allowed_b" && "$item" == "$allowed_b" ) ]] || {
      echo "unexpected untracked compiled input in $tree: $item" >&2; return 1;
    }
  done < <(git -C "$tree" ls-files --others --exclude-standard)
}
gpui_source_ok() {
  local top item pathspecs=(.cargo/ reactivity/.cargo/ rust-toolchain rust-toolchain.toml rust-toolchain.yaml reactivity/rust-toolchain reactivity/rust-toolchain.toml reactivity/rust-toolchain.yaml reactivity/Cargo.toml reactivity/Cargo.lock reactivity/crates/ reactivity/vendor/)
  top=$(git -C "$LUNA_GPUI_SOURCE_TREE" rev-parse --show-toplevel)
  [[ "$LUNA_GPUI_SOURCE_TREE" == "$top/reactivity" ]]
  [[ $(git -C "$top" rev-parse HEAD) == "$LUNA_GPUI_SOURCE_COMMIT" ]]
  git -C "$top" diff --quiet "$LUNA_GPUI_SOURCE_COMMIT" -- "${pathspecs[@]}"
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == reactivity/crates/gpui/examples/luna_paint_control.rs || \
       "$item" == reactivity/crates/gpui/examples/luna_paint_direct.rs ]] || {
      echo "unexpected ignored GPUI build input: $item" >&2; return 1;
    }
  done < <(git -C "$top" ls-files --others --ignored --exclude-standard -- "${pathspecs[@]}")
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == reactivity/crates/gpui/examples/luna_paint_control.rs || \
       "$item" == reactivity/crates/gpui/examples/luna_paint_direct.rs ]] || {
      echo "unexpected untracked GPUI build input: $item" >&2; return 1;
    }
  done < <(git -C "$top" ls-files --others --exclude-standard -- "${pathspecs[@]}")
  cmp "$CONTROL_FIXTURE" "$LUNA_GPUI_SOURCE_TREE/crates/gpui/examples/luna_paint_control.rs"
  cmp "$DIRECT_FIXTURE" "$LUNA_GPUI_SOURCE_TREE/crates/gpui/examples/luna_paint_direct.rs"
}
gpui_manifest_ok() {
  local manifest=$1 binary=$2 sha=$3 fixture=$4 fixture_sha=$5
  has_line "$manifest" "source_commit=$LUNA_GPUI_SOURCE_COMMIT"
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

gpui_source_ok
gpui_manifest_ok "$LUNA_GPUI_CONTROL_BUILD_MANIFEST" "$LUNA_GPUI_CONTROL_BINARY" \
  "$LUNA_GPUI_CONTROL_SHA" "$CONTROL_FIXTURE" "$CONTROL_FIXTURE_PIN"
gpui_manifest_ok "$LUNA_GPUI_DIRECT_BUILD_MANIFEST" "$LUNA_GPUI_DIRECT_BINARY" \
  "$LUNA_GPUI_DIRECT_SHA" "$DIRECT_FIXTURE" "$DIRECT_FIXTURE_PIN"
sha_is "$LUNA_GPUI_CONTROL_BINARY" "$LUNA_GPUI_CONTROL_SHA"
sha_is "$LUNA_GPUI_DIRECT_BINARY" "$LUNA_GPUI_DIRECT_SHA"
sha_is "$LUNA_MYGO_BINARY" "$LUNA_MYGO_SHA"
sha_is "$LUNA_NANOUI_BINARY" "$LUNA_NANOUI_SHA"
sha_is "$OBSERVER" "$LUNA_OBSERVER_SHA"
sha_is "$FONT" "$FONT_SHA"

[[ $(git -C "$LUNA_MYGO_SOURCE_TREE" rev-parse HEAD) == "$MYGO_COMMIT" ]]
[[ $(git -C "$LUNA_NANOUI_SOURCE_TREE" rev-parse HEAD) == "$NANOUI_COMMIT" ]]
git -C "$LUNA_MYGO_SOURCE_TREE" diff --quiet "$MYGO_COMMIT" --
[[ $(git -C "$LUNA_NANOUI_SOURCE_TREE" diff --name-only "$NANOUI_COMMIT" --) == build.zig ]]
[[ $(git -C "$LUNA_NANOUI_SOURCE_TREE" diff --binary "$NANOUI_COMMIT" -- build.zig | sha256sum | cut -d' ' -f1) == "$NANOUI_PATCH_SHA" ]]
only_untracked "$LUNA_MYGO_SOURCE_TREE" examples/luna-bench/main.go
only_untracked "$LUNA_NANOUI_SOURCE_TREE" examples/luna-bench/main.zig
cmp "$BASE/fixtures/mygo-main.go" "$LUNA_MYGO_SOURCE_TREE/examples/luna-bench/main.go"
cmp "$BASE/fixtures/nanoui-main.zig" "$LUNA_NANOUI_SOURCE_TREE/examples/luna-bench/main.zig"
mygo_fixture_sha=$MYGO_FIXTURE_PIN
nanoui_fixture_sha=$NANOUI_FIXTURE_PIN
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

OUT="$DIR/preflights/$LUNA_PREFLIGHT_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }
mkdir -p "$OUT"
source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY PROFILE=native-default
export LUNA_STARTS=1 LUNA_CLICKS_PER_START=1 LUNA_MEMORY_STARTS=0 LUNA_PREFLIGHT=1
export LUNA_REQUIRE_BINARY_IDENTITY=1
unset LUNA_STAGES LUNA_INTERPRETER LUNA_LIBRARY_PATH LUNA_SCREENSHOT_PATH || true
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}

workloads=('eager 0' 'eager 1000' 'eager 10000' 'virtual 250000')
variants=(gpui-control gpui-direct mygo nanoui)
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  for variant in "${variants[@]}"; do
    case "$variant" in
      gpui-control)
        export APP=gpui LUNA_APP=gpui LUNA_RENDERER=auto
        export LUNA_GPUI_BINARY=$LUNA_GPUI_CONTROL_BINARY LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_CONTROL_SHA
        ;;
      gpui-direct)
        export APP=gpui LUNA_APP=gpui LUNA_RENDERER=auto
        export LUNA_GPUI_BINARY=$LUNA_GPUI_DIRECT_BINARY LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_DIRECT_SHA
        ;;
      mygo)
        export APP=mygo LUNA_APP=mygo LUNA_MYGO_BINARY LUNA_MYGO_EXPECTED_SHA=$LUNA_MYGO_SHA
        unset MYGO_GPU || true
        source "$BASE/prepare-runtime.sh"
        ;;
      nanoui)
        export APP=nanoui LUNA_APP=nanoui LUNA_NANOUI_BINARY LUNA_NANOUI_EXPECTED_SHA=$LUNA_NANOUI_SHA
        source "$BASE/prepare-runtime.sh"
        ;;
    esac
    export MODE=$mode ROWS=$rows LUNA_MODE=$mode LUNA_ROWS=$rows
    export LUNA_SCREENSHOT_PATH="$OUT/$variant-$mode-$rows.ppm"
    echo "PREFLIGHT,$variant,$mode,$rows"
    "$BASE/run-one.sh" >"$OUT/$variant-$mode-$rows.log" 2>&1
  done
done

build_config_sha=$(sha256sum "$LUNA_NANOUI_SOURCE_TREE/build.zig" | cut -d' ' -f1)
for variant in gpui-control gpui-direct; do
  if [[ "$variant" == gpui-control ]]; then
    source_commit=$LUNA_GPUI_SOURCE_COMMIT fixture_sha=$CONTROL_FIXTURE_PIN binary_sha=$LUNA_GPUI_CONTROL_SHA binary_path=$LUNA_GPUI_CONTROL_BINARY
  else
    source_commit=$LUNA_GPUI_SOURCE_COMMIT fixture_sha=$DIRECT_FIXTURE_PIN binary_sha=$LUNA_GPUI_DIRECT_SHA binary_path=$LUNA_GPUI_DIRECT_BINARY
  fi
  {
    echo 'status=awaiting-manual-review'
    echo "source_commit=$source_commit"
    echo "binary_sha256=$binary_sha"
    echo "fixture_sha256=$fixture_sha"
    echo "source_tree=$LUNA_GPUI_SOURCE_TREE"
    echo "cargo_features=$LUNA_GPUI_FEATURE_SET"
    echo "binary=$binary_path"
    echo "workloads=$WORKLOADS"
    echo "checks=$CHECKS"
    echo "preflight_dir=$OUT"
  } > "$OUT/$variant-record.txt"
done
for app in mygo nanoui; do
  if [[ "$app" == mygo ]]; then source_commit=$MYGO_COMMIT fixture_sha=$MYGO_FIXTURE_PIN binary_sha=$LUNA_MYGO_SHA
  else source_commit=$NANOUI_COMMIT fixture_sha=$NANOUI_FIXTURE_PIN binary_sha=$LUNA_NANOUI_SHA; fi
  {
    echo 'status=awaiting-manual-review'
    echo "source_commit=$source_commit"
    echo "binary_sha256=$binary_sha"
    echo "fixture_sha256=$fixture_sha"
    if [[ "$app" == mygo ]]; then
      echo "source_tree=$LUNA_MYGO_SOURCE_TREE"
      echo "binary=$LUNA_MYGO_BINARY"
    else
      echo "source_tree=$LUNA_NANOUI_SOURCE_TREE"
      echo "binary=$LUNA_NANOUI_BINARY"
    fi
    echo "workloads=$WORKLOADS"
    echo "checks=$CHECKS"
    echo "preflight_dir=$OUT"
    if [[ "$app" == nanoui ]]; then echo "build_config_sha256=$build_config_sha"; fi
  } > "$OUT/$app-record.txt"
done
{
  echo 'status=awaiting-manual-review'
  echo "preflight_id=$LUNA_PREFLIGHT_ID"
  echo "display=$LUNA_DISPLAY"
  echo 'workloads=eager-0,eager-1000,eager-10000,virtual-250000'
  echo 'variants=gpui-control,gpui-direct,mygo,nanoui'
  echo 'one fresh process, one click, exact pixel screenshot per variant/workload; all times excluded'
  echo "gpui_source_commit=$LUNA_GPUI_SOURCE_COMMIT"
  echo "gpui_source_tree=$LUNA_GPUI_SOURCE_TREE"
  echo "gpui_control_binary=$LUNA_GPUI_CONTROL_BINARY"
  echo "gpui_control_sha256=$LUNA_GPUI_CONTROL_SHA"
  echo "gpui_direct_binary=$LUNA_GPUI_DIRECT_BINARY"
  echo "gpui_direct_sha256=$LUNA_GPUI_DIRECT_SHA"
  echo "gpui_control_build_manifest=$LUNA_GPUI_CONTROL_BUILD_MANIFEST"
  echo "gpui_control_build_manifest_sha256=$(sha256sum "$LUNA_GPUI_CONTROL_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "gpui_direct_build_manifest=$LUNA_GPUI_DIRECT_BUILD_MANIFEST"
  echo "gpui_direct_build_manifest_sha256=$(sha256sum "$LUNA_GPUI_DIRECT_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "mygo_binary=$LUNA_MYGO_BINARY"
  echo "mygo_sha256=$LUNA_MYGO_SHA"
  echo "nanoui_binary=$LUNA_NANOUI_BINARY"
  echo "nanoui_sha256=$LUNA_NANOUI_SHA"
  echo "peer_build_manifest=$LUNA_PEER_BUILD_MANIFEST"
  echo "peer_build_manifest_sha256=$(sha256sum "$LUNA_PEER_BUILD_MANIFEST" | cut -d' ' -f1)"
  echo "gpui_feature_set=$LUNA_GPUI_FEATURE_SET"
  echo "observer_sha256=$LUNA_OBSERVER_SHA"
  echo "peer_font_sha256=$FONT_SHA"
  echo "evidence_dir=$OUT"
} > "$OUT/record.txt"
(cd "$OUT" && sha256sum ./*.log ./*.ppm ./*-record.txt record.txt > sha256.txt)
echo "preflight evidence ready for manual review: $OUT"
