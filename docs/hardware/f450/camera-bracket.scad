// Camera Module 3 STANDARD, positive M2 retention, preliminary fit part.
// mm. Local front=-Y; base bottom Z=0. PCB bottom Z=14, rear face Y=-3.
// Sources and hardware: camera-design.md. No frame/flight qualification.
$fn=48;
plate=2.5;
pcb_bottom=14;
mount_pitch_x=21; // official 25 mm PCB, holes 2 mm from each side
mount_pitch_z=12.5; // official hole heights 2 and 14.5 above PCB bottom
boss_depth=3;
hole=2.3; // prototype M2 print clearance, PCB holes remain untouched
slot_width=4; // ordered tie nominal 3 mm
slot_travel=12;

module along_y(d,h) { rotate([-90,0,0]) cylinder(d=d,h=h); }
module camera_bracket() {
 difference() {
  union() {
   translate([-15,0,0]) cube([30,30,plate]);
   // Two rails leave the rear connector/central components uncovered.
   for(x=[-mount_pitch_x/2,mount_pitch_x/2]) {
    translate([x-2.5,0,0]) cube([5,plate,pcb_bottom+16.5]);
    for(z=[pcb_bottom+2,pcb_bottom+2+mount_pitch_z])
     translate([x,-boss_depth,z]) along_y(4,boss_depth+0.1);
    // Low buttress stays below the lower fastener row.
    hull() {
     translate([x-2.5,0,0]) cube([5,plate,12]);
     translate([x-2.5,12,0]) cube([5,plate,plate]);
    }
   }
  }
  for(x=[-mount_pitch_x/2,mount_pitch_x/2])
   for(z=[pcb_bottom+2,pcb_bottom+2+mount_pitch_z])
    translate([x,-boss_depth-0.1,z]) along_y(hole,boss_depth+plate+0.2);
  // Two long tie slots give routing adjustment on the actual frame openings.
  for(x=[-8,8]) hull()
   for(y=[15,15+slot_travel])
    translate([x,y,-0.1]) cylinder(d=slot_width,h=plate+0.2);
  // Central relief avoids both side buttresses and leaves 3 mm to tie slots.
  hull() for(y=[8,22])
   translate([0,y,-0.1]) cylinder(d=6,h=plate+0.2);
 }
}
assert(hole>2 && hole<4);
assert(pcb_bottom+2>12+hole/2); // buttress clear of screw/nut access
camera_bracket();
