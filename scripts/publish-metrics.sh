#!/usr/bin/env bash
# Publishes the metrics written by verify.sh (.build/metrics/*.json) to the orphan `metrics` branch, which only
# holds those files. The README badges read them through shields.io. Each run replaces the branch with one commit.
set -euo pipefail
cd "$(dirname "$0")/.."
REPOSITORY="$PWD"

REMOTE="${REMOTE:-origin}"
SOURCE_COMMIT="$(git rev-parse --short HEAD)"
WORKTREE="$(mktemp -d)"
BRANCH="metrics-publish-$$"
trap 'git -C "$REPOSITORY" worktree remove --force "$WORKTREE"; git -C "$REPOSITORY" branch -D "$BRANCH" >/dev/null 2>&1 || true' EXIT

git worktree add --quiet --detach "$WORKTREE"
cp .build/metrics/*.json "$WORKTREE/"
cd "$WORKTREE"
git switch --quiet --orphan "$BRANCH"
git add ./*.json
git -c user.name="github-actions[bot]" -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit --quiet -m "📊 Metrics for ${SOURCE_COMMIT}"
git push --quiet --force "$REMOTE" "$BRANCH:metrics"
echo "📊 Published $(ls ./*.json | tr '\n' ' ')to ${REMOTE}/metrics"
