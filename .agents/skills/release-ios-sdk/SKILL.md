---
name: release-ios-sdk
description: Prepare, validate, and publish the Survey iOS CocoaPods SDK whose WebView assets are built from the sibling survey-ui-next-uni2 repository. Use when creating an iOS SDK release, synchronizing the embedded H5 bundle, updating HYSurveySDK.podspec and version.txt, maintaining release changelog entries, validating Git source/tag consistency, or diagnosing an incomplete Git-tag-based CocoaPods release.
---

# Release iOS SDK

Release the iOS SDK as one immutable Git source unit. Make the podspec version, `version.txt`, embedded Web version, JavaScript filenames, changelog section, and Git tag identical.

## Repositories and release targets

- Treat the current repository as the iOS repository and `../survey-ui-next-uni2` as the default UI repository.
- Use `develop` for iOS and `feature/app` for UI unless the user approves different branches.
- Use plain semantic versions such as `0.4.39`; tag without a leading `v`.
- Treat GitHub `origin` as the primary development remote.
- Read the CocoaPods source remote from `HYSurveySDK.podspec`. It currently points to Gitee and may differ from `origin`.
- Publish the exact same release commit and tag to both the primary and podspec source remotes. A GitHub-only tag is not a complete CocoaPods release when the podspec source points to Gitee.
- Do not run `pod trunk push`; this repository publishes through the podspec's Git source/tag, not the public CocoaPods trunk.

## Safety and changelog gates

Separate preparation from publication.

1. Require both worktrees to be clean before preparation. Preserve and report user changes; never reset or stash them automatically.
2. Collect confirmed user-facing changelog entries before preparation. If none are available, stop and ask the user.
3. Prepare and validate locally without committing, pushing, or tagging.
4. Show the version, changelog, UI commit, iOS release commit/diff, podspec source, both remote targets, and planned tag.
5. Obtain explicit confirmation before source-branch synchronization when it was not already authorized.
6. Require both remotes' release branches to point to the final iOS commit before tagging.
7. Obtain explicit final confirmation before creating or pushing the immutable tag.

## Prepare a release

Run from the iOS repository root:

```bash
.agents/skills/release-ios-sdk/scripts/prepare-release.sh <version> \
  --changelog-entry "First user-facing change" \
  --changelog-entry "Second user-facing change"
```

The preparation script:

1. Checks tools, branches, clean worktrees, semantic version ordering, and tag absence on both remotes.
2. Runs `npm ci` in the UI repository.
3. Updates the UI package/lockfile only when their version is below the requested iOS version. Reuses an already matching UI version without rewriting it.
4. Builds `dist/build/app`, records the survey core version, and mirrors the complete output into `surveySDK/Assets` with stale files deleted.
5. Updates `HYSurveySDK.podspec`, `version.txt`, and `CHANGE.MD`.
6. Builds the sample app for a generic iOS destination with code signing disabled.
7. Runs deterministic release validation.

Use `--ui-dir`, `--ios-branch`, or `--ui-branch` only when the approved layout differs. Do not skip the sample build for a real release.

After preparation, review and commit UI version changes in the UI repository when present. Commit the podspec, version, changelog, generated assets, and approved native changes together as the iOS release commit. Do not tag yet.

## Validate without publishing

```bash
python3 .agents/skills/release-ios-sdk/scripts/validate_release.py \
  --version <version> \
  --tag-state absent \
  --check-remotes
```

Validation proves:

- podspec, `version.txt`, UI package/lockfile, embedded Web metadata, and JavaScript filenames match;
- the changelog has a non-empty section for the release;
- `index.html` references only files that exist;
- the podspec Git source is known;
- requested local, GitHub, and Gitee tag states are correct.

Use `--tag-state head --require-remote-heads` after publication. Diagnostic legacy flags may inspect old releases but must never approve a new release.

## Synchronize source branches

Push the final clean release commits to their configured upstreams after review and authorization. Because the podspec source is a separate repository, explicitly synchronize the iOS release commit before final publication. Read the source URL from `HYSurveySDK.podspec` and configure it as a named remote once, for example `gitee`:

```bash
git remote add gitee <podspec-source-url>
git push gitee HEAD:develop
```

If the remote already exists, verify its URL with `git remote get-url gitee` instead of adding it again. Verify rather than assume that both remote branches resolve to the same final commit. Never force-push the source branch.

## Publish the Git tag

Require CocoaPods and run `pod lib lint HYSurveySDK.podspec --allow-warnings` before tagging. Installing CocoaPods is an environment setup action; do not silently skip lint.

After explicit final confirmation:

```bash
.agents/skills/release-ios-sdk/scripts/publish-release.sh \
  <version> \
  --confirm-publish <version>
```

The script requires clean worktrees, synced upstream/source branches, matching versions/changelog/assets, successful sample build, and successful pod lint. It then creates one annotated local tag, pushes it to the podspec source remote and primary remote, and verifies both remote tags peel to the final iOS commit.

Skipping pod lint requires both `--skip-pod-lint` and `--confirm-skip-pod-lint <version>`. Use this only after the user explicitly accepts the risk.

## Handle failures

- If any local or remote tag exists before publication, stop and inspect it. Never move or force-push a release tag.
- If one remote tag push succeeds and the other fails, preserve the local tag and successful remote tag. Report the partial release and retry the exact missing push only.
- If Gitee does not contain the final source commit, do not tag GitHub; consumers would receive a broken podspec source.
- If the sample build or pod lint fails, fix or explicitly escalate the failure. Do not tag around it.
- If preparation fails after editing files, show both statuses and let the user decide. Never discard generated or user changes automatically.
