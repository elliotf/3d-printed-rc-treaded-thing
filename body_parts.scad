include <main.scad>;

for(side=[left,right]) {
  translate([-side*(servo_width/2+wall_thickness*2),0,overall_width/2]) {
    rotate([0,-side*90,0]) {
      body_side(side);
    }
  }
}
