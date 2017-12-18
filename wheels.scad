include <main.scad>;

for(side=[left,right]) {
  translate([side*wheel_diam*0.7,0,0]) {
    translate([0,front*wheel_diam*0.7,0]) {
      driven_wheel();
    }
    translate([0,rear*wheel_diam*0.70,0]) {
      idler_wheel();
    }
  }
}
