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

## Coding Style & Naming Conventions

Use Swift for SDK code and Objective-C only where the sample app already does. Match existing style: 4-space indentation, UIKit/WebKit APIs, `HY` prefixes for public SDK types, and camelCase for methods and properties. Keep public Objective-C bridge methods annotated with `@objc` when they are part of the SDK surface. Avoid broad refactors in generated web assets; replace them only as a complete H5 build.

## Testing Guidelines

Tests use XCTest in `Example/Tests/`. Add focused tests for Swift utility or service behavior when changing shared logic. Name tests with the `test...` pattern, for example `testParsePxHandlesPercentValues`. For UI/WebView behavior, verify manually in the example app and document the tested device or simulator in the PR.

## Commit & Pull Request Guidelines

Git history uses short, direct commit subjects such as `bump 0.4.37`, `fix padding issue`, and `add onclose`. Keep commits similarly concise and scoped. PRs should include the SDK behavior changed, affected integration path, manual test notes, and screenshots or screen recordings for popup or embedded survey UI changes.

## Release Notes

For a release, update `HYSurveySDK.podspec` `s.version`, ensure `surveySDK/Assets/version.json` and H5 filenames are intentional, commit the changes, then tag the final commit with the same version:

```sh
git tag 0.4.38
git push origin develop --tags
```

The podspec source points to Gitee and resolves `:tag => s.version`, so publish the same tag to every remote used by consumers.
