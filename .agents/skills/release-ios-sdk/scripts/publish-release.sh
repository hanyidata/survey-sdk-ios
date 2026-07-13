#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
UI_DIR="$IOS_DIR/../survey-ui-next-uni2"
PRIMARY_REMOTE="origin"
BRANCH="develop"
UI_BRANCH="feature/app"
CONFIRM=""
SKIP_POD_LINT=false
CONFIRM_SKIP=""

usage() {
  echo "Usage: $0 <version> --confirm-publish <version> [--ui-dir PATH] [--branch NAME] [--ui-branch NAME] [--primary-remote NAME] [--source-remote URL_OR_NAME] [--skip-pod-lint --confirm-skip-pod-lint <version>]" >&2
}

[[ $# -ge 1 ]] || { usage; exit 2; }
VERSION="$1"
shift
SOURCE_REMOTE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --confirm-publish) CONFIRM="$2"; shift 2 ;;
    --ui-dir) UI_DIR="$2"; shift 2 ;;
    --primary-remote) PRIMARY_REMOTE="$2"; shift 2 ;;
    --source-remote) SOURCE_REMOTE="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --ui-branch) UI_BRANCH="$2"; shift 2 ;;
    --skip-pod-lint) SKIP_POD_LINT=true; shift ;;
    --confirm-skip-pod-lint) CONFIRM_SKIP="$2"; shift 2 ;;
    *) usage; exit 2 ;;
  esac
done
[[ "$CONFIRM" == "$VERSION" ]] || {
  echo "Refusing publication without --confirm-publish $VERSION" >&2
  exit 1
}
if [[ "$SKIP_POD_LINT" == true && "$CONFIRM_SKIP" != "$VERSION" ]]; then
  echo "Refusing to skip pod lint without --confirm-skip-pod-lint $VERSION" >&2
  exit 1
fi
UI_DIR="$(cd "$UI_DIR" && pwd)"
if [[ -z "$SOURCE_REMOTE" ]]; then
  SOURCE_REMOTE="$(ruby -e 'text=File.read(ARGV[0]); puts text[/:git\s*=>\s*["'\'']([^"'\'']+)["'\'']/, 1]' "$IOS_DIR/HYSurveySDK.podspec")"
fi
[[ -n "$SOURCE_REMOTE" ]] || { echo "Podspec source Git URL is missing" >&2; exit 1; }

declare -a REPOS=("$IOS_DIR" "$UI_DIR")
declare -a BRANCHES=("$BRANCH" "$UI_BRANCH")
declare -a LABELS=("iOS" "UI")
for index in "${!REPOS[@]}"; do
  repo="${REPOS[$index]}"
  expected_branch="${BRANCHES[$index]}"
  label="${LABELS[$index]}"
  actual_branch="$(git -C "$repo" branch --show-current)"
  [[ "$actual_branch" == "$expected_branch" ]] || {
    echo "$label branch is '$actual_branch', expected '$expected_branch'" >&2
    exit 1
  }
  if [[ -n "$(git -C "$repo" status --porcelain)" ]]; then
    echo "Release worktree is not clean: $repo" >&2
    git -C "$repo" status --short >&2
    exit 1
  fi
  upstream="$(git -C "$repo" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || true)"
  [[ -n "$upstream" ]] || { echo "No upstream configured for $repo" >&2; exit 1; }
  git -C "$repo" fetch --quiet
  [[ "$(git -C "$repo" rev-parse HEAD)" == "$(git -C "$repo" rev-parse '@{upstream}')" ]] || {
    echo "HEAD is not identical to upstream in $repo" >&2
    exit 1
  }
done

python3 "$SCRIPT_DIR/validate_release.py" \
  --version "$VERSION" \
  --ios-dir "$IOS_DIR" \
  --ui-dir "$UI_DIR" \
  --primary-remote "$PRIMARY_REMOTE" \
  --source-remote "$SOURCE_REMOTE" \
  --branch "$BRANCH" \
  --tag-state absent \
  --check-remotes \
  --require-remote-heads

xcodebuild \
  -workspace "$IOS_DIR/Example/surveySDK.xcworkspace" \
  -scheme surveySdk-Example \
  -configuration Debug \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$IOS_DIR/build/release-validation" \
  CODE_SIGNING_ALLOWED=NO \
  build

if [[ "$SKIP_POD_LINT" == false ]]; then
  command -v pod >/dev/null 2>&1 || {
    echo "CocoaPods is required for release lint. Install pod or obtain explicit approval to skip." >&2
    exit 1
  }
  (cd "$IOS_DIR" && pod lib lint HYSurveySDK.podspec --allow-warnings)
fi

IOS_SHA="$(git -C "$IOS_DIR" rev-parse HEAD)"
git -C "$IOS_DIR" tag -a "$VERSION" -m "Release $VERSION" "$IOS_SHA"

git -C "$IOS_DIR" push "$SOURCE_REMOTE" "refs/tags/$VERSION"
if [[ "$SOURCE_REMOTE" != "$PRIMARY_REMOTE" ]]; then
  git -C "$IOS_DIR" push "$PRIMARY_REMOTE" "refs/tags/$VERSION"
fi

python3 "$SCRIPT_DIR/validate_release.py" \
  --version "$VERSION" \
  --ios-dir "$IOS_DIR" \
  --ui-dir "$UI_DIR" \
  --primary-remote "$PRIMARY_REMOTE" \
  --source-remote "$SOURCE_REMOTE" \
  --branch "$BRANCH" \
  --tag-state head \
  --check-remotes \
  --require-remote-heads

echo "Release $VERSION published to both Git remotes and tagged at iOS commit $IOS_SHA"
