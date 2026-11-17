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

echo "📊 Code coverage"
xcrun xccov view --report --only-targets .build/TestResults.xcresult

# Coverage of the library's sources as a shields.io endpoint, published to the metrics branch by CI. Files are
# matched by path, because xccov lists the library under its own target or under the test bundles it's linked into.
mkdir -p .build/metrics
xcrun xccov view --report --json .build/TestResults.xcresult | python3 -c '
import json, sys
files = {}
for target in json.load(sys.stdin)["targets"]:
    for file in target["files"]:
        if "/Sources/Stilleben/" in file["path"]:
            # A file listed under several targets counts once, with its best coverage
            if file["path"] not in files or file["coveredLines"] > files[file["path"]]["coveredLines"]:
                files[file["path"]] = file
if not files:
    sys.exit("No coverage found for Sources/Stilleben")
percent = 100 * sum(f["coveredLines"] for f in files.values()) / sum(f["executableLines"] for f in files.values())
print(f"Stilleben sources: {percent:.2f}% of {len(files)} files", file=sys.stderr)
color = next(c for limit, c in [(90, "brightgreen"), (80, "green"), (70, "yellowgreen"), (60, "yellow"), (0, "red")] if percent >= limit)
print(json.dumps({"schemaVersion": 1, "label": "coverage", "message": f"{percent:.1f}%", "color": color}))
' > .build/metrics/coverage.json
cat .build/metrics/coverage.json
