include <util.scad>;

resolution = 32;
wheel_res  = 96;
spacer     = 1;
pi         = 3.14159;
extrusion_width  = 0.4;
extrusion_height = 0.2;

servo_width  = 13;
servo_length = 23;
servo_length_with_flanges = 33;
servo_flange_length = (servo_length_with_flanges - servo_length) /2;
servo_height = 23.5;
servo_pinion_shoulder_height = 4.5;
servo_pinion_shoulder_diam   = servo_width;
servo_pinion_shoulder_smaller_diam   = 6;
servo_flange_shoulder_height = 4.5;
servo_flange_thickness       = 3;
servo_arm_diam   = 8;
servo_arm_height = 2;

rx_board_width  = 22;
rx_board_length = 41;
rx_board_height = 7;
rx_board_pin_area = 10;
rx_board_pin_height = 15;

bearing_outer = 6;
bearing_inner = 3;
bearing_thickness = 2.5;

battery_width = 28;
battery_length = 42;
battery_thickness = 8;

belt_diam = 151;
belt_teeth = 20;
belt_pitch = (belt_diam / belt_teeth);
wheel_teeth = 8;
wheel_circumference = wheel_teeth * belt_pitch;
wheel_diam = wheel_circumference / pi;
wheel_width = 13.5;
wheel_supported_width = bearing_thickness*3;
wheelbase = (belt_diam - wheel_circumference) / 2;

echo("BELT PITCH: ", belt_pitch);
echo("WHEEL DIAM: ", wheel_diam);

//servo_pos_y = servo_length/2 + servo_flange_length/2 + spacer/2;
servo_pos_x = servo_height/2;
servo_pos_y = wheelbase/2;
//wheelbase = servo_pos_y*2;

module servo() {
  translate([0,-servo_length/2+servo_pinion_shoulder_diam/2,0]) {
    // flanges
    hull() {
      translate([0,0,-servo_flange_shoulder_height-servo_flange_thickness/2]) {
        cube([servo_width,servo_length_with_flanges,servo_flange_thickness],center=true);
      }
      translate([0,0,-servo_height+servo_flange_shoulder_height+servo_flange_thickness/2]) {
        cube([servo_width,servo_length_with_flanges,servo_flange_thickness],center=true);
      }
    }

    for(side=[left,right]) {
      translate([0,side*(servo_length_with_flanges/2-servo_flange_length/2),-servo_flange_shoulder_height]) {
        hole(1.75,servo_flange_thickness*2,6);
      }
    }

    // main body
    translate([0,0,-servo_height/2]) {
      cube([servo_width,servo_length,servo_height],center=true);
    }

    // pinion shoulder(s)
    translate([0,servo_length/2-servo_pinion_shoulder_diam/2,0]) {
      hole(4.75, servo_pinion_shoulder_height*2+6, resolution);
      hull() {
        hole(servo_pinion_shoulder_diam, servo_pinion_shoulder_height*2, resolution);
        translate([0,-servo_pinion_shoulder_diam/2,0]) {
          hole(servo_pinion_shoulder_smaller_diam, servo_pinion_shoulder_height*2, resolution);
        }
      }
    }

  }
}

module rx_board() {
  cube([rx_board_width,rx_board_length,rx_board_height],center=true);

  translate([0,-rx_board_length/2+rx_board_pin_area/2,rx_board_pin_height/2]) {
    cube([rx_board_width,rx_board_pin_area,rx_board_pin_height],center=true);
  }
}

module cavities() {
  translate([0,0,servo_width/2 + rx_board_height/2 + 2 ]) {
    rx_board();
  }

  translate([servo_pos_x,servo_pos_y,0]) {
    rotate([0,90,0]) {
      servo();
    }
  }

  translate([-servo_pos_x,-servo_pos_y,0]) {
    rotate([0,90,0]) {
      rotate([180,0,0]) {
        servo();
      }
    }
  }
}

module outer_shell() {
}

module main_body() {
  difference() {
    cavities();
  }
}

module wheel() {
  tooth_width    = 5;
  tooth_height   = 6;
  sidewall_width = (wheel_width - tooth_width)/2;
  inner_diam     = wheel_diam - tooth_height;

  module profile() {
    for(side=[left,right]) {
      hull() {
        translate([wheel_diam/4,side*(wheel_width/2-sidewall_width/2)]) {
          square([wheel_diam/2,sidewall_width], center=true);
        }

        translate([inner_diam/4,side*1,0]) {
          square([inner_diam/2,2],center=true);
        }
      }
    }
  }

  module wheel_body() {
    degrees = 360 / wheel_teeth;

    rotate_extrude($fn=wheel_res,convexity=10) {
      profile();
    }

    // Ribs to grip teeth. Probably YAGNI based on friction with rubber track
    for(i=[0:wheel_teeth-1]) {
      rotate([0,0,degrees*i+degrees/2]) {
        translate([0, wheel_diam/4,0]) {
          cube([extrusion_width*2, wheel_diam/2-0.05,wheel_width],center=true);
        }
      }
    }
  }

  module wheel_holes() {
    // coned opening
    hull() {
      translate([0,0,-wheel_supported_width]) {
        hole(bearing_outer, wheel_width, 32);
      }
      translate([0,0,-wheel_width/2]) {
        hole(wheel_diam - extrusion_width*4*2, 1, wheel_res);
      }
    }
  }

  difference() {
    wheel_body();
    wheel_holes();
  }
}

module driven_wheel() {
  module arm_cavity() {
    arm_width = 4.5;
    rounded_diam = 3;
    linear_extrude(height=bearing_thickness*2,center=true,convexity=2) {
      intersection() {
        accurate_circle(wheel_diam-3,wheel_res);

        difference() {
          square([22,22],center=true);

          union() {
            for(i=[0:3]) {
              rotate([0,0,i*90]) {
                hull() {
                  translate([arm_width/2+rounded_diam/2,arm_width/2+rounded_diam/2,0]) {
                    accurate_circle(3,16);
                  }
                  translate([arm_width/2+10,arm_width+10,0]) {
                    square([20,20], center=true);
                  }
                  translate([arm_width+10,arm_width/2+10,0]) {
                    square([20,20], center=true);
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  difference() {
    wheel();

    translate([0,0,wheel_width/2-1.5+extrusion_height]) {
      hole(2.5, bearing_thickness*2, 16);
    }
    translate([0,0,-bearing_thickness-1.5]) {
      hole(bearing_outer, wheel_width, 32);
    }

    translate([0,0,wheel_width/2]) {
      arm_cavity();
    }
  }
}

module idler_wheel() {
  difference() {
    wheel();

    translate([0,0,wheel_width/2]) {
      hole(bearing_outer, bearing_thickness*2, 16);

      translate([0,0,extrusion_height]) {
        hole(bearing_outer-3, bearing_thickness*4, 16);
      }
    }

    translate([0,0,wheel_width/2-wheel_supported_width]) {
      hole(bearing_outer, bearing_thickness*2, 16);
    }
  }
}

module debug() {
  // driven_wheel();
}

translate([servo_height,0,0]) {
  //% cube([1,wheelbase,1],center=true);
}

translate([0,0,servo_height*2]) {
  // servo();
}
