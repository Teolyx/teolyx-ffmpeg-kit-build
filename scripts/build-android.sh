#!/usr/bin/env bash
# LGPL build for Teolyx Clear Android. NEVER add --enable-gpl, x264 or x265:
# the app is closed source. Hardware H.264 comes from MediaCodec.
#
# Flag syntax verified against arthenica/ffmpeg-kit-next's android/README.md
# at the commit pinned in ../.github/workflows/build.yml: that commit renamed
# the old `--enable-<lib>` / `--disable-<arch>` flags to `--enable-lib-<lib>`
# / `--disable-arch-<arch>` (old names still work as deprecated aliases, but
# we use the current ones). Library names (android-media-codec, android-zlib,
# lame) and architecture names (arm-v7a-neon, x86) are unchanged.
set -euo pipefail
cd "$(dirname "$0")/../fkn"
./android.sh \
  --enable-lib-android-media-codec \
  --enable-lib-android-zlib \
  --enable-lib-lame \
  --disable-arch-arm-v7a-neon \
  --disable-arch-x86 \
  --api-level=24
mkdir -p ../dist
# The .aar gradle actually produces (verified in android.sh at the pinned
# commit: `ffmpeg-kit-next-android-lib:assembleRelease`). The brief's assumed
# path (prebuilt/bundle-android-aar/ffmpeg-kit/ffmpeg-kit.aar) does not exist
# at this commit - the local-maven bundle dir is versioned
# (prebuilt/bundle-android-aar-24-maven/...) and the artifact id is
# ffmpeg-kit-next, not ffmpeg-kit. We copy straight from the Gradle output,
# which is stable across FFmpeg/FFmpegKitNext version bumps.
cp android/ffmpeg-kit-next-android-lib/build/outputs/aar/ffmpeg-kit-next-release.aar ../dist/ffmpeg-kit.aar
