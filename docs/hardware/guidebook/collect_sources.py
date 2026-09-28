"""Download selected public reference assets; never connects to aircraft hardware."""
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.parse import urljoin
import concurrent.futures, hashlib, html, json, re

ROOT = Path(__file__).resolve().parents[3]
DEST = Path(__file__).parent / 'assets'
DEST.mkdir(parents=True, exist_ok=True)
PAGES = {
    'fc': 'https://micoair.com/flightcontroller_micoair743/',
    'motor': 'https://ardupilot.org/copter/docs/connect-escs-and-motors.html',
    'accel': 'https://ardupilot.org/copter/docs/common-accelerometer-calibration.html',
    'radio': 'https://ardupilot.org/copter/docs/common-radio-control-calibration.html',
    'compass': 'https://ardupilot.org/copter/docs/common-compass-calibration-in-mission-planner.html',
    'flash': 'https://ardupilot.org/copter/docs/common-loading-firmware-onto-chibios-only-boards.html',
    'literadio': 'https://betafpv.com/products/literadio-4-radio-transmitter',
    'receiver': 'https://betafpv.com/products/elrs-nano-receiver',
    'depth': 'https://www.pololu.com/product/3418',
    'current': 'https://www.pololu.com/product/5292',
    'bec': 'https://www.mateksys.com/?portfolio=bec12s-pro',
}

def fetch(url):
    return urlopen(Request(url, headers={'User-Agent': 'Mozilla/5.0'}), timeout=45).read()

def inspect(pair):
    key, url = pair
    try:
        data = fetch(url)
        (DEST / (key + '.html')).write_bytes(data)
        raw = data.decode('utf-8', 'replace')
        imgs = re.findall(r'<img\b[^>]*>', raw, re.I)
        images = []
        for tag in imgs:
            src = re.search(r'\bsrc=["\']([^"\']+)', tag, re.I)
            alt = re.search(r'\balt=["\']([^"\']*)', tag, re.I)
            if src:
                images.append({'url': urljoin(url, html.unescape(src[1])), 'alt': html.unescape(alt[1]) if alt else ''})
        links = [urljoin(url,html.unescape(s)) for s in re.findall(r'href=["\']([^"\']+)',raw) if '.pdf' in s.lower() or 'article_attachments' in s]
        return key, {'url': url, 'images':images, 'manuals':list(dict.fromkeys(links)), 'sha256':hashlib.sha256(data).hexdigest()}
    except Exception as exc:
        return key, {'url':url, 'error':str(exc)}

if __name__ == '__main__':
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        result = dict(pool.map(inspect, PAGES.items()))
    (DEST/'source-index.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    for key, result in result.items():
        print(key, result.get('error', ''), json.dumps(result.get('manuals', [])))
        for img in result.get('images', []):
            if key in ('fc','motor','accel','radio','compass','flash','bec') or any(x in img['alt'].lower() for x in ('connection','pin','diagram','configurator','manual')):
                print(' ',json.dumps(img))
