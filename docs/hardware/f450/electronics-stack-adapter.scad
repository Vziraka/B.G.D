// Original MicoAir743/50A stack FIT PROTOTYPE, millimetres.
// https://micoair.com/flightcontroller_micoair743/
// Preserve supplied silicone grommets; this adapter is NOT an isolator.
$fn=48;
pitch=30.5;
base=2.5;
head_gap=3.5; // underside bolt heads must leave >=0.5 mm electrical clearance
assert(pitch==30.5 && base>=2.5 && head_gap>=3.5);
module outline(){
 difference(){
  square([48,64],center=true);
  square([23,23],center=true);
  // Remove material outside the screw load paths and between tie feet.
  for(x=[-21,21]) translate([x,0]) square([6.1,22],center=true);
  for(y=[-27,27]) translate([0,y]) square([14,12],center=true);
  for(x=[-pitch/2,pitch/2],y=[-pitch/2,pitch/2])
   translate([x,y]) circle(d=3.4);
  // Four separated lashing passages outside electronics footprint.
  for(x=[-15,15],y=[-27,27])
   translate([x,y]) square([8,4],center=true);
 }
}
// Print feet downward: underside gap keeps metal off the power board.
translate([0,0,head_gap]) linear_extrude(base) outline();
for(x=[-21,21],y=[-25,25])
 translate([x-3,y-5,0]) cube([6,10,head_gap+0.05]);
