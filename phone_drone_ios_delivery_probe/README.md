# T-APP-1 native delivery probe

Prepared September 11, 2026; **NOT COMPILED, SIGNED, INSTALLED OR DEVICE-TESTED**.
This deliberately small UIKit app gives T-APP-1 a concrete input before the
Issue12 product app exists. It shows the installed OS, foreground state, a
persistent random installation marker and Apple's locale-specific offline
speech capability flag. It never requests speech authorization or captures
audio. No aircraft connection, command gate, camera, biometric processing or
key material exists. Its stored marker is test data, not a trusted identity.

After authorization for a compatible Mac build or private hosted upload:

```bash
bash phone_drone_ios_delivery_probe/build-unsigned.sh
```

The recipe uses Apple's installed SDK/compiler directly, creates a fresh
output directory, and records toolchain and IPA hash. It has no package manager,
third-party dependency, signing secret, active CI workflow or upload command.
The IPA remains unsigned and cannot run until separately authorized personal
signing/install. This source recipe has not proved that the compiler, packager
or AltStore accepts the result; record and repair the first real build failure.
If the direct compiler recipe needs Xcode-generated bundle metadata, generate
the smallest native Xcode app target and retain the failed recipe as evidence.

For a future private GitHub Actions build, use a standard macOS runner, manually
select an installed supported Xcode, check its version, then run the command
above. Upload only this four-file probe directory, not the repository or any
credentials. Verify account quota and block paid overages first. Download the
unsigned output and toolchain/hash evidence with short artifact retention;
personal signing stays on the owner's computer. A provider may also supply a
reviewed remote Mac session; public source publication is unnecessary.

T-APP-1 acceptance and explicit remaining device/authorization boundaries are
in [app-delivery.md](../docs/hardware/candidate-c1-2026-09-11/app-delivery.md).
When authorized, compare the marker before and after refresh/reinstall, test
opening before and after the actual profile expiry, and record actual offline
speech support. The flag alone does not establish model availability, latency,
recognition accuracy or an internet-independent app. Do not alter the device
clock to simulate expiry.
