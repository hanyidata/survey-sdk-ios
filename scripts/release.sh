#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/release.sh VERSION [options]

Options:
  --remote NAME          Git remote to push the current branch and tag. Default: origin
  --branch NAME          Branch to push. Default: current branch
  --no-push              Commit and tag locally, but do not push
  --skip-lint            Skip pod lib lint even when CocoaPods is installed
  --require-lint         Fail if CocoaPods is missing or pod lib lint fails
  -h, --help             Show this help

The script always asks you to type VERSION again before changing files,
committing, tagging, or pushing.
USAGE
}

die() {
  echo "error: $*" >&2
  exit 1
}

VERSION=""
REMOTE="origin"
BRANCH=""
PUSH=true
SKIP_LINT=false
REQUIRE_LINT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote)
      [[ $# -ge 2 ]] || die "--remote requires a value"
      REMOTE="$2"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || die "--branch requires a value"
      BRANCH="$2"
      shift 2
      ;;
    --no-push)
      PUSH=false
      shift
      ;;
    --skip-lint)
      SKIP_LINT=true
      shift
      ;;
    --require-lint)
      REQUIRE_LINT=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      [[ -z "$VERSION" ]] || die "only one VERSION argument is allowed"
      VERSION="$1"
      shift
      ;;
  esac
done

[[ -n "$VERSION" ]] || {
  read -r -p "Release version: " VERSION
}

[[ "$VERSION" =~ ^[0-9]+(\.[0-9]+){2}([-.][0-9A-Za-z]+)?$ ]] || die "invalid version: $VERSION"

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

PODSPEC="HYSurveySDK.podspec"
VERSION_TXT="version.txt"
ASSET_VERSION="surveySDK/Assets/version.json"

[[ -f "$PODSPEC" ]] || die "missing $PODSPEC"
[[ -f "$ASSET_VERSION" ]] || die "missing $ASSET_VERSION"

if [[ -z "$BRANCH" ]]; then
  BRANCH="$(git branch --show-current)"
fi
[[ -n "$BRANCH" ]] || die "cannot determine current branch; pass --branch"

LOCAL_TAG_EXISTS=false
REMOTE_TAG_EXISTS=false
git rev-parse -q --verify "refs/tags/$VERSION" >/dev/null && LOCAL_TAG_EXISTS=true
git ls-remote --exit-code --tags "$REMOTE" "refs/tags/$VERSION" >/dev/null 2>&1 && REMOTE_TAG_EXISTS=true

if [[ "$LOCAL_TAG_EXISTS" == true || "$REMOTE_TAG_EXISTS" == true ]]; then
  die "tag $VERSION already exists locally or on $REMOTE"
fi

CURRENT_PODSPEC_VERSION="$(ruby -e 'text=File.read(ARGV[0]); puts text[/s\.version\s*=\s*["'\'']([^"'\'']+)["'\'']/, 1] || "unknown"' "$PODSPEC")"
CURRENT_ASSET_VERSION="$(ruby -rjson -e 'puts JSON.parse(File.read(ARGV[0]))["version"] rescue puts "unknown"' "$ASSET_VERSION")"
CURRENT_TEXT_VERSION="missing"
[[ -f "$VERSION_TXT" ]] && CURRENT_TEXT_VERSION="$(tr -d '\n\r' < "$VERSION_TXT")"
SOURCE_GIT_URL="$(ruby -e 'text=File.read(ARGV[0]); puts text[/:git\s*=>\s*["'\'']([^"'\'']+)["'\'']/, 1].to_s' "$PODSPEC")"

echo
echo "Release preflight"
echo "  target version:        $VERSION"
echo "  current branch:        $BRANCH"
echo "  push remote:           $REMOTE"
echo "  podspec version:       $CURRENT_PODSPEC_VERSION"
echo "  asset version:         $CURRENT_ASSET_VERSION"
echo "  version.txt:           $CURRENT_TEXT_VERSION"
echo "  podspec source git:    ${SOURCE_GIT_URL:-not found}"
echo "  push enabled:          $PUSH"
echo "  source repo sync:      manual"
echo
echo "Current git status:"
git status --short
echo

read -r -p "Type $VERSION to confirm release: " CONFIRM
[[ "$CONFIRM" == "$VERSION" ]] || die "confirmation did not match version"

ruby - "$VERSION" "$PODSPEC" "$VERSION_TXT" "$ASSET_VERSION" <<'RUBY'
version, podspec, version_txt, asset_version = ARGV

podspec_text = File.read(podspec)
unless podspec_text.sub!(/s\.version\s*=\s*['"][^'"]+['"]/, "s.version          = '#{version}'")
  abort "could not update #{podspec}"
end
File.write(podspec, podspec_text)

File.write(version_txt, "#{version}\n")

asset_text = File.read(asset_version)
now = Time.now.strftime("%-m/%-d/%Y, %-l:%M:%S %p").strip
unless asset_text.sub!(/"version":\s*"[^"]+"/, %("version":  "#{version}"))
  abort "could not update version in #{asset_version}"
end
asset_text.sub!(/"build":\s*"[^"]+"/, %("build":    "#{now}"))
File.write(asset_version, asset_text)
RUBY

if [[ ! -f "surveySDK/Assets/static/js/index_${VERSION}.js" ]]; then
  echo "warning: surveySDK/Assets/static/js/index_${VERSION}.js was not found"
  echo "         make sure the embedded H5 assets match the release you intend to ship"
fi

if [[ "$SKIP_LINT" == false ]]; then
  if command -v pod >/dev/null 2>&1; then
    pod lib lint "$PODSPEC"
  elif [[ "$REQUIRE_LINT" == true ]]; then
    die "CocoaPods is not installed, cannot run pod lib lint"
  else
    echo "warning: CocoaPods is not installed; skipping pod lib lint"
  fi
fi

git add "$PODSPEC" "$VERSION_TXT" surveySDK/Assets

if git diff --cached --quiet; then
  echo "No staged release changes; tagging current HEAD."
else
  git commit -m "bump $VERSION"
fi

git tag "$VERSION"

if [[ "$PUSH" == true ]]; then
  git push "$REMOTE" "$BRANCH"
  git push "$REMOTE" "$VERSION"
fi

echo "Release $VERSION complete."
