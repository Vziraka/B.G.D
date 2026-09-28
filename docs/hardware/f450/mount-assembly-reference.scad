// Proposed layout ONLY. Frame surfaces/component boxes are approximate references.
// +Y front, +X right, Z0 top of lower plate. Do NOT fabricate this assembly.
use <battery-end-stops.scad>
$fn=48;
color([0.3,0.35,0.4,0.22]) translate([-48,-90,-2]) cube([96,180,2]);
color([0.3,0.35,0.4,0.22]) translate([-49,-49,38]) cube([98,98,2]);
color("#407cbf") translate([0,0,40]) import("pi-carrier-core-draft.stl");
// Pi PCB only; cooler, connectors and wiring deliberately not claimed modeled.
color([0.1,0.5,0.3,0.45]) translate([-28,-32.5,58]) cube([56,85,1.6]);
for(x=[-24.5,24.5],y=[-29,29]) color("silver") translate([x,y,47]) cylinder(d=5,h=11);
color("#8474b1") import("electronics-stack-adapter.stl");
color([0.3,0.4,0.6,0.3]) translate([-18,-18,6]) cube([36,36,27]);
color("#eea548") translate([-15,75,0]) rotate([0,0,180]) import("camera-bracket.stl");
color("#4da998") translate([15,75,0]) rotate([0,0,180]) import("forward-depth-bracket.stl");
color("#5f9170") translate([0,0,-2]) rotate([180,0,0]) import("electronics-flow-support.stl");
color([0.15,0.2,0.3,0.5]) translate([54.6,-16.6,-21.3]) cube([20.8,33.2,16.8]);
// Maximum candidate envelope, NOT evidence of an ordered battery.
color([0.3,0.3,0.3,0.4]) translate([-25.5,-80,-57]) cube([51,160,53]);
color("#bf675c") translate([0,-80,-2]) rotate([180,0,180]) stop();
color("#bf675c") translate([0,80,-2]) rotate([180,0,0]) stop();
