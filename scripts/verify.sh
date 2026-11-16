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
rm -rf .build/TestResults.xcresult

echo "🏗️ Generating the test host project"
(cd TestHost && mise exec -- xcodegen --quiet)

# The Stilleben test plan runs the package tests (unhosted) and the hosted tests in the TestHost app
echo "✅ Tests on ${DESTINATION}"
xcodebuild test \
  -project TestHost/TestHost.xcodeproj \
  -scheme TestHost \
  -testPlan Stilleben \
  -destination "$DESTINATION" \
  -resultBundlePath .build/TestResults.xcresult \
  | mise exec -- xcbeautify
