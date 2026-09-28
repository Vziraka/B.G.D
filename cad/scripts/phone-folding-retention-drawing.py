"""Review detail sheet for the preserved phone closure and USB retention."""
from pathlib import Path
import html
OUT=Path(__file__).resolve().parents[2]/'cad/revision-r3'
s=['<svg xmlns="http://www.w3.org/2000/svg" width="1500" height="1050" viewBox="0 0 1500 1050"><rect width="1500" height="1050" fill="white"/><style>text{font:17px Arial;fill:#173044}.title{font-size:27px;font-weight:bold}.head{font-size:21px;font-weight:bold}.small{font-size:15px}</style>']
def t(x,y,a,c=''):s.append(f'<text x="{x}" y="{y}" class="{c}">{html.escape(a)}</text>')
def r(x,y,w,h,fill='none',stroke='#34777b'):s.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" stroke="{stroke}" stroke-width="2"/>')
def l(x,y,a,b):s.append(f'<path d="M{x},{y} L{a},{b}" fill="none" stroke="#647788"/>')
t(35,42,'B.G.D. / phone capture and USB retention details','title')
t(35,72,'REVIEW ONLY: dimensions follow the saved native candidate. Units mm; illustrations are enlarged and schematic.')
t(35,102,'No fabrication release. Exact material process, delivered hardware, frame attachment and load capacity remain unqualified.')
t(40,150,'A / Nut-pocket section through X = +84.5','head')
# Side-boss section: Z138..148.5; topbar148.5..151.5; washer151.5..152.5.
scale=16; x=200; y=410
def zrect(x0,z0,w,h,fill):r(x+x0*scale,y-(z0-138+h)*scale,w*scale,h*scale,fill)
zrect(-5,138,10,10.5,'#e2f0ee');zrect(-2.9,142.5,5.8,2.6,'white');zrect(-2.75,142.6,5.5,2.4,'#b4c3cd');zrect(-5,148.5,10,3,'#d0e5e2');zrect(-3,151.5,6,1,'#b4c3cd');zrect(-1.5,140.5,3,12,'#8b9ba5')
t(355,205,'1 mm washer stack / screw bearing surface')
t(355,243,'Top bar 3 mm; clearance bore Ø3.2')
t(355,283,'Pocket 5.8 wide × 2.6 high; center Z143.8')
t(355,317,'M3 nut 5.5 AF × 2.4 nominal')
t(355,351,'M3 × 12 shank reservation: Z140.5..152.5')
t(40,446,'Pocket opens toward +Y (screen side), 14 mm entry depth.')
t(40,474,'Two bolts on 169 mm pitch. Verify full nut engagement and anti-loosening method.')
t(40,502,'Foam contacts the phone body; the screw must never bottom against the phone.')
t(815,150,'B / Actual four-port hub topology','head')
r(880,210,90,250,'#e2e9ef');r(899,460,52,92,'#bacad4')
for py,label in [(240,'FC serial'),(310,'Front ToF serial'),(380,'Temperature MCP')]:
 r(962,py,38,26,'#bacad4');l(1000,py+13,1070,py+13);r(1070,py-7,120,40,'#e2f0ee');t(1202,py+18,label,'small')
t(824,192,'Hub inverted: three top ports face down; fourth port at end.')
t(984,495,'TPM direct USB-A')
t(815,578,'Three factory 152 mm A-to-C cables; source USB-C modules.')
t(815,606,'End-stop opening 18 × 10. Exact port/bend coordinates remain C4.')
t(815,634,'Module tray 36 × 24 × 2; tie slots 11 × 3.2.')
t(815,662,'Tie over a verified component-free area; do not clamp the USB socket.')
t(815,690,'D500 interface is pending; this sheet preserves the original four-port core.')
l(35,730,1465,730)
t(40,774,'C / Proposed independent retention proof-load cases','head')
t(40,812,'Phone 197 g: 9.66 N; lamp 101 g: 4.95 N; original 480 g pack: 23.54 N at 5 g.')
t(40,842,'A conservative 1035 g replacement pack would require 50.77 N before straps, foam and connector loads.')
t(40,872,'Apply each axis separately through body contacts. These are test hypotheses, not demonstrated capacities.')
t(40,912,'Inspect: no release, permanent motion, lens/button interference, wire loading or rotor intrusion after each case.')
t(40,942,'Cable service loop: retain the cable jacket before its connector; verify actual bend radius and insertion/removal.')
t(40,982,'Native authority: phone-folding-final.f3d. Source-part envelopes and frame coordinates retain their documented uncertainty.','small')
s.append('</svg>');(OUT/'phone-folding-retention-detail.svg').write_text('\n'.join(s),encoding='utf8')
