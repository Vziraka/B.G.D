// Pololu3418 VL53L7CX carrier, landscape orientation, positive M2 retention.
// mm. Local front=-Y; base bottom Z=0. PCB bottom15.5, rear Y=-3.
// 17.8mm board dimension runs X; 12.7mm dimension runs Z.
$fn=48;
plate=2.5;
hole_pitch=12.7; // official 0.5 inch mounting centers
hole_z=18; // PCB lower edge15.5 + documented2.5 hole offset
boss_depth=3;
hole=2.3;
module along_y(d,h) { rotate([-90,0,0]) cylinder(d=d,h=h); }
module forward_depth_bracket() {
 difference() {
  union() {
   translate([-11,0,0]) cube([22,26,plate]);
   for(x=[-hole_pitch/2,hole_pitch/2]) {
    translate([x-2.5,0,0]) cube([5,plate,hole_z+2.5]);
    translate([x,-boss_depth,hole_z]) along_y(4,boss_depth+0.1);
    hull() {
     translate([x-2.5,0,0]) cube([5,plate,12]);
     translate([x-2.5,11,0]) cube([5,plate,plate]);
    }
   }
  }
  for(x=[-hole_pitch/2,hole_pitch/2])
   translate([x,-boss_depth-0.1,hole_z]) along_y(hole,boss_depth+plate+0.2);
  for(x=[-6,6]) hull()
   for(y=[14,23])
    translate([x,y,-0.1]) cylinder(d=4,h=plate+0.2);
 }
}
assert(hole_pitch==12.7 && hole>2 && hole<4);
assert(hole_z>12+hole/2);
forward_depth_bracket();
