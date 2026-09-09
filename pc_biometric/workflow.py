"""Public desk workflow. Readiness never grants authorization or opens devices."""

from dataclasses import dataclass
import hashlib
from collections.abc import Callable
from importlib import metadata
import ctypes
import os
from pathlib import Path
import platform
import subprocess
import struct
import sys


@dataclass(frozen=True)
class Check:
    group: str
    name: str
    state: str
    detail: str


@dataclass(frozen=True)
class Readiness:
    checks: tuple[Check, ...]
    authorized: bool = False
    capture_active: bool = False


MODELS = (
    ("Face detection", "face_detection_yunet_2023mar.onnx",
     "8f2383e4dd3cfbb4553ea8718107fc0423210dc964f9f4280604804ed2552fa4", ()),
    ("Face recognition", "face_recognition_sface_2021dec.onnx",
     "0ba9fbfa01b5270c96627c4ef784da859931e02f04419c829e83484087c34e79", ()),
    ("Speech recognition", "vosk-model-small-en-us-0.15", "e1bc6b77e048181fce1c9532847a55687fc4f132077c52906696b777a7a2fcbd",
     ("am/final.mdl", "conf/mfcc.conf", "conf/model.conf", "graph/HCLr.fst", "graph/Gr.fst")),
    ("Speaker recognition", "vosk-model-spk-0.4", "8a06591113a4ddad5fd1ca8d53f53c1d3f37acc651b372fbdf48771e36316afd",
     ("final.ext.raw", "mean.vec", "transform.mat", "mfcc.conf")),
)

PACKAGES = {
    "opencv-python": "4.13.0.92",
    "vosk": "0.3.45",
    "sounddevice": "0.5.6",
    "winrt-runtime": "3.2.1",
    "winrt-Windows.Security.Credentials.UI": "3.2.1",
}


def supported_platform() -> bool:
    return (sys.platform == "win32" and sys.getwindowsversion().build >= 22000
            and sys.version_info[:2] == (3, 13) and struct.calcsize("P") == 8
            and platform.machine().upper() in {"AMD64", "X86_64"})


def model_matches(path: Path, digest: str, members: tuple[str, ...]) -> bool:
    """Validate one pinned file or the exact contents of one extracted model tree."""
    if members:
        if not path.is_dir() or not all((path / member).is_file() for member in members):
            return False
        total = hashlib.sha256()
        for item in sorted(candidate for candidate in path.rglob("*") if candidate.is_file()):
            relative = item.relative_to(path).as_posix().encode()
            with item.open("rb") as stream:
                item_digest = hashlib.file_digest(stream, "sha256").digest()
            total.update(relative + b"\0" + str(item.stat().st_size).encode()
                         + b"\0" + item_digest + b"\0")
        return total.hexdigest() == digest
    if not path.is_file():
        return False
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest() == digest


def all_models_valid(root: Path) -> bool:
    try:
        return all(model_matches(root / filename, digest, members)
                   for _name, filename, digest, members in MODELS)
    except OSError:
        return False

TASKS = {
    "Setup": ("Deliberate owner setup", "Set up owner",
              "Owner enrollment is not available in this readiness build. It requires fresh Windows "
              "verification, consented face and voice capture, protected storage and a saved offline code. "
              "Missing profile data must never reopen setup automatically."),
    "Verify": ("One request. One fresh check.", "Start verification",
               "A fresh face and random spoken phrase authorize only this desktop result. "
               "Development only: retry persistence and spoof/input defenses remain incomplete. "
               "No reusable unlocked session or aircraft action."),
    "Account": ("Your owner profile", "Update profile",
                "Profile updates and lost-code replacement are not available in this readiness build. "
                "Both require the existing face, voice and fresh owner Windows verification. "
                "Replacing a lost code must leave enrollment unchanged."),
    "Recovery": ("A careful way back in", "Start recovery",
                 "Lockout recovery is not available in this readiness build. It requires a valid offline "
                 "code plus fresh owner Windows verification. A new code must be saved before replacement "
                 "completes. If no valid code exists and either biometric cannot pass, this version "
                 "offers no recovery or Windows-only reset."),
}


