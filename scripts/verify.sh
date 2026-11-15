#!/usr/bin/env bash
# Verifies the package the same way locally and on CI:
# formats the code, fails if that left uncommitted changes, then runs the tests.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v mise >/dev/null 2>&1; then
  echo "❌ mise is not installed or not on PATH. Install it (https://mise.jdx.dev) and run \`mise install\`." >&2
  exit 1
fi
mise install --quiet

echo "🎨 Formatting"
mise exec -- swiftformat --quiet .
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ Formatting or other changes left the working tree dirty:" >&2
  git status --porcelain >&2
  exit 1
fi

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 18 Pro,OS=27.2}"

# Snapshots render in a window scene, so the tests run hosted in the TestHost app
echo "🏗️ Generating test host"
(cd TestHost && mise exec -- tuist generate --no-open)

echo "✅ Testing on ${DESTINATION}"
rm -rf .build/TestResults.xcresult
xcodebuild test \
  -workspace TestHost/StillebenTestHost.xcworkspace \
  -scheme StillebenTests \
  -destination "$DESTINATION" \
  -resultBundlePath .build/TestResults.xcresult \
  | mise exec -- xcbeautify
