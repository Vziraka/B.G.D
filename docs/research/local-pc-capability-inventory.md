# Local PC capability inventory — decision support

Date checked: **2026-08-30**. Source: read-only CIM and present-device enumeration on the current development PC, independently checked by the primary agent after a delegated inventory. Authored in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; new uncommitted research, not part of that commit. No camera/audio capture, benchmarks, device configuration or software installation occurred.

## Observed capabilities

| Item | Local observation |
| --- | --- |
| CPU | Intel Core Ultra 7 255H; 16 cores and 16 logical processors reported |
| Memory | 33,715,478,528 bytes, approximately 31.40 GiB reported |
| Operating system | Microsoft Windows 11 Home, version 10.0.26200, build 26200 |
| GPU adapters | NVIDIA GeForce RTX 4050 Laptop GPU; Intel Arc 140T GPU |
| Present camera names | HP 5MP Camera; HP IR Camera |
| Input-related audio endpoints | Microphone Array (Intel Smart Sound Technology for Digital Microphones); Headset (2- EarPods) appears twice |

The Intel adapter's full reported name includes `(16GB)`; that text is **not verified dedicated video memory**. Audio endpoint names do not by themselves identify recording/playback roles or establish successful capture. Display and speaker endpoints were also enumerated but are not evidence of microphone suitability.

## Scope and implications

The earlier **GPU unknown** inventory assumption is superseded. These devices are existing candidates for evaluating the owner-only PC phase, not a reason to purchase replacement cameras or microphones automatically. Whether the selected software can use GPU acceleration, access infrared frames, perform live capture with the required permissions, or meet the agreed speed, reliability and anti-spoofing requirements remains untested.

This does **not** establish Windows Hello interoperability, trusted capture, depth sensing, liveness resistance or zero additional desk-phase cost. Hardware-specific software support, consent/permissions and actual evaluation remain prerequisites to such claims. No enrollment data, account identifiers, serial numbers, audio or images were collected.

The PC inventory does not establish onboard computer capability or change the offline-operation, native-Windows M1 or deferred WSL2/ROS decisions. Current requirements remain in [ticket 10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Reproducible read-only queries

```powershell
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object TotalPhysicalMemory
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber
Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name
Get-PnpDevice -Class Camera -PresentOnly -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FriendlyName
Get-PnpDevice -Class AudioEndpoint -PresentOnly -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FriendlyName
```
