#!/usr/bin/env python3
"""Validate Survey iOS SDK release invariants without changing Git refs."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from html.parser import HTMLParser
from pathlib import Path


SEMVER_RE = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")


class AssetParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.references: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        if tag == "script" and values.get("src"):
            self.references.append(values["src"] or "")
        if tag == "link" and values.get("href"):
            self.references.append(values["href"] or "")


def run(repo: Path, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run([*args], cwd=repo, text=True, capture_output=True, check=check)


def git(repo: Path, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return run(repo, "git", *args, check=check)


def source_url(podspec_text: str) -> str:
    match = re.search(r":git\s*=>\s*['\"]([^'\"]+)['\"]", podspec_text)
    return match.group(1) if match else ""


def remote_refs(repo: Path, remote: str, *patterns: str) -> tuple[dict[str, str], str | None]:
    result = git(repo, "ls-remote", "--exit-code", remote, *patterns, check=False)
    if result.returncode not in (0, 2):
        return {}, result.stderr.strip() or "git ls-remote failed"
    refs: dict[str, str] = {}
    for line in result.stdout.splitlines():
        sha, ref = line.split(maxsplit=1)
        refs[ref] = sha
    return refs, None


def remote_tag_commit(refs: dict[str, str], version: str) -> str:
    return refs.get(f"refs/tags/{version}^{{}}") or refs.get(f"refs/tags/{version}", "")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", required=True)
    parser.add_argument("--ios-dir", type=Path)
    parser.add_argument("--ui-dir", type=Path)
    parser.add_argument("--primary-remote", default="origin")
    parser.add_argument("--source-remote")
    parser.add_argument("--branch", default="develop")
    parser.add_argument("--tag-state", choices=("absent", "head", "ignore"), default="absent")
    parser.add_argument("--check-remotes", action="store_true")
    parser.add_argument("--require-remote-heads", action="store_true")
    parser.add_argument("--allow-empty-core", action="store_true")
    parser.add_argument("--allow-missing-changelog", action="store_true")
    parser.add_argument("--skip-ui-version", action="store_true")
    args = parser.parse_args()

    script = Path(__file__).resolve()
    ios = (args.ios_dir or script.parents[4]).resolve()
    ui = (args.ui_dir or ios.parent / "survey-ui-next-uni2").resolve()
    version = args.version
    errors: list[str] = []
    notes: list[str] = []

    if not SEMVER_RE.fullmatch(version):
        errors.append(f"release version must be plain semantic version: {version}")

    required = [
        ios / "HYSurveySDK.podspec",
        ios / "version.txt",
        ios / "CHANGE.MD",
        ios / "surveySDK/Assets/index.html",
        ios / "surveySDK/Assets/version.json",
    ]
    if not args.skip_ui_version:
        required += [ui / "package.json", ui / "package-lock.json"]
    for path in required:
        if not path.is_file():
            errors.append(f"missing required file: {path}")
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    podspec_text = (ios / "HYSurveySDK.podspec").read_text()
    pod_match = re.search(r"s\.version\s*=\s*['\"]([^'\"]+)['\"]", podspec_text)
    pod_version = pod_match.group(1) if pod_match else ""
    if pod_version != version:
        errors.append(f"podspec version is {pod_version!r}, expected {version!r}")
    text_version = (ios / "version.txt").read_text().strip()
    if text_version != version:
        errors.append(f"version.txt is {text_version!r}, expected {version!r}")

    changelog = (ios / "CHANGE.MD").read_text()
    changelog_match = re.search(
        rf"(?ms)^# Version {re.escape(version)}\s*$\n(.*?)(?=^# Version |^# Bugs|\Z)",
        changelog,
    )
    if not changelog_match:
        if args.allow_missing_changelog:
            notes.append(f"legacy release accepted without Version {version} changelog section")
        else:
            errors.append(f"changelog has no Version {version} section")
    elif not re.search(r"(?m)^\s*-\s+\S", changelog_match.group(1)):
        errors.append(f"changelog Version {version} section has no entries")

    package: dict = {}
    if not args.skip_ui_version:
        package = json.loads((ui / "package.json").read_text())
        lock = json.loads((ui / "package-lock.json").read_text())
        if package.get("version") != version:
            errors.append(f"UI package version is {package.get('version')!r}, expected {version!r}")
        lock_versions = {lock.get("version"), (lock.get("packages") or {}).get("", {}).get("version")}
        lock_versions.discard(None)
        if lock_versions != {version}:
            errors.append(f"UI lockfile versions are {sorted(lock_versions)!r}, expected only {version!r}")

    assets = ios / "surveySDK/Assets"
    metadata = json.loads((assets / "version.json").read_text())
    if metadata.get("version") != version:
        errors.append(f"embedded Web version is {metadata.get('version')!r}, expected {version!r}")
    actual_core = metadata.get("core", "")
    expected_core = (package.get("dependencies") or {}).get("@hanyi/survey-core-next", "")
    if not actual_core and not args.allow_empty_core:
        errors.append("embedded version.json.core is empty")
    elif actual_core and expected_core and actual_core != expected_core:
        errors.append(f"embedded core version is {actual_core!r}, expected {expected_core!r}")
    elif not actual_core:
        notes.append("legacy release accepted with empty version.json.core")

    html_parser = AssetParser()
    html_parser.feed((assets / "index.html").read_text())
    for reference in html_parser.references:
        relative = reference.split("?", 1)[0].split("#", 1)[0].removeprefix("./")
        if relative and not (assets / relative).is_file():
            errors.append(f"index.html references missing asset: {reference}")
    js_files = sorted((assets / "static/js").glob("*.js"))
    if not js_files:
        errors.append("embedded static/js contains no JavaScript files")
    for path in js_files:
        if not path.name.endswith(f"_{version}.js"):
            errors.append(f"JavaScript filename does not contain release version: {path.name}")

    source = args.source_remote or source_url(podspec_text)
    if not source:
        errors.append("podspec source Git URL is missing")

    head = git(ios, "rev-parse", "HEAD").stdout.strip()
    ui_head = git(ui, "rev-parse", "HEAD").stdout.strip() if ui.exists() else "missing"
    local = git(ios, "rev-parse", "-q", "--verify", f"refs/tags/{version}", check=False)
    local_exists = local.returncode == 0
    if args.tag_state == "absent" and local_exists:
        errors.append(f"local tag already exists: {version}")
    if args.tag_state == "head":
        if not local_exists:
            errors.append(f"local tag is missing: {version}")
        elif git(ios, "rev-list", "-n", "1", version).stdout.strip() != head:
            errors.append(f"local tag {version} does not point to HEAD {head}")

    if args.check_remotes or args.require_remote_heads:
        targets = [("primary", args.primary_remote)]
        if source and source != args.primary_remote:
            targets.append(("podspec source", source))
        for label, remote in targets:
            patterns = [f"refs/tags/{version}", f"refs/tags/{version}^{{}}"]
            if args.require_remote_heads:
                patterns.append(f"refs/heads/{args.branch}")
            refs, remote_error = remote_refs(ios, remote, *patterns)
            if remote_error:
                errors.append(f"could not inspect {label} remote {remote}: {remote_error}")
                continue
            tag_commit = remote_tag_commit(refs, version)
            if args.tag_state == "absent" and tag_commit:
                errors.append(f"{label} remote tag already exists: {version}")
            if args.tag_state == "head":
                if not tag_commit:
                    errors.append(f"{label} remote tag is missing: {version}")
                elif tag_commit != head:
                    errors.append(f"{label} tag points to {tag_commit}, expected HEAD {head}")
            if args.require_remote_heads:
                branch_sha = refs.get(f"refs/heads/{args.branch}", "")
                if branch_sha != head:
                    errors.append(
                        f"{label} branch {args.branch} points to {branch_sha or 'missing'}, expected {head}"
                    )

    print(f"Version: {version}")
    print(f"iOS HEAD: {head}")
    print(f"UI HEAD: {ui_head}")
    print(f"Pod: HYSurveySDK ({version})")
    print(f"Primary remote: {args.primary_remote}")
    print(f"Podspec source: {source or 'missing'}")
    print(f"Tag: {version}")
    for note in notes:
        print(f"NOTE: {note}")
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("Release validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
