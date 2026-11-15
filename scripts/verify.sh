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

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=latest}"
echo "✅ Testing on ${DESTINATION}"
rm -rf .build/TestResults.xcresult
set -o pipefail
xcodebuild test \
  -scheme Stilleben \
  -destination "$DESTINATION" \
  -resultBundlePath .build/TestResults.xcresult \
  | mise exec -- xcbeautify
