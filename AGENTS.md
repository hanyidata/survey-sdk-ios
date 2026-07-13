# Repository Guidelines

## Project Structure & Module Organization

This repository contains an iOS CocoaPods SDK. Main Swift sources live in `surveySDK/Classes/`, including the WebView survey UI, popup dialog, service, crypto, and utility code. Bundled web assets live in `surveySDK/Assets/`; `index.html`, `version.json`, and `static/` must stay in sync when replacing the embedded H5 build. The sample app and workspace are under `Example/`, with template tests in `Example/Tests/`. The podspec is `HYSurveySDK.podspec`; release tags are plain semantic versions such as `0.4.37`.

## Build, Test, and Development Commands

Run CocoaPods from the sample project when dependencies need refreshing:

```sh
cd Example
pod install
open surveySDK.xcworkspace
```

Build the example app from Xcode, or use:

```sh
xcodebuild -workspace Example/surveySDK.xcworkspace -scheme surveySdk-Example -configuration Debug build
```

Run tests with:

```sh
xcodebuild test -workspace Example/surveySDK.xcworkspace -scheme surveySdk-Example -destination 'platform=iOS Simulator,name=iPhone 15'
```

Validate the podspec before publishing:

```sh
pod lib lint HYSurveySDK.podspec
```

Prepare and validate releases with the project skill:

```sh
.agents/skills/release-ios-sdk/scripts/prepare-release.sh 0.4.39 \
  --changelog-entry "User-facing change"
```

## Coding Style & Naming Conventions

Use Swift for SDK code and Objective-C only where the sample app already does. Match existing style: 4-space indentation, UIKit/WebKit APIs, `HY` prefixes for public SDK types, and camelCase for methods and properties. Keep public Objective-C bridge methods annotated with `@objc` when they are part of the SDK surface. Avoid broad refactors in generated web assets; replace them only as a complete H5 build.

## Testing Guidelines

Tests use XCTest in `Example/Tests/`. Add focused tests for Swift utility or service behavior when changing shared logic. Name tests with the `test...` pattern, for example `testParsePxHandlesPercentValues`. For UI/WebView behavior, verify manually in the example app and document the tested device or simulator in the PR.

## Commit & Pull Request Guidelines

Git history uses short, direct commit subjects such as `bump 0.4.37`, `fix padding issue`, and `add onclose`. Keep commits similarly concise and scoped. PRs should include the SDK behavior changed, affected integration path, manual test notes, and screenshots or screen recordings for popup or embedded survey UI changes.

## Version, Changelog & Release Rules

For every release, keep `HYSurveySDK.podspec`, `version.txt`, `surveySDK/Assets/version.json`, generated H5 filenames, `CHANGE.MD`, and the Git tag on exactly the same plain semantic version. Changelog entries are mandatory: collect confirmed user-facing changes before preparation, and stop to ask the user when none are available.

Use `.agents/skills/release-ios-sdk/SKILL.md` for the guarded prepare, validate, source-sync, lint, and publish workflow. Preparation must not tag or push. Require clean iOS and UI worktrees, complete H5 asset replacement, a successful sample build, and `pod lib lint` before publication unless the user explicitly accepts skipping lint.

The podspec source points to Gitee while `origin` points to GitHub. Before tagging, require the final iOS release commit on the `develop` branch of both repositories. Publish and verify the same immutable tag on both remotes; a GitHub-only tag does not satisfy the CocoaPods source contract. Never move or force-push a release tag.

Preserve all existing user changes. Do not reset, stash, or discard a dirty worktree automatically. Never store remote credentials in the repository or print them in release logs.