def inspect_devices() -> tuple[Check, ...]:
    """Local enumeration only. No capture handles, credential UI or model imports."""
    if sys.platform != "win32":
        return (Check("Devices", "Windows interfaces", "Failed", "Use native Windows 11 x64."),)
    checks = []
    # Get-PnpDevice lists interfaces, not frames; do not infer liveness/access from it.
    powershell = Path(os.environ["SystemRoot"]) / "System32/WindowsPowerShell/v1.0/powershell.exe"
    try:
        result = subprocess.run(
            [str(powershell), "-NoLogo", "-NoProfile", "-NonInteractive", "-Command",
             "$ErrorActionPreference='Stop'; "
             "@(Get-PnpDevice -PresentOnly | Where-Object { $_.Class -in @('Camera','Image') }).Count"],
            capture_output=True, text=True, timeout=12, check=True,
            creationflags=subprocess.CREATE_NO_WINDOW,
        )
        count = int(result.stdout.strip())
        if count < 0:
            raise ValueError("Invalid count")
        checks.append(Check("Devices", "Camera", "Unverified" if count else "Missing",
                            f"{count} imaging interface(s) listed; access, RGB/IR and liveness untested. "
                            "Check Windows camera privacy settings and device drivers."))
    except (OSError, subprocess.SubprocessError, ValueError):
        checks.append(Check("Devices", "Camera", "Failed",
                            "Cannot inspect camera interfaces. Check Device Manager; refresh readiness."))
    try:
        winmm = ctypes.WinDLL("winmm.dll")
        winmm.waveInGetNumDevs.restype = ctypes.c_uint
        count = winmm.waveInGetNumDevs()
        checks.append(Check("Devices", "Microphone", "Unverified" if count else "Missing",
                            f"{count} audio input interface(s) listed; recording access and quality untested. "
                            "Check Windows microphone privacy settings and input selection."))
    except OSError:
        checks.append(Check("Devices", "Microphone", "Failed",
                            "Cannot inspect audio inputs. Check Windows sound settings and drivers."))
    checks.append(Check("Devices", "Windows verification", "Unverified",
                        "No account prompt opened. Windows Hello availability, owner binding and offline "
                        "verification need a deliberate setup session; an unlocked desktop is insufficient."))
    return tuple(checks)


class DeskWorkflow:
    def __init__(self, model_root: Path, *,
                 device_probe: Callable[[], tuple[Check, ...]] = inspect_devices,
                 package_version: Callable[[str], str] | None = None,
                 model_probe: Callable[[Path, str, tuple[str, ...]], bool] = model_matches,
                 platform_probe: Callable[[], bool] = supported_platform):
        self.model_root = model_root
        self.device_probe = device_probe
        self.package_version = metadata.version if package_version is None else package_version
        self.model_probe = model_probe
        self.platform_probe = platform_probe

    def task(self, name: str) -> tuple[str, str, str]:
        return TASKS[name]

    def refresh(self) -> Readiness:
        compatible = self.platform_probe()
        checks = [Check("Platform", "Windows / Python", "Available" if compatible else "Failed",
                        ("Windows 11+ / Python 3.13 x64 detected. " if compatible else
                         "Requires Windows 11+ / Python 3.13 x64. ") +
                        "Tested development baseline: CPython 3.13.12, Tcl/Tk 8.6.15; "
                        "this row does not inspect Tk or validate biometrics.")]
        for package, required in PACKAGES.items():
            try:
                installed = self.package_version(package)
                state = "Unverified" if installed == required else "Failed"
                detail = (f"{required} installed; native loading/integration untested."
                          if installed == required else f"Expected {required}; reinstall the pinned environment.")
            except metadata.PackageNotFoundError:
                state, detail = "Missing", f"Install {package}=={required} using the documented offline bundle."
            except Exception:
                state, detail = "Failed", "Cannot inspect package metadata. Repair the local environment."
            checks.append(Check("Runtime", package, state, detail))
        for name, filename, digest, members in MODELS:
            path = self.model_root / filename
            state, detail = "Missing", f"Install {filename}; see docs/pc-biometric/README.md."
            try:
                if members and path.exists():
                    if not all((path / member).is_file() for member in members):
                        state, detail = "Missing", "Required model files are incomplete; reinstall the complete model."
                    elif any((path / member).stat().st_size == 0 for member in members):
                        state, detail = "Failed", "Empty model file. Reinstall the complete model."
                    else:
                        matches = self.model_probe(path, digest, members)
                        state = "Unverified" if matches else "Failed"
                        detail = ("Pinned extracted bytes verified; model loading and biometric performance untested."
                                  if matches else "Model tree checksum mismatch. Reinstall from the pinned archive.")
                elif digest and path.exists():
                    matches = self.model_probe(path, digest, members)
                    state = "Unverified" if matches else "Failed"
                    detail = ("Pinned bytes verified; model loading and biometric performance untested."
                              if matches else "Model checksum mismatch. Replace from the pinned source.")
            except OSError:
                state, detail = "Failed", "Model files cannot be read. Check local file permissions."
            checks.append(Check("Models", name, state, detail))
        try:
            checks.extend(self.device_probe())
        except Exception:
            checks.append(Check("Devices", "Device inspection", "Failed",
                                "Local device inspection failed. Check Windows device settings and refresh."))
        return Readiness(tuple(checks))
