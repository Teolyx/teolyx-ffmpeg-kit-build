#!/usr/bin/env bash
# LGPL build for Teolyx Clear iOS (device arm64 + arm64 simulator), as
# xcframeworks. Hardware H.264 comes from VideoToolbox.
#
# Flag syntax verified against arthenica/ffmpeg-kit-next's apple/README.md
# at the commit pinned in ../.github/workflows/build.yml: current flags are
# `--enable-lib-<lib>` / `--disable-arch-<arch>` (old `--enable-<lib>` /
# `--disable-<arch>` still work as deprecated aliases). `-x`/`--xcframework`
# is unchanged. iOS defaults to arm64 + arm64-mac-catalyst + arm64-simulator
# + arm64e + x86_64 + x86_64-mac-catalyst enabled, armv7/armv7s/i386 already
# off - disabling arm64e/x86_64/x86_64-mac-catalyst/arm64-mac-catalyst below
# leaves exactly arm64 (device) + arm64-simulator, matching the comment above.
set -euo pipefail
cd "$(dirname "$0")/../fkn"
./ios.sh -x \
  --enable-lib-ios-videotoolbox \
  --enable-lib-ios-audiotoolbox \
  --enable-lib-ios-zlib \
  --enable-lib-lame \
  --disable-arch-armv7 --disable-arch-armv7s --disable-arch-arm64e --disable-arch-i386 \
  --disable-arch-x86-64 --disable-arch-x86-64-mac-catalyst --disable-arch-arm64-mac-catalyst
mkdir -p ../dist
# The xcframework output dir is version-suffixed
# (bundle-apple-xcframework-ios-<IOS_MIN_VERSION>, e.g. ...-ios-12.1 with this
# commit's default min version) rather than the brief's unsuffixed
# bundle-apple-xcframework-ios - verified in scripts/function-apple.sh
# (get_xcframework_directory). Globbing avoids hardcoding that version.
cd prebuilt/bundle-apple-xcframework-ios-*
zip -qry ../../../dist/ffmpeg-kit-ios-xcframeworks.zip ./*.xcframework
