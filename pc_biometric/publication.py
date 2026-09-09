"""One-shot UAC publication of public ownership metadata, never biometric data.

The elevated process runs Windows' system PowerShell with an inline fixed script;
it does not execute the user-writable Python runtime or read any user file. No
execution-policy override, service, listener, capture or credential API is used.
UAC authorizes the privileged write, not fresh owner authentication. Enrollment
must already have performed its Windows/capture/code-saving workflow.
"""

import base64
import ctypes as ct
from ctypes import wintypes as wt
from dataclasses import asdict
import hashlib
import json
from pathlib import Path
import winreg

from .authority import AuthorityState, KEY, MUTEX_SDDL, SDDL, is_elevated
from .windows import _api
from .coordination import marker_names


# No path, executable or script text comes from the publication request. Module
# lookup is restricted to the system PowerShell installation, including JSON.
SCRIPT = r"""
$ErrorActionPreference = 'Stop'
$PSModuleAutoLoadingPreference = 'None'
$env:PSModulePath = [IO.Path]::Combine($PSHOME, 'Modules')
Import-Module ([IO.Path]::Combine($PSHOME, 'Modules\Microsoft.PowerShell.Utility\Microsoft.PowerShell.Utility.psd1'))
$mutex = $null; $base = $null; $key = $null; $acquired = $false; $busy = $null; $live = $null
try {
    $proposal = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($proposal64)) | ConvertFrom-Json
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -or
        $identity.User.Value -cne $proposal.owner) { throw 'Wrong setup account or privilege' }
    # Open fixed then unique. If the parent died before handoff, the old unique
    # marker cannot be replaced by the fixed marker of a newer setup attempt.
    $busy = [Threading.EventWaitHandle]::OpenExisting($busyName, 'Synchronize')
    $live = [Threading.EventWaitHandle]::OpenExisting($liveName, 'Synchronize')
    if ($proposal.installation -cnotmatch '^[0-9a-f]{32}$' -or
        $proposal.profile -cnotmatch '^[0-9a-f]{32}$' -or
        $proposal.digest -cnotmatch '^[0-9a-f]{64}$') { throw 'Invalid proposal' }
    $security = [Security.AccessControl.MutexSecurity]::new()
    $security.SetSecurityDescriptorSddlForm($mutexSddl)
    $created = $false
    $mutex = [Threading.Mutex]::new($false, $mutexName, [ref]$created, $security)
    $sections = [Security.AccessControl.AccessControlSections]'Owner,Group,Access'
    if ($mutex.GetAccessControl().GetSecurityDescriptorSddlForm($sections) -cne $mutexSddl) {
        throw 'Changed coordination permissions'
    }
    try { $acquired = $mutex.WaitOne(0) }
    catch [Threading.AbandonedMutexException] { $acquired = $true }
    if (!$acquired) { throw 'Another setup writer is active' }
    $base = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', 'Registry64')
    $rights = [Security.AccessControl.RegistryRights]'ReadKey,SetValue'
    $key = $base.OpenSubKey($keyName, 'ReadWriteSubTree', $rights)
    if ($null -eq $key -or
        $key.GetAccessControl().GetSecurityDescriptorSddlForm($sections) -cne $registrySddl) {
        throw 'Missing or changed authority'
    }
    $data = $key.GetValue('State', $null, 'DoNotExpandEnvironmentNames')
    if ($key.GetValueKind('State') -ne 'Binary' -or $data -isnot [byte[]] -or $data.Length -gt 4096) {
        throw 'Damaged authority'
    }
    $state = [Text.Encoding]::UTF8.GetString($data) | ConvertFrom-Json
    $names = @($state.PSObject.Properties.Name | Sort-Object)
    if (($names -join ',') -cne 'digest,installation,owner,profile' -or
        $state.installation -isnot [string] -or $state.owner -isnot [string] -or
        $state.profile -isnot [string] -or $state.digest -isnot [string] -or
        $state.installation -cne $proposal.installation -or $state.owner -cne $proposal.owner -or
        $state.profile -cne '' -or $state.digest -cne '') { throw 'Authority changed or already committed' }
    $key.SetValue('State', [Convert]::FromBase64String($proposal64), 'Binary')
    $key.Flush()
}
catch { exit 1 }
finally {
    if ($null -ne $key) { $key.Dispose() }
    if ($null -ne $base) { $base.Dispose() }
    if ($acquired) { $mutex.ReleaseMutex() }
    if ($null -ne $mutex) { $mutex.Dispose() }
    if ($null -ne $live) { $live.Dispose() }
    if ($null -ne $busy) { $busy.Dispose() }
}
exit 0
"""


