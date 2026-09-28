// B.G.D Pi 5 carrier + frame-lashing FIT PROTOTYPE, mm, 2026-09-22.
// OpenSCAD source. Compilation status is maintained in the handoff.
// Pi reference: https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf
// X = across board, Y = along board; origin = mounting-pattern center.
// This is NOT the asymmetric PCB-outline center.
// Broad feet/tie tunnels use approximate photo-derived frame ranges.
// No flight qualification; buckle heads go BELOW the frame plate.

pitch_x = 49;          // documented mounting centers
pitch_y = 58;
rail = 8;             // draft structural choice, not load-qualified
thickness = 2.5;
clearance_d = 2.8;     // trial clearance for M2.5, tune to physical print
travel_y = 2;         // total slot adjustment: +/-1 mm from nominal
foot_outer_y = 39;    // photo-based choice, support envelope +/-39
tie_x = 9;           // two flexible lashing routes per end, X +/-9
tie_clear_width = 4; // ordered ties nominal 3 wide; 1 total allowance
tie_clear_height = 2;// assumed body clearance, actual tie passage TBD
guide_wall = 1.5;
guide_roof = 1.2;
foot_lift = 4.5;      // 6 mm male thread - 2.5 mm plate + 1 mm nominal gap
foot_depth_contact = 4;
$fn = 48;

outer_x = pitch_x + rail;
outer_y = pitch_y + rail;
inner_x = pitch_x - rail;
inner_y = pitch_y - rail;

assert(pitch_x > rail && pitch_y > rail && thickness > 0);
assert(clearance_d > 2.5 && travel_y >= 0);
assert(rail > clearance_d + travel_y, "Slot must remain inside rail");
assert(foot_outer_y >= outer_y/2);
assert(tie_clear_width > 3 && tie_clear_height > 0);
assert(tie_x - tie_clear_width/2 - guide_wall > 0);
assert(tie_x + tie_clear_width/2 + guide_wall < pitch_x/2 - clearance_d/2,
       "Tie guides must not cover Pi standoff holes");

// One continuous base: open ring plus broad end extensions.
translate([0,0,foot_lift]) {
linear_extrude(height = thickness)
    difference() {
        square([outer_x, 2*foot_outer_y], center = true);
        square([inner_x, inner_y], center = true);
        // Feet and ring share width; no fragile projecting side tabs.
        for (x = [-pitch_x/2, pitch_x/2])
            for (y = [-pitch_y/2, pitch_y/2])
                hull() {
                    translate([x, y-travel_y/2]) circle(d = clearance_d);
                    translate([x, y+travel_y/2]) circle(d = clearance_d);
                }
    }

// Four tunnels physically capture each tie along the top of an end foot.
// Feed tie along Y, down outer frame slot, under plate web, up inner slot.
// Tunnel ends are open; no exact frame hole coincidence is required.
foot_depth = foot_outer_y - inner_y/2;
for (x = [-tie_x, tie_x])
    for (s = [-1, 1])
        translate([x, s*(inner_y/2 + foot_depth/2), thickness])
            difference() {
                translate([0, 0, (tie_clear_height+guide_roof)/2])
                    cube([tie_clear_width+2*guide_wall, foot_depth,
                          tie_clear_height+guide_roof], center=true);
                translate([0, 0, tie_clear_height/2-0.01])
                    cube([tie_clear_width, foot_depth+0.2,
                          tie_clear_height+0.02], center=true);
            }
}

// Two bearing rails lift all four standoff threads/nuts off the frame.
// Contact rails are outside Y +/-29 standoff positions; tie passages remain open.
for (s=[-1,1])
    translate([-outer_x/2, s*36.5-foot_depth_contact/2, 0])
        cube([outer_x, foot_depth_contact, foot_lift+0.05]);
