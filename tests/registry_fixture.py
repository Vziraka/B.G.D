"""Real HKCU test database; NOT the production HKLM permission boundary.

The separate machine-permission suite must validate the production ACL as well.
Fixtures never initialize or modify the production installation key.
"""

import atexit
import hashlib
import os
import uuid
import winreg

from pc_biometric.authority import RegistryAuthority
from pc_biometric.enrollment import Enrollment as AppEnrollment


NAMESPACE = os.environ.setdefault("BGD_TEST_REGISTRY_NAMESPACE", uuid.uuid4().hex)
KEYS = set()


def authority_for(directory, *, fixture_owner="synthetic-owner"):
    key = "Software\\BGD.PCBiometricDesk.Tests\\" + NAMESPACE + hashlib.sha256(str(directory).encode()).hexdigest()
    authority = RegistryAuthority(key=key, hive=winreg.HKEY_CURRENT_USER)
    if key not in KEYS:
        authority.install(fixture_owner)
        KEYS.add(key)
    return authority


def Enrollment(directory, *, fixture_owner="synthetic-owner", **kwargs):
    return AppEnrollment(directory, authority=authority_for(directory, fixture_owner=fixture_owner), **kwargs)


def cleanup():
    for key in KEYS:
        try:
            winreg.DeleteKeyEx(winreg.HKEY_CURRENT_USER, key, winreg.KEY_WOW64_64KEY)
        except FileNotFoundError:
            pass


atexit.register(cleanup)