def publication_command(candidate: AuthorityState, lease: str, *, key: str = KEY) -> str:
    """Build the reviewed system-helper command; alternate keys are test-only."""
    validation_prefix = r"SOFTWARE\BGD.PCBiometricDesk.Validation."
    if key != KEY and not (key.startswith(validation_prefix)
                          and len(key.removeprefix(validation_prefix)) == 32
                          and all(c in '0123456789abcdef' for c in key.removeprefix(validation_prefix))):
        raise ValueError("Only the production authority or a unique validation key is supported.")
    if not candidate.profile:
        raise ValueError("A complete enrollment proposal is required.")
    proposal64 = base64.b64encode(json.dumps(asdict(candidate)).encode()).decode()
    busy, live = marker_names(candidate.installation, lease)
    identity = f"{winreg.HKEY_LOCAL_MACHINE}:" + key.casefold()
    mutex = "Global\\BGD.PCBiometricDesk." + hashlib.sha256(identity.encode()).hexdigest()
    script = (f"$proposal64 = '{proposal64}'\n$keyName = '{key}'\n"
              f"$mutexName = '{mutex}'\n$mutexSddl = '{MUTEX_SDDL}'\n$registrySddl = '{SDDL}'\n"
              f"$busyName = '{busy}'\n$liveName = '{live}'\n" + SCRIPT)
    return "-NoLogo -NoProfile -NonInteractive -EncodedCommand " + base64.b64encode(script.encode('utf-16-le')).decode()


class ShellExecuteInfo(ct.Structure):
    _fields_ = [("size", wt.DWORD), ("mask", wt.ULONG), ("window", wt.HWND),
                ("verb", wt.LPCWSTR), ("file", wt.LPCWSTR), ("parameters", wt.LPCWSTR),
                ("directory", wt.LPCWSTR), ("show", ct.c_int), ("instance", wt.HINSTANCE),
                ("id_list", ct.c_void_p), ("class_name", wt.LPCWSTR), ("class_key", wt.HKEY),
                ("hot_key", wt.DWORD), ("icon_or_monitor", wt.HANDLE), ("process", wt.HANDLE)]


def publish_elevated(candidate: AuthorityState, lease: str, *, key: str = KEY) -> None:
    """Invoked only at explicit setup completion; never from status or startup."""
    if is_elevated():
        raise OSError("The enrollment process must remain unelevated.")
    directory = ct.create_unicode_buffer(32768)
    size = _api("kernel32", "GetSystemDirectoryW", wt.UINT, wt.LPWSTR, wt.UINT)(directory, len(directory))
    if not 0 < size < len(directory):
        raise OSError("System setup helper is unavailable.")
    executable = str(Path(directory.value) / "WindowsPowerShell" / "v1.0" / "powershell.exe")
    info = ShellExecuteInfo(size=ct.sizeof(ShellExecuteInfo), mask=0x140, verb="runas",
                            file=executable, parameters=publication_command(candidate, lease, key=key), show=0,
                            directory=directory.value)
    initialized = _api("ole32", "CoInitializeEx", wt.LONG, ct.c_void_p, wt.DWORD)(None, 2)
    if initialized < 0:
        raise OSError("System setup helper could not initialize.")
    try:
        if not _api("shell32", "ShellExecuteExW", wt.BOOL, ct.POINTER(ShellExecuteInfo))(ct.byref(info)):
            raise OSError("Administrator setup was canceled or unavailable; publication was not confirmed.")
        if not info.process:
            raise OSError("No setup process was returned; inspect protected state.")
        try:
            handle, index = wt.HANDLE(info.process), wt.DWORD()
            # Pump this STA's COM/window messages while waiting. On timeout or
            # failure, the helper's retained lifetime markers still block setup.
            waited = _api("ole32", "CoWaitForMultipleHandles", wt.LONG, wt.DWORD, wt.DWORD,
                          wt.ULONG, ct.POINTER(wt.HANDLE), ct.POINTER(wt.DWORD))(
                0x18, 30000, 1, ct.byref(handle), ct.byref(index))
            code = wt.DWORD()
            if (waited != 0 or not _api("kernel32", "GetExitCodeProcess", wt.BOOL, wt.HANDLE,
                                       ct.POINTER(wt.DWORD))(info.process, ct.byref(code)) or code.value != 0):
                raise OSError("Setup publication is unconfirmed; inspect protected state before retrying.")
        finally:
            _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(info.process)
    finally:
        _api("ole32", "CoUninitialize", None)()
