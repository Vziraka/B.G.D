// B.G.D battery end-stop pair, FIT PROTOTYPE, mm, 2026-09-22.
// Original project design. See battery-design.md for routing and limits.
// Print feet down; install feet against underside of lower plate, fingers DOWN.
// Stops carry fore/aft restraint only. Two existing straps carry battery weight.
view = "print"; // "assembly" shows nominal battery as non-exported context
battery_length = 141;
battery_width = 49;
battery_height = 50.5;
side_clear = 54;
foot_width = 7;
foot_length = 24;
wall = 3;
height = 18;
base = 2.5;
$fn=32;
assert(battery_length>=137 && battery_length<=160);
assert(battery_width>=44 && battery_width<=51);
assert(battery_height>=31 && battery_height<=53);
assert(side_clear-battery_width>=3);

module stop() {
    difference() {
        union() {
            // End web lies outside the pack end; central cable opening above it.
            translate([-34,-wall,0]) cube([68,wall,base]);
            for(s=[-1,1]) {
                translate([s*30.5-foot_width/2,-wall,0])
                    cube([foot_width,foot_length+wall,base]);
                translate([s*22-12,-wall,0]) cube([24,wall,height]);
                // Triangular brace beside pack; no shelf underneath its wrapper.
                translate([s*33.2-0.7,0,0])
                    rotate([90,0,90]) linear_extrude(1.4)
                        polygon([[0,0],[12,0],[0,height]]);
            }
        }
        // Closed adjustable lashing slots; two opposed tethers per foot.
        for(s=[-1,1]) for(y=[6,18])
            translate([s*30.5,y,-1])
                linear_extrude(base+2) hull() {
                    translate([0,-2]) circle(d=3.8);
                    translate([0,2]) circle(d=3.8);
                }
    }
}
if(view=="assembly") {
    translate([0,-battery_length/2,0]) rotate([180,0,180]) stop();
    translate([0,battery_length/2,0]) rotate([180,0,0]) stop();
    %translate([-battery_width/2,-battery_length/2,-battery_height-2])
        cube([battery_width,battery_length,battery_height]);
} else {
    stop();
    translate([0,36,0]) stop();
}
