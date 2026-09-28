"""Reference image/manual acquisition with provenance and hashes."""
from pathlib import Path
import concurrent.futures, hashlib, json
from collect_sources import fetch, DEST

ASSETS = {
 'fc-ports.webp': 'https://micoair.com/wp-content/uploads/2024/04/MicoAir743_Ports2-jpg.webp',
 'fc-top.webp': 'https://micoair.com/wp-content/uploads/2024/04/MicoAir743_TopView-jpg.webp',
 'bec.jpg': 'https://www.mateksys.com/wp-content/uploads/2022/10/BEC12S-PRO_1.jpg',
 'quad-x.svg': 'https://ardupilot.org/copter/_images/m_01_01_quad_x1.svg',
 'motor-test.png': 'https://ardupilot.org/copter/_images/MissionPlanner_MotorTest.png',
 'accel-setup.png': 'https://ardupilot.org/copter/_images/mp_accelerometer_calibration.png',
 'accel-positions.jpg': 'https://ardupilot.org/copter/_images/accel-calib-positions-e1376083327116.jpg',
 'radio-calibration.png': 'https://ardupilot.org/copter/_images/mp_radio_calibration.png',
 'compass.png': 'https://ardupilot.org/copter/_images/CompassCalibration_Onboard.png',
 'dfu-device.png': 'https://ardupilot.org/copter/_images/loading-firmware-device-manager.png',
 'flash.png.jpg': 'https://ardupilot.org/copter/_images/STM32CubeProgrammer2.jpg',
 'literadio-config.jpg': 'https://cdn.shopify.com/s/files/1/1778/6615/files/LiteRadio_4_Radio_Transmitter_-_BETAFPV_Configurator.jpg?v=1747809945',
 'literadio-manual.pdf': 'https://support.betafpv.com/hc/en-us/article_attachments/50934796027673',
 'm450-manual.pdf': 'https://download.toolkitrc.com/wp-content/uploads/2024/09/M450-Manual-V1.1-.pdf',
 'camera-mechanical.pdf': 'https://datasheets.raspberrypi.com/camera/camera-module-3-standard-mechanical-drawing.pdf',
 'pi-mechanical.pdf': 'https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf',
}

def get(pair):
    name, url = pair
    try:
        data = fetch(url)
        (DEST/name).write_bytes(data)
        return {'file':name,'url':url,'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data),'retrieved':'2026-09-22'}
    except Exception as exc:
        return {'file':name,'url':url,'error':str(exc)}

if __name__ == '__main__':
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        records = list(pool.map(get, ASSETS.items()))
    (DEST/'asset-manifest.json').write_text(json.dumps(records,indent=2),encoding='utf-8')
    print(json.dumps(records, indent=2))
