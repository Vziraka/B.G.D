"""Explicit one-shot authority installer; no capture or Windows verification.

Run from an administrator shell as the designated Windows account. UAC/elevation
does not count as biometric enrollment or fresh owner verification. Existing
authority is retained, including committed enrollment; no reset command exists.
"""

from .authority import RegistryAuthority, is_elevated
from .windows import current_account


def main() -> int:
    if not is_elevated():
        print("Run this one-shot authority installer from an administrator shell as the designated account. "
              "Normal B.G.D operation must remain unelevated.")
        return 2
    try:
        RegistryAuthority().install(current_account())
    except (OSError, ValueError):
        print("Protected installation could not be confirmed. Existing state was not reset; "
              "investigate permissions/state before enrollment.")
        return 1
    print("Protected authority retained or installed. No Windows verification or biometric enrollment performed. "
          "Close administrator setup; run the normal desk application unelevated.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
