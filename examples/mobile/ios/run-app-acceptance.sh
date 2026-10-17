#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "$0")/../../.." && pwd)"
simulator_udid="${IOS_SIMULATOR_UDID:-}"
if [[ -z "$simulator_udid" ]]; then
  echo "Set IOS_SIMULATOR_UDID to an iPhone Simulator UUID." >&2
  exit 2
fi

artifact_root="${IOS_ACCEPTANCE_ARTIFACTS:-$repository_root/target/ios-app-acceptance}"
if [[ "$artifact_root" != /* ]]; then
  echo "IOS_ACCEPTANCE_ARTIFACTS must be an absolute path." >&2
  exit 2
fi
mkdir -p "$artifact_root"
run_directory="$(mktemp -d "$artifact_root/run.XXXXXX")"
project="$repository_root/examples/mobile/ios/AcceptanceTests/GPUIAcceptanceUITests.xcodeproj"
result_bundle="$run_directory/GPUIAcceptance.xcresult"

if ! command -v xcodebuild >/dev/null 2>&1 || ! command -v xcrun >/dev/null 2>&1; then
  echo "Xcode and its command-line tools are required; this runner must execute on macOS." >&2
  exit 2
fi
if [[ ! -d "$project" ]]; then
  echo "Xcode project not found: $project" >&2
  exit 2
fi

printf 'Running the Rust GPUI acceptance app on simulator %s.\n' "$simulator_udid"
printf 'Enable Chinese (Simplified) Pinyin in Simulator Settings for the IME composition test.\n'
printf 'Artifacts: %s\n' "$run_directory"

set +e
MOBILE_REPO_ROOT="$repository_root" xcodebuild test \
  -project "$project" \
  -scheme GPUIAcceptance \
  -destination "platform=iOS Simulator,id=$simulator_udid" \
  -derivedDataPath "$run_directory/DerivedData" \
  -resultBundlePath "$result_bundle" \
  -parallel-testing-enabled NO \
  2>&1 | tee "$run_directory/xcodebuild.log"
status=${PIPESTATUS[0]}
set -e

if [[ "$status" -ne 0 ]]; then
  echo "XCUITest failed with status $status; see $run_directory/xcodebuild.log and GPUIAcceptance.xcresult." >&2
  exit "$status"
fi
printf 'iOS app acceptance passed. Result bundle: %s\n' "$result_bundle"
