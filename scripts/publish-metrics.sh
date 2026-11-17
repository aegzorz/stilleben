#!/usr/bin/env bash
# Publishes the metrics written by verify.sh (.build/metrics/*.json) to the orphan `metrics` branch, which only
# holds those files. The README badges read them through shields.io. Each run replaces the branch with one commit,
# built directly from the files, without checking anything out.
set -euo pipefail
cd "$(dirname "$0")/.."

SOURCE_COMMIT="$(git rev-parse --short HEAD)"
tree="$(for file in .build/metrics/*.json; do
  printf '100644 blob %s\t%s\n' "$(git hash-object -w "$file")" "$(basename "$file")"
done | git mktree)"
commit="$(git -c user.name="github-actions[bot]" -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit-tree "$tree" -m "📊 Metrics for ${SOURCE_COMMIT}")"
git push --quiet --force "${REMOTE:-origin}" "$commit:refs/heads/metrics"
echo "📊 Published $(cd .build/metrics && ls ./*.json | tr '\n' ' ')to ${REMOTE:-origin}/metrics"
