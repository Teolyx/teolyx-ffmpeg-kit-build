# teolyx-ffmpeg-kit-build

Builds LGPL FFmpegKitNext binaries for the Teolyx Clear mobile app on free
GitHub Actions runners (the iOS build needs macOS). This repo contains
build scripts only - no app code.

Release: push a tag `vN` -> CI builds Android (AAR) + iOS (xcframeworks
zip) and publishes them with SHA256SUMS.txt. The app pins a tag and the
checksums in `teolyx-clear-mobile/ffmpeg-kit.lock.json`.

## Pinned upstream

`FFMPEG_KIT_NEXT_REF` in `.github/workflows/build.yml` pins
[arthenica/ffmpeg-kit-next](https://github.com/arthenica/ffmpeg-kit-next)
(the official continuation of the archived `arthenica/ffmpeg-kit`) at its
`HEAD` commit as of 2026-10-15. Re-pin by running
`git ls-remote https://github.com/arthenica/ffmpeg-kit-next HEAD` and
re-reading that commit's `android/README.md` / `apple/README.md` before
bumping the ref - flag names and build-output paths have changed between
releases (see comments in `scripts/build-android.sh` and
`scripts/build-ios.sh`).

## Workflow notes

- Every action runs on the Node 24 runtime (checkout v7, upload-artifact
  v7, download-artifact v8, action-gh-release v3); Node 20 actions are
  deprecated on GitHub runners.
- The workflow token is read-only except in the `release` job, checkouts do
  not keep credentials, and the release fails if an expected file is
  missing.
- Upstream has moved on since the pin (2026-11-09: HEAD `d031df3`, FFmpeg
  n9.0.2 vs n9.0.1 at the pinned ref). Re-pinning changes the shipped
  binaries: tag a new release (`v2`), then update
  `teolyx-clear-mobile/ffmpeg-kit.lock.json` and re-run the device
  checklist in `teolyx-clear-mobile/BUILD.md`.
