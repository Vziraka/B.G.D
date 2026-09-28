// MTF-01P intact-case cradle FIT PROTOTYPE, mm; X right, Y forward.
// Primary: https://micoair.cn/zh/docs/sensors/sensors/mtf-01p-sensors
// Keep factory case screws. Two purchased 150x3 ties retain end bands.
// Print flat; installed +Z points DOWN. Sensor rear rests on open ring.
$fn=48;
sensor_x=65;
t=2.5;
body_x=20.8;
body_y=33.2;
clearance=1; // total allowance, NOT a verified manufacturing tolerance
stop_height=3;
inner_x=(body_x+clearance)/2;
inner_y=(body_y+clearance)/2;
tie_y=13.5; // photo-inferred clear end bands; inspect optics on installation
assert(sensor_x>=65 && clearance>=1 && t>=2.5);
assert(tie_y-2>=11.5, "Keep center optical zone unobstructed");
module frame(){
 difference(){
  translate([sensor_x,0]) square([32,38],center=true);
  translate([sensor_x,0]) square([17,26],center=true);
 }
}
difference(){
 union(){
  linear_extrude(t) union(){
   translate([41,0]) square([24,36],center=true);
   frame();
  }
  // Four low L corners locate the case; center side stays open for cable.
  for(s=[-1,1]){
   translate([sensor_x-inner_x-1.5,s*(inner_y+0.75)-0.75,t])
    cube([2*inner_x+3,1.5,stop_height]);
   for(q=[-1,1])
    translate([sensor_x+q*(inner_x+0.75)-0.75,s*(inner_y-0.8)-2.3,t])
     cube([1.5,4.6,stop_height]);
  }
 }
 // Two independent sensor tie loops across case short dimension.
 for(x=[sensor_x-13,sensor_x+13],y=[-tie_y,tie_y])
  translate([x-1.5,y-2,-0.1]) cube([3,4,t+0.2]);
 // Separate frame-root lashing. Keep heads/wires away from sensor optics.
 for(y=[-11,11]) translate([36,y,-0.1]) linear_extrude(t+0.2)
  square([4,8],center=true);
 translate([44,0,-0.1]) linear_extrude(t+0.2) square([10,12],center=true);
}
