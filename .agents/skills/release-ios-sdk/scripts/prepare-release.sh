#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
UI_DIR="$IOS_DIR/../survey-ui-next-uni2"
IOS_BRANCH="develop"
UI_BRANCH="feature/app"
PRIMARY_REMOTE="origin"
CHANGELOG_ENTRIES=()

usage() {
  echo "Usage: $0 <version> --changelog-entry TEXT [--changelog-entry TEXT ...] [--ui-dir PATH] [--ios-branch NAME] [--ui-branch NAME]" >&2
}

[[ $# -ge 1 ]] || { usage; exit 2; }
VERSION="$1"
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --changelog-entry) CHANGELOG_ENTRIES+=("$2"); shift 2 ;;
    --ui-dir) UI_DIR="$2"; shift 2 ;;
    --ios-branch) IOS_BRANCH="$2"; shift 2 ;;
    --ui-branch) UI_BRANCH="$2"; shift 2 ;;
    --primary-remote) PRIMARY_REMOTE="$2"; shift 2 ;;
    *) usage; exit 2 ;;
  esac
done

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
  echo "Release version must be plain semantic version, for example 0.4.39" >&2
  exit 1
}
[[ ${#CHANGELOG_ENTRIES[@]} -gt 0 ]] || {
  echo "At least one confirmed --changelog-entry is required. Ask the user for release notes." >&2
  exit 1
}
UI_DIR="$(cd "$UI_DIR" && pwd)"

for command in git node npm python3 rsync ruby xcodebuild; do
  command -v "$command" >/dev/null 2>&1 || { echo "Missing command: $command" >&2; exit 1; }
done

require_clean_branch() {
  local repo="$1" expected="$2" label="$3" actual
  actual="$(git -C "$repo" branch --show-current)"
  [[ "$actual" == "$expected" ]] || {
    echo "$label branch is '$actual', expected '$expected'" >&2
    exit 1
  }
  if [[ -n "$(git -C "$repo" status --porcelain)" ]]; then
    echo "$label worktree is not clean:" >&2
    git -C "$repo" status --short >&2
    exit 1
  fi
}

require_clean_branch "$IOS_DIR" "$IOS_BRANCH" "iOS"
require_clean_branch "$UI_DIR" "$UI_BRANCH" "UI"

CURRENT_VERSION="$(ruby -e 'text=File.read(ARGV[0]); puts text[/s\.version\s*=\s*["'\'']([^"'\'']+)["'\'']/, 1]' "$IOS_DIR/HYSurveySDK.podspec")"
UI_VERSION="$(node -p "require('$UI_DIR/package.json').version")"
python3 - "$CURRENT_VERSION" "$UI_VERSION" "$VERSION" <<'PY'
import sys
current, ui, requested = (tuple(map(int, value.split('.'))) for value in sys.argv[1:])
if requested <= current:
    raise SystemExit(f"new iOS version {sys.argv[3]} must be greater than current version {sys.argv[1]}")
if ui > requested:
    raise SystemExit(f"UI version {sys.argv[2]} is newer than requested iOS version {sys.argv[3]}")
PY

SOURCE_URL="$(ruby -e 'text=File.read(ARGV[0]); puts text[/:git\s*=>\s*["'\'']([^"'\'']+)["'\'']/, 1]' "$IOS_DIR/HYSurveySDK.podspec")"
[[ -n "$SOURCE_URL" ]] || { echo "Podspec source Git URL is missing" >&2; exit 1; }

check_absent_remote_tag() {
  local remote="$1" label="$2" rc
  set +e
  git -C "$IOS_DIR" ls-remote --exit-code --tags "$remote" "refs/tags/$VERSION" >/dev/null 2>&1
  rc=$?
  set -e
  case "$rc" in
    0) echo "$label tag already exists: $VERSION" >&2; exit 1 ;;
    2) ;;
    *) echo "Could not inspect $label for tag $VERSION" >&2; exit "$rc" ;;
  esac
}

git -C "$IOS_DIR" rev-parse -q --verify "refs/tags/$VERSION" >/dev/null && {
  echo "Local tag already exists: $VERSION" >&2
  exit 1
}
check_absent_remote_tag "$PRIMARY_REMOTE" "primary remote"
if [[ "$SOURCE_URL" != "$PRIMARY_REMOTE" ]]; then
  check_absent_remote_tag "$SOURCE_URL" "podspec source remote"
fi

echo "Preparing Survey iOS SDK $VERSION"
echo "UI source: $(git -C "$UI_DIR" rev-parse HEAD)"
echo "Podspec source: $SOURCE_URL"

(cd "$UI_DIR" && npm ci)
if [[ "$UI_VERSION" != "$VERSION" ]]; then
  (cd "$UI_DIR" && npm version "$VERSION" --no-git-tag-version)
fi
(cd "$UI_DIR" && npm run build:appsdk)

python3 - "$UI_DIR/dist/build/app/version.json" "$UI_DIR/package.json" <<'PY'
import json
import sys
metadata_path, package_path = sys.argv[1:]
with open(metadata_path) as fh:
    metadata = json.load(fh)
with open(package_path) as fh:
    package = json.load(fh)
metadata["core"] = package.get("dependencies", {}).get("@hanyi/survey-core-next", "")
with open(metadata_path, "w") as fh:
    json.dump(metadata, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY

rsync -a --delete "$UI_DIR/dist/build/app/" "$IOS_DIR/surveySDK/Assets/"

python3 - "$IOS_DIR/HYSurveySDK.podspec" "$IOS_DIR/version.txt" "$IOS_DIR/CHANGE.MD" "$VERSION" "${CHANGELOG_ENTRIES[@]}" <<'PY'
import re
import sys
podspec_path, version_path, changelog_path, version, *entries = sys.argv[1:]
with open(podspec_path) as fh:
    podspec = fh.read()
podspec, count = re.subn(
    r"(?m)^(\s*s\.version\s*=\s*)['\"][^'\"]+['\"]",
    rf"\g<1>'{version}'",
    podspec,
)
if count != 1:
    raise SystemExit("expected exactly one podspec version")
with open(podspec_path, "w") as fh:
    fh.write(podspec)
with open(version_path, "w") as fh:
    fh.write(version + "\n")
with open(changelog_path) as fh:
    changelog = fh.read()
if re.search(rf"(?m)^# Version {re.escape(version)}\s*$", changelog):
    raise SystemExit(f"changelog already contains Version {version}")
section = f"# Version {version}\n" + "".join(f" - {entry}\n" for entry in entries) + "\n"
with open(changelog_path, "w") as fh:
    fh.write(section + changelog)
PY

xcodebuild \
  -workspace "$IOS_DIR/Example/surveySDK.xcworkspace" \
  -scheme surveySdk-Example \
  -configuration Debug \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$IOS_DIR/build/release-validation" \
  CODE_SIGNING_ALLOWED=NO \
  build

python3 "$SCRIPT_DIR/validate_release.py" \
  --version "$VERSION" \
  --ios-dir "$IOS_DIR" \
  --ui-dir "$UI_DIR" \
  --primary-remote "$PRIMARY_REMOTE" \
  --source-remote "$SOURCE_URL" \
  --branch "$IOS_BRANCH" \
  --tag-state absent \
  --check-remotes

echo
echo "Preparation completed. Review and commit both repositories; nothing was pushed or tagged."
git -C "$UI_DIR" status --short
git -C "$IOS_DIR" status --short
