#!/bin/bash
# Prepared recipe, NOT a recorded successful iOS build. Run on an authorized Mac.
set -euo pipefail
if [ "$(uname -s)" != Darwin ]; then
    echo 'Requires macOS with Xcode and the iPhoneOS SDK; no build was performed.' >&2
    exit 2
fi
probe_dir="$(cd "$(dirname "$0")" && pwd)"
# A new directory per run preserves every previous output without recursive deletion.
build_dir="$(mktemp -d "$probe_dir/build.XXXXXX")"
app_dir="$build_dir/Payload/DeliveryProbe.app"
mkdir -p "$app_dir"
cp "$probe_dir/Info.plist" "$app_dir/Info.plist"
xcodebuild -version > "$build_dir/toolchain.txt"
xcrun --sdk iphoneos --show-sdk-version >> "$build_dir/toolchain.txt"
sdk_path="$(xcrun --sdk iphoneos --show-sdk-path)"
xcrun --sdk iphoneos swiftc -parse-as-library -swift-version 5 \
    -target arm64-apple-ios17.0 -sdk "$sdk_path" \
    -framework UIKit -framework Speech \
    "$probe_dir/DeliveryProbe.swift" -o "$app_dir/DeliveryProbe"
plutil -lint "$app_dir/Info.plist"
file "$app_dir/DeliveryProbe" | tee -a "$build_dir/toolchain.txt"
# Deliberately no account, signing certificate, provisioning or exportArchive call.
ditto -c -k --keepParent "$build_dir/Payload" "$build_dir/DeliveryProbe-unsigned.ipa"
shasum -a 256 "$build_dir/DeliveryProbe-unsigned.ipa" > "$build_dir/SHA256.txt"
echo "Unsigned probe output: $build_dir"
