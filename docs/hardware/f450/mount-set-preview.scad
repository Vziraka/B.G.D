// Display layout, NOT a slicer plate or fabrication STL. All dimensions mm.
$fn=48;
module label(s,p){color("#25364a") translate(p) linear_extrude(0.3) text(s,size=5,halign="center");}
color("#407cbf") translate([-75,48,0]) import("pi-carrier-core-draft.stl");
label("Pi carrier",[-75,0,0]);
color("#eea548") translate([10,60,0]) import("camera-bracket.stl");
label("Camera",[10,45,0]);
color("#4da998") translate([55,60,0]) import("forward-depth-bracket.stl");
label("Forward depth",[60,45,0]);
color("#bf675c") translate([-70,-83,0]) import("battery-end-stops.stl");
label("Battery stops",[-70,-96,0]);
color("#8474b1") translate([10,-43,0]) import("electronics-stack-adapter.stl");
label("Flight stack",[10,-85,0]);
color("#5f9170") translate([40,-45,0]) import("electronics-flow-support.stl");
label("Downward sensor",[93,-85,0]);
