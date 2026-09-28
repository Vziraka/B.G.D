#!/usr/bin/env python3
"""Render the B.G.D hardware guidebook from a small JSON document."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Iterable

from reportlab.lib.colors import Color, HexColor, black, white
from reportlab.lib.pagesizes import letter
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.pdfgen import canvas


PAGE_W, PAGE_H = letter
MARGIN = 36
INK = HexColor("#151515")
MUTED = HexColor("#5E625F")
PALE = HexColor("#F2F3F0")
GREEN = HexColor("#27834A")
GREEN_PALE = HexColor("#E5F2E9")
AMBER = HexColor("#D39118")
AMBER_PALE = HexColor("#FFF0CC")
VALID_STATUS = {"REFERENCE", "BUILD", "FIT CHECK", "HOLD", "CHECKLIST"}
SCENES = {
    "frame", "arm", "screw", "leg", "motor", "stack", "pi", "camera",
    "gpio", "connector", "wiring", "battery", "charger", "multimeter",
    "solder", "print", "mount", "flow", "gps", "receiver", "led",
    "screen", "flight", "inspection",
}


class GuideError(ValueError):
    pass


def wrap(text: str, font: str, size: float, width: float) -> list[str]:
    """Wrap text without reducing the requested font size."""
    lines: list[str] = []
    for paragraph in str(text or "").splitlines() or [""]:
        words = paragraph.split()
        if not words:
            lines.append("")
            continue
        line = words.pop(0)
        if stringWidth(line, font, size) > width:
            raise GuideError(f"Unbreakable text is too wide: {line!r}")
        for word in words:
            trial = f"{line} {word}"
            if stringWidth(trial, font, size) <= width:
                line = trial
            else:
                lines.append(line)
                line = word
                if stringWidth(line, font, size) > width:
                    raise GuideError(f"Unbreakable text is too wide: {word!r}")
        lines.append(line)
    return lines


def text_block(c: canvas.Canvas, text: str, x: float, y: float, width: float,
               size: float = 10.2, leading: float = 12.4,
               font: str = "Helvetica", color: Color = INK,
               max_lines: int | None = None) -> float:
    lines = wrap(text, font, size, width)
    if max_lines is not None and len(lines) > max_lines:
        raise GuideError(f"Text needs {len(lines)} lines; maximum is {max_lines}: {text!r}")
    c.setFont(font, size)
    c.setFillColor(color)
    for line in lines:
        c.drawString(x, y, line)
        y -= leading
    return y


def arrow(c: canvas.Canvas, x1: float, y1: float, x2: float, y2: float,
          color: Color = GREEN) -> None:
    c.saveState()
    c.setStrokeColor(color)
    c.setFillColor(color)
    c.setLineWidth(2.8)
    c.line(x1, y1, x2, y2)
    angle = math.atan2(y2 - y1, x2 - x1)
    head = 7
    points = []
    for offset in (2.55, -2.55):
        points.append((x2 + head * math.cos(angle + offset), y2 + head * math.sin(angle + offset)))
    p = c.beginPath()
    p.moveTo(x2, y2)
    p.lineTo(*points[0])
    p.lineTo(*points[1])
    p.close()
    c.drawPath(p, fill=1, stroke=0)
    c.restoreState()


def label(c: canvas.Canvas, text: str, x: float, y: float, tx: float, ty: float) -> None:
    """Small callout with a leader; labels describe supplied content, never pinouts."""
    c.saveState()
    c.setStrokeColor(MUTED)
    c.setFillColor(white)
    c.setLineWidth(.7)
    c.circle(tx, ty, 2, fill=1, stroke=1)
    c.line(tx, ty, x, y - 2)
    lines = wrap(text, "Helvetica-Bold", 7.4, 84)
    box_w = min(88, max(stringWidth(line, "Helvetica-Bold", 7.4) for line in lines) + 8)
    box_h = len(lines) * 8.5 + 5
    c.roundRect(x - 3, y - box_h + 4, box_w, box_h, 3, fill=1, stroke=1)
    c.setFillColor(INK)
    c.setFont("Helvetica-Bold", 7.4)
    yy = y - 5
    for line in lines:
        c.drawString(x + 1, yy, line)
        yy -= 8.5
    c.restoreState()


def hand(c: canvas.Canvas, x: float, y: float, scale: float = 1, flip: bool = False) -> None:
    c.saveState()
    c.translate(x, y)
    c.scale(-scale if flip else scale, scale)
    c.setStrokeColor(INK)
    c.setFillColor(white)
    c.setLineWidth(1.3 / scale)
    p = c.beginPath()
    p.moveTo(0, 0); p.curveTo(10, 2, 17, 9, 22, 18)
    p.lineTo(33, 28); p.curveTo(36, 31, 33, 36, 29, 34)
    p.lineTo(21, 27); p.lineTo(29, 38); p.curveTo(31, 42, 26, 45, 23, 41)
    p.lineTo(16, 32); p.lineTo(22, 44); p.curveTo(24, 48, 19, 50, 16, 46)
    p.lineTo(10, 35); p.lineTo(14, 46); p.curveTo(15, 50, 10, 51, 8, 47)
    p.lineTo(2, 30); p.lineTo(-3, 17); p.close()
    c.drawPath(p, fill=1, stroke=1)
    c.restoreState()


def board(c: canvas.Canvas, x: float, y: float, w: float, h: float,
          kind: str = "board") -> None:
    c.saveState()
    c.setStrokeColor(INK); c.setFillColor(white); c.setLineWidth(1.4)
    c.roundRect(x, y, w, h, 5, fill=1, stroke=1)
    for px, py in ((x+8,y+8),(x+w-8,y+8),(x+8,y+h-8),(x+w-8,y+h-8)):
        c.circle(px, py, 2.5, fill=0, stroke=1)
    c.setFillColor(PALE)
    c.rect(x+w*.28, y+h*.28, w*.34, h*.38, fill=1, stroke=1)
    c.setFillColor(INK); c.setFont("Helvetica-Bold", 7)
    c.drawCentredString(x+w/2, y+h/2-2, kind.upper())
    c.restoreState()


def prop(c: canvas.Canvas, x: float, y: float, r: float = 28) -> None:
    c.saveState(); c.translate(x, y); c.setStrokeColor(INK); c.setFillColor(white); c.setLineWidth(1.2)
    c.circle(0, 0, 7, fill=1, stroke=1)
    for a in (0, 180):
        c.rotate(a)
        p = c.beginPath(); p.moveTo(6, 0); p.curveTo(r*.45, 8, r*.82, 9, r, 2)
        p.curveTo(r*.7, -3, r*.35, -4, 6, 0); p.close(); c.drawPath(p, fill=1, stroke=1)
    c.restoreState()


def draw_scene(c: canvas.Canvas, scene: str, x: float, y: float, w: float, h: float,
               labels: Iterable[str] = (), variant: str = "") -> None:
    """Draw a scene-specific action diagram inside the supplied bounds."""
    if scene not in SCENES:
        raise GuideError(f"Unknown scene {scene!r}")
    c.saveState(); c.translate(x, y)
    c.setStrokeColor(INK); c.setFillColor(white); c.setLineWidth(1.3)
    cx, cy = w/2, h/2
    # Physical assembly family.
    if scene in {"frame", "arm", "leg", "mount"}:
        c.roundRect(cx-42, cy-20, 84, 40, 6, fill=1, stroke=1)
        for a in (45, 135, 225, 315):
            rad = math.radians(a); ex, ey = cx+74*math.cos(rad), cy+48*math.sin(rad)
            c.setLineWidth(8); c.line(cx+30*math.cos(rad), cy+16*math.sin(rad), ex, ey)
            c.setLineWidth(1.3); c.circle(ex, ey, 11, fill=1, stroke=1)
        if scene == "arm":
            c.setDash(3,2); c.line(cx+38, cy+22, cx+92, cy+58); c.setDash()
            arrow(c, cx+95, cy+66, cx+55, cy+35)
        elif scene == "leg":
            c.line(cx-26,cy-20,cx-35,cy-58); c.line(cx+26,cy-20,cx+35,cy-58)
            c.line(cx-44,cy-58,cx-26,cy-58); c.line(cx+26,cy-58,cx+44,cy-58)
            hand(c, cx+48, cy-66, .65, True)
        elif scene == "mount":
            c.setDash(3,2); c.roundRect(cx-30,cy+34,60,30,4,fill=0,stroke=1); c.setDash()
            arrow(c,cx,cy+72,cx,cy+26)
        else:
            hand(c, cx-98, cy-58, .7)
            arrow(c,cx-68,cy-20,cx-43,cy-4)
    elif scene in {"screw", "motor"}:
        c.circle(cx, cy-8, 28, fill=1, stroke=1)
        for a in (0,90,180,270):
            rad=math.radians(a); c.circle(cx+19*math.cos(rad),cy-8+19*math.sin(rad),2.2,fill=0,stroke=1)
        if scene == "motor":
            c.rect(cx-22,cy-13,44,26,fill=1,stroke=1); c.ellipse(cx-22,cy+5,cx+22,cy+23,fill=1,stroke=1)
            prop(c,cx,cy+37,32); arrow(c,cx+46,cy+36,cx+18,cy+28)
        else:
            c.line(cx,cy+55,cx,cy+8); c.rect(cx-3,cy+48,6,26,fill=1,stroke=1)
            c.line(cx-15,cy+73,cx+15,cy+73); arrow(c,cx+35,cy+55,cx+8,cy+18); hand(c,cx-3,cy+40,.55)
    elif scene in {"stack", "pi", "gpio", "receiver", "gps"}:
        levels = 3 if scene == "stack" else 1
        for i in range(levels):
            board(c,cx-48,cy-42+i*24,96,42,scene if levels==1 else f"layer {i+1}")
            if i < levels-1:
                for dx in (-38,38): c.line(cx+dx,cy+i*24,cx+dx,cy+i*24+24)
        if scene == "gpio":
            for i in range(12): c.rect(cx-43+i*7,cy+6,3,10,fill=0,stroke=1)
            c.setDash(2,2); c.line(cx-58,cy+18,cx+58,cy+18); c.setDash()
        elif scene == "gps":
            c.circle(cx,cy+36,22,fill=1,stroke=1); c.line(cx-10,cy+36,cx+10,cy+36); c.line(cx,cy+26,cx,cy+46)
        elif scene == "receiver":
            c.line(cx-42,cy+4,cx-74,cy+54); c.line(cx+42,cy+4,cx+74,cy+54)
        arrow(c,cx+75,cy+45,cx+48,cy+17)
    elif scene == "camera":
        c.roundRect(cx-50,cy-30,100,60,8,fill=1,stroke=1); c.circle(cx,cy,20,fill=0,stroke=1); c.circle(cx,cy,9,fill=0,stroke=1)
        c.line(cx-34,cy-30,cx-45,cy-52); c.line(cx+34,cy-30,cx+45,cy-52)
        hand(c,cx+45,cy-62,.62,True); arrow(c,cx+70,cy-30,cx+43,cy-13)
    elif scene in {"connector", "wiring"}:
        c.rect(cx-83,cy-18,48,36,fill=1,stroke=1); c.rect(cx+35,cy-18,48,36,fill=1,stroke=1)
        count = 4 if scene == "wiring" else 2
        for i in range(count):
            yy=cy+(i-(count-1)/2)*9; c.line(cx-35,yy,cx+35,yy)
            if scene == "wiring": c.circle(cx-26,yy,2,fill=1,stroke=0)
        c.setFont("Helvetica-Bold",7); c.drawCentredString(cx-59,cy-3,"A"); c.drawCentredString(cx+59,cy-3,"B")
        c.setFont("Helvetica-Bold",7); c.drawCentredString(cx,cy+34,"FUNCTIONAL VIEW — NOT TO SCALE")
        arrow(c,cx-24,cy-38,cx+24,cy-38)
    elif scene in {"battery", "charger"}:
        c.roundRect(cx-76,cy-28,66,56,5,fill=1,stroke=1); c.setFont("Helvetica-Bold",8); c.drawCentredString(cx-43,cy-2,"BATTERY")
        c.line(cx-10,cy+8,cx+18,cy+8); c.line(cx-10,cy-8,cx+18,cy-8)
        c.roundRect(cx+18,cy-34,66,68,5,fill=1,stroke=1); c.rect(cx+30,cy+5,42,15,fill=0,stroke=1)
        c.setFont("Helvetica-Bold",8); c.drawCentredString(cx+51,cy-18,"CHARGER")
        arrow(c,cx-4,cy+43,cx+28,cy+31)
    elif scene in {"multimeter", "solder"}:
        if scene == "multimeter":
            c.roundRect(cx-35,cy-45,70,90,6,fill=1,stroke=1); c.rect(cx-24,cy+16,48,18,fill=0,stroke=1); c.circle(cx,cy-12,15,fill=0,stroke=1)
            c.line(cx-18,cy-45,cx-63,cy-67); c.line(cx+18,cy-45,cx+63,cy-67); c.circle(cx-64,cy-68,2,fill=1,stroke=0); c.circle(cx+64,cy-68,2,fill=1,stroke=0)
        else:
            board(c,cx-64,cy-34,100,60,"joint"); c.line(cx+76,cy+55,cx+16,cy-5); c.line(cx+74,cy+57,cx+83,cy+66); c.circle(cx+14,cy-7,5,fill=0,stroke=1)
            for i in range(3): c.arc(cx-2-i*8,cy+8+i*5,cx+22+i*8,cy+36+i*9,20,100)
            hand(c,cx+50,cy+33,.55,True)
        arrow(c,cx-84,cy+48,cx-43,cy+24)
    elif scene in {"print", "flow"}:
        if scene == "print":
            c.rect(cx-78,cy-48,156,82,fill=0,stroke=1); c.line(cx-60,cy+25,cx+60,cy+25); c.line(cx,cy+25,cx,cy-3)
            c.roundRect(cx-30,cy-34,60,32,4,fill=1,stroke=1); arrow(c,cx,cy+15,cx,cy-1)
        else:
            for i, name in enumerate(("INPUT","CHECK","ACTION")):
                xx=cx-92+i*92; c.roundRect(xx,cy-18,64,36,5,fill=1,stroke=1); c.setFont("Helvetica-Bold",7); c.drawCentredString(xx+32,cy-3,name)
                if i<2: arrow(c,xx+66,cy,xx+88,cy)
            c.setFont("Helvetica-Bold",7); c.drawCentredString(cx,cy+42,"FUNCTIONAL VIEW — NOT TO SCALE")
    elif scene in {"led", "screen"}:
        c.roundRect(cx-72,cy-47,144,94,7,fill=1,stroke=1); c.rect(cx-59,cy-32,118,64,fill=0,stroke=1)
        if scene == "led":
            for i,col in enumerate((GREEN,AMBER,INK)):
                c.setFillColor(col); c.circle(cx-35+i*35,cy,8,fill=1,stroke=1)
            c.setFillColor(INK)
        else:
            c.setFont("Helvetica-Bold",8); c.drawString(cx-48,cy+15,"STATUS"); c.line(cx-48,cy+5,cx+40,cy+5); c.line(cx-48,cy-8,cx+25,cy-8)
        hand(c,cx+68,cy-60,.55,True)
    elif scene in {"flight", "inspection"}:
        if scene == "flight":
            c.roundRect(cx-26,cy-12,52,24,4,fill=1,stroke=1)
            for a in (35,145,215,325):
                rad=math.radians(a); ex,ey=cx+58*math.cos(rad),cy+42*math.sin(rad); c.line(cx,cy,ex,ey); prop(c,ex,ey,18)
            c.setDash(3,2); c.line(cx-95,cy-57,cx+95,cy-57); c.setDash(); arrow(c,cx,cy-49,cx,cy-18)
        else:
            board(c,cx-54,cy-35,108,70,"ASSEMBLY")
            c.circle(cx+66,cy+30,27,fill=0,stroke=1); c.line(cx+86,cy+10,cx+111,cy-15); c.setLineWidth(4); c.line(cx+106,cy-20,cx+118,cy-8)
            c.setLineWidth(1.3); c.line(cx-85,cy+34,cx-70,cy+20); c.line(cx-70,cy+20,cx-43,cy+50)
    # Labels are supplied by content, so their meaning stays source-controlled.
    anchors = [(8,h-8,w*.25,h*.66),(w-92,h-8,w*.75,h*.64),(8,23,w*.28,h*.32),(w-92,23,w*.72,h*.30)]
    for item, (lx,ly,tx,ty) in zip(labels, anchors): label(c,str(item),lx,ly,tx,ty)
    if variant:
        c.setFillColor(MUTED); c.setFont("Helvetica-Oblique",7.2); c.drawRightString(w-4,4,str(variant))
    c.restoreState()


def image_box(c: canvas.Canvas, path: Path, x: float, y: float, w: float, h: float) -> None:
    if not path.is_file():
        raise GuideError(f"Image not found: {path}")
    image = ImageReader(str(path)); iw, ih = image.getSize()
    scale = min(w/iw, h/ih)
    dw, dh = iw*scale, ih*scale
    c.drawImage(image, x+(w-dw)/2, y+(h-dh)/2, dw, dh, preserveAspectRatio=True, mask="auto")


def validate(data: dict) -> None:
    for key in ("title", "subtitle", "edition", "pages"):
        if key not in data:
            raise GuideError(f"Missing top-level field: {key}")
    if not isinstance(data["pages"], list) or not data["pages"]:
        raise GuideError("pages must be a non-empty list")
    ids = set()
    for page in data["pages"]:
        for key in ("id", "chapter", "title", "status"):
            if not page.get(key): raise GuideError(f"Page missing {key}: {page}")
        if page["id"] in ids: raise GuideError(f"Duplicate page id: {page['id']}")
        ids.add(page["id"])
        if page["status"] not in VALID_STATUS: raise GuideError(f"Unknown status: {page['status']}")
        panels = page.get("panels", [])
        if len(panels) > 4: raise GuideError(f"Page {page['id']} has more than four panels")
        for panel in panels:
            if not panel.get("title") or not panel.get("text"):
                raise GuideError(f"Page {page['id']} panel needs title and text")
            if len(panel.get("labels", [])) > 4:
                raise GuideError(f"Page {page['id']} panel has more than four labels")
            if not panel.get("image") and panel.get("scene") not in SCENES:
                raise GuideError(f"Page {page['id']} panel has invalid scene")


class GuideRenderer:
    def __init__(self, data: dict, root: Path, output: Path):
        validate(data)
        self.data, self.root, self.output = data, root, output
        self.c = canvas.Canvas(str(output), pagesize=letter, pageCompression=1)
        self.c.setTitle(data["title"]); self.c.setAuthor("B.G.D project")
        self.page_no = 0
        self.toc_pages = max(1, math.ceil(len(data["pages"])/24))
        self.total = 1 + self.toc_pages + len(data["pages"])

    def footer(self, page: dict | None = None) -> None:
        c=self.c; c.setStrokeColor(HexColor("#D5D7D3")); c.line(MARGIN,30,PAGE_W-MARGIN,30)
        c.setFillColor(MUTED); c.setFont("Helvetica",7.5)
        left = self.data["edition"] if page is None else f"{page['chapter']}  |  {self.data['edition']}"
        c.drawString(MARGIN,18,left); c.drawRightString(PAGE_W-MARGIN,18,f"{self.page_no} / {self.total}")
        if page and page.get("sources"):
            refs="Sources: " + " · ".join(map(str,page["sources"]))
            if stringWidth(refs,"Helvetica",7.5) > 285: raise GuideError(f"Source IDs overflow on {page['id']}")
            c.drawCentredString(PAGE_W/2,18,refs)

    def cover(self) -> None:
        c=self.c; self.page_no+=1
        c.setFillColor(INK); c.rect(0,0,PAGE_W,PAGE_H,fill=1,stroke=0)
        c.setFillColor(GREEN); c.rect(MARGIN,PAGE_H-114,74,8,fill=1,stroke=0)
        c.setFillColor(white); c.setFont("Helvetica-Bold",30)
        y=text_block(c,self.data["title"],MARGIN,PAGE_H-168,PAGE_W-2*MARGIN,30,34,"Helvetica-Bold",white,3)
        y-=18; text_block(c,self.data["subtitle"],MARGIN,y,PAGE_W-2*MARGIN,14,18,"Helvetica",white,5)
        c.setFillColor(GREEN); c.roundRect(MARGIN,86,170,32,5,fill=1,stroke=0)
        c.setFillColor(white); c.setFont("Helvetica-Bold",10); c.drawString(MARGIN+12,98,self.data["edition"].upper())
        c.showPage()

    def toc(self) -> None:
        pages=self.data["pages"]
        for part in range(self.toc_pages):
            self.page_no+=1; c=self.c
            c.setFillColor(INK); c.setFont("Helvetica-Bold",24); c.drawString(MARGIN,PAGE_H-65,"Contents")
            c.setFillColor(MUTED); c.setFont("Helvetica",9); c.drawRightString(PAGE_W-MARGIN,PAGE_H-61,f"{part+1} / {self.toc_pages}")
            y=PAGE_H-98
            for i,page in enumerate(pages[part*24:(part+1)*24],part*24+1):
                target_page=1+self.toc_pages+i
                if stringWidth(page["title"],"Helvetica-Bold",10.5)>PAGE_W-2*MARGIN-95:
                    raise GuideError(f"Contents title is too wide on {page['id']}")
                c.setFillColor(PALE); c.roundRect(MARGIN,y-17,35,24,4,fill=1,stroke=0)
                c.setFillColor(INK); c.setFont("Helvetica-Bold",9); c.drawCentredString(MARGIN+17.5,y-8,str(i))
                c.setFont("Helvetica-Bold",10.5); c.drawString(MARGIN+48,y,page["title"])
                c.setFont("Helvetica",8); c.setFillColor(MUTED); c.drawString(MARGIN+48,y-12,page["chapter"])
                c.drawRightString(PAGE_W-MARGIN,y-3,str(target_page))
                c.linkAbsolute("",f"page-{page['id']}",(MARGIN,y-19,PAGE_W-MARGIN,y+9),thickness=0)
                y-=27
            self.footer(); c.showPage()

    def heading(self,page:dict) -> float:
        c=self.c; c.setFillColor(MUTED); c.setFont("Helvetica-Bold",8); c.drawString(MARGIN,PAGE_H-47,page["chapter"].upper())
        status=page["status"]; fill=AMBER if status=="HOLD" else INK
        tw=stringWidth(status,"Helvetica-Bold",8)+18; c.setFillColor(fill); c.roundRect(PAGE_W-MARGIN-tw,PAGE_H-57,tw,20,4,fill=1,stroke=0)
        c.setFillColor(white); c.setFont("Helvetica-Bold",8); c.drawCentredString(PAGE_W-MARGIN-tw/2,PAGE_H-50,status)
        if stringWidth(page["title"],"Helvetica-Bold",21)>PAGE_W-2*MARGIN-tw-12:
            raise GuideError(f"Page title is too wide on {page['id']}")
        c.setFillColor(INK); c.setFont("Helvetica-Bold",21); c.drawString(MARGIN,PAGE_H-80,page["title"])
        y=PAGE_H-101
        if page.get("intro"): y=text_block(c,page["intro"],MARGIN,y,PAGE_W-2*MARGIN,10.2,12.2,max_lines=2)
        if page.get("power"):
            c.setFillColor(AMBER_PALE); c.roundRect(MARGIN,y-18,PAGE_W-2*MARGIN,18,3,fill=1,stroke=0)
            c.setFillColor(INK); c.setFont("Helvetica-Bold",8.5); c.drawString(MARGIN+8,y-12,"POWER  "+str(page["power"])); y-=25
        if page.get("parts"):
            y=text_block(c,"PARTS  "+str(page["parts"]),MARGIN,y-1,PAGE_W-2*MARGIN,8.5,10,"Helvetica-Bold",MUTED,2)-3
        return y

    def page_callouts(self,page:dict) -> float:
        entries=[("CHECK",page.get("check"),GREEN_PALE,GREEN),("STOP",page.get("stop"),AMBER_PALE,AMBER)]
        entries=[e for e in entries if e[1]]
        if not entries: return 43
        width=(PAGE_W-2*MARGIN-(len(entries)-1)*8)/len(entries)
        for i,(name,text,fill,accent) in enumerate(entries):
            x=MARGIN+i*(width+8); c=self.c; c.setFillColor(fill); c.roundRect(x,39,width,40,5,fill=1,stroke=0)
            c.setFillColor(accent); c.rect(x,39,5,40,fill=1,stroke=0); c.setFillColor(INK); c.setFont("Helvetica-Bold",8); c.drawString(x+12,65,name)
            text_block(c,str(text),x+12,54,width-20,8.3,9.4,"Helvetica",INK,2)
        return 83

    def panels(self,page:dict,top:float,bottom:float) -> None:
        panels=page.get("panels",[]); n=len(panels)
        if not n: return
        cols=2 if n>1 else 1; rows=math.ceil(n/cols); gap=10
        pw=(PAGE_W-2*MARGIN-gap*(cols-1))/cols; ph=(top-bottom-gap*(rows-1))/rows
        if ph<205: raise GuideError(f"Panels do not fit on page {page['id']}")
        for i,panel in enumerate(panels):
            row,col=divmod(i,cols); x=MARGIN+col*(pw+gap); y=top-(row+1)*ph-row*gap
            c=self.c; c.setStrokeColor(HexColor("#B8BBB7")); c.setFillColor(white); c.roundRect(x,y,pw,ph,6,fill=1,stroke=1)
            c.setFillColor(INK); c.circle(x+20,y+ph-20,13,fill=1,stroke=0); c.setFillColor(white); c.setFont("Helvetica-Bold",11); c.drawCentredString(x+20,y+ph-24,str(i+1))
            c.setFillColor(INK); c.setFont("Helvetica-Bold",10.5); title=str(panel.get("title","Action"));
            if stringWidth(title,"Helvetica-Bold",10.5)>pw-58: raise GuideError(f"Panel title overflow on {page['id']}: {title}")
            c.drawString(x+42,y+ph-24,title)
            caption=wrap(str(panel.get("text","")),"Helvetica",10.2,pw-20)
            if len(caption)>4: raise GuideError(f"Panel caption overflow on {page['id']} panel {i+1}")
            cap_h=max(54,len(caption)*12.2+14); art_y=y+cap_h; art_h=ph-cap_h-41
            if art_h<92: raise GuideError(f"Panel art area too small on {page['id']}")
            if panel.get("image"):
                image_box(c,self.root/panel["image"],x+10,art_y+4,pw-20,art_h-8)
            else:
                draw_scene(c,panel["scene"],x+10,art_y+4,pw-20,art_h-8,panel.get("labels",[]),panel.get("variant",""))
            text_block(c,str(panel.get("text","")),x+10,y+cap_h-12,pw-20,10.2,12.2,max_lines=4)

    def reference(self,page:dict,top:float,bottom:float) -> None:
        c=self.c
        if page.get("image"):
            body=page.get("body",[])
            y=top
            for paragraph in body:
                y=text_block(c,str(paragraph),MARGIN,y,PAGE_W-2*MARGIN,10.2,13,max_lines=5)-8
            if y-bottom<100:
                raise GuideError(f"Image area is too short on {page['id']}; shorten body text")
            image_box(c,self.root/page["image"],MARGIN,y-(y-bottom),PAGE_W-2*MARGIN,y-bottom)
            return
        y=top
        for paragraph in page.get("body",[]):
            lines=wrap(str(paragraph),"Helvetica",10.2,PAGE_W-2*MARGIN)
            needed=len(lines)*13+11
            if y-needed<bottom: raise GuideError(f"Body overflow on {page['id']}; split it into another content page")
            y=text_block(c,str(paragraph),MARGIN,y,PAGE_W-2*MARGIN,10.2,13)-11
        for item in page.get("items",[]):
            name=str(item.get("name","")); detail=str(item.get("detail","")); lines=wrap(detail,"Helvetica",9.8,PAGE_W-2*MARGIN-120)
            h=max(34,len(lines)*11.5+12)
            if y-h<bottom: raise GuideError(f"Items overflow on {page['id']}; split them into another content page")
            c.setFillColor(PALE); c.roundRect(MARGIN,y-h+3,PAGE_W-2*MARGIN,h,4,fill=1,stroke=0)
            c.setFillColor(INK); c.setFont("Helvetica-Bold",9.8); c.drawString(MARGIN+10,y-13,name)
            text_block(c,detail,MARGIN+120,y-13,PAGE_W-2*MARGIN-130,9.8,11.5)
            y-=h+6

    def content_page(self,page:dict) -> None:
        self.page_no+=1; c=self.c
        c.bookmarkPage(f"page-{page['id']}",fit="Fit"); c.addOutlineEntry(page["title"],f"page-{page['id']}",0,False)
        top=self.heading(page); bottom=self.page_callouts(page)
        if page.get("panels"): self.panels(page,top,bottom)
        else: self.reference(page,top,bottom)
        self.footer(page); c.showPage()

    def render(self) -> None:
        self.cover(); self.toc()
        for page in self.data["pages"]: self.content_page(page)
        self.c.save()


def main() -> None:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--content",type=Path,default=Path("docs/hardware/guidebook/content.json"))
    parser.add_argument("--output",type=Path,default=Path("output/pdf/BGD-Hardware-Guidebook.pdf"))
    parser.add_argument("--root",type=Path,default=Path.cwd(),help="repository root for image paths")
    args=parser.parse_args()
    data=json.loads(args.content.read_text(encoding="utf-8"))
    args.output.parent.mkdir(parents=True,exist_ok=True)
    GuideRenderer(data,args.root.resolve(),args.output.resolve()).render()
    print(f"Rendered {args.output}")


if __name__ == "__main__":
    main()
