include <util.scad>;

// rear drive servo: channel 1
// front drive servo: channel 2
// arm servo: channel 3

resolution = 32;
wheel_res  = 96;
spacer     = 1;
pi         = 3.14159;
extrusion_width  = 0.4;
wall_thickness   = extrusion_width*4;
extrusion_height = 0.2;
rounded_diam = extrusion_width*8;

lego_peg = 1.6*5; // 1.6 is the lego unit, a 1x1 brick is 5 units (evidently)
minifig_area_x = lego_peg*2;
minifig_area_y = lego_peg*2;
minifig_area_z = 50;

clamp_nut_diam = 5.7; // 5.5 m3 nut + fudge
clamp_screw_diam = 3.5; // 3mm screw + fudge

m3_thread_diam = 2.7;

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

rx_board_width  = 21.5;
rx_board_length = 41;
rx_board_height = 7;
rx_board_pin_area = 10;
rx_board_pin_height = 15;

bearing_outer = 6.1;
bearing_inner = 3;
bearing_thickness = 2.5;

battery_width = 28.5;
battery_length = 42;
battery_thickness = 9.25;

belt_diam = 151;
belt_teeth = 20;
belt_pitch = (belt_diam / belt_teeth);
wheel_teeth = 9;
wheel_circumference = wheel_teeth * belt_pitch;
wheel_diam = wheel_circumference / pi;
wheel_width = 13.5;
wheel_supported_width = bearing_thickness*3;
wheelbase = (belt_diam - wheel_circumference) / 2 + 0.5;

overall_width = servo_height + servo_pinion_shoulder_height*2 - 0.1;

rx_board_cavity_width  = overall_width - wall_thickness*2;
rx_board_cavity_height = rx_board_width;
rx_board_cavity_length = rx_board_length;

echo("RX CAVITY WIDTH: ", rx_board_cavity_width);
echo("RX CAVITY HEIGHT: ", rx_board_cavity_height);

echo("BELT PITCH: ", belt_pitch);
echo("WHEEL DIAM: ", wheel_diam);
echo("WHEELBASE: ", wheelbase);

//servo_pos_y = servo_length/2 + servo_flange_length/2 + spacer/2;
servo_pos_x = servo_height/2;
servo_pos_y = wheelbase/2-0.25;
//wheelbase = servo_pos_y*2;

rear_clamp_pos_x = 0;
rear_clamp_pos_z = 0;

arm_servo_pos_y = -servo_pos_y-servo_flange_length - wall_thickness*2 - servo_width/2;
arm_servo_pos_z = servo_width/2 + wall_thickness + servo_flange_length + servo_length/2 + servo_pinion_shoulder_diam/2;

body_top_z  = arm_servo_pos_z + servo_pinion_shoulder_diam/2 + servo_flange_length;
body_rear_y = rear_clamp_pos_y - clamp_nut_diam/2 - rounded_diam/2;
body_rear_y = arm_servo_pos_y - servo_width/2 - wall_thickness;

//rear_clamp_pos_y = -servo_pos_y-servo_pinion_shoulder_diam/2 - servo_flange_length - clamp_nut_diam;
rear_clamp_pos_y = body_rear_y + clamp_nut_diam/2 + rounded_diam/2;

battery_pos_z = servo_width/2 + wall_thickness*3 + battery_length/2;
battery_pos_y = arm_servo_pos_y + servo_width/2 + wall_thickness*2 + battery_thickness/2;

rx_board_pos_x = overall_width/2 - wall_thickness - rx_board_height/2;
rx_board_pos_y = servo_pos_y + servo_pinion_shoulder_diam/2 + servo_flange_length - rx_board_length/2 - clamp_nut_diam/2;
rx_board_pos_y = battery_pos_y + battery_thickness/2 + wall_thickness + rx_board_length/2;
// rx_board_pos_y = battery_pos_y + battery_thickness/2 + wall_thickness*2 + rx_board_length/2;
rx_board_pos_z = servo_width/2 + wall_thickness + rx_board_width/2;

rx_board_cavity_pos_x = 0;
rx_board_cavity_pos_y = rx_board_pos_y;
rx_board_cavity_pos_z = rx_board_pos_z;

front_clamp_pos_x = rear_clamp_pos_x;
//front_clamp_pos_y = rx_board_pos_y + rx_board_length/2;
//front_clamp_pos_y = servo_pos_y + servo_pinion_shoulder_diam/2 + servo_flange_length;
front_clamp_pos_y = servo_pos_y + servo_pinion_shoulder_diam/2 + servo_flange_length + wall_thickness + clamp_nut_diam/2;
//front_clamp_pos_z = servo_width/2 + wall_thickness + rx_board_height; // + (clamp_nut_diam + rounded_diam)/2;
//front_clamp_pos_z = rx_board_pos_z + rx_board_height/2 + clamp_nut_diam/2;
//front_clamp_pos_z = rx_board_pos_z;
front_clamp_pos_z = 0; //servo_width/2 - wall_thickness; // + wall_thickness + clamp_nut_diam/2;

minifig_pos_x = 0;
minifig_pos_y = rx_board_pos_y - rx_board_length/2 + rx_board_pin_area + wall_thickness + minifig_area_y/2;
minifig_pos_z = rx_board_pos_z + rx_board_height/2 + wall_thickness + minifig_area_z/2;

module duplo_hook_area() {
  duplo_hook_diam = 6.9;
}

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

    // servo screw down holes
    for(side=[left,right]) {
      translate([0,side*(servo_length_with_flanges/2-servo_flange_length/2),-servo_flange_shoulder_height]) {
        hole(1.75,servo_flange_thickness*5,6);
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
  // main board
  cube([rx_board_width,rx_board_length,rx_board_height],center=true);

  // pin area
  translate([0,-rx_board_length/2+rx_board_pin_area/2,-rx_board_height/2+rx_board_pin_height/2]) {
    cube([rx_board_width,rx_board_pin_area,rx_board_pin_height],center=true);
  }

  // antenna
}

module rx_board_cavity() {
  antenna_hole_width = 2;
  antenna_hole_height = 4;

  rear_height = body_top_z-rx_board_cavity_pos_z;

  hull() {
    translate([0,0,-wall_thickness/4]) {
      cube([rx_board_cavity_width,rx_board_cavity_length,rx_board_cavity_height-wall_thickness/2],center=true);
    }

    translate([0,-rx_board_cavity_length/2+0.05,rear_height/2-wall_thickness/4]) {
      cube([rx_board_cavity_width,0.1,rear_height-wall_thickness/2],center=true);
    }
  }

  // if we're mounting it sideways
  for (side=[left,right]) {
    translate([side*(rx_board_cavity_width/2-antenna_hole_height/2),rx_board_cavity_length-1,0]) {
      cube([antenna_hole_height,rx_board_cavity_length,antenna_hole_width],center=true);
    }
  }

  // if we're mounting it on the bottom
  translate([0,rx_board_cavity_length-1,-rx_board_cavity_height/2+antenna_hole_height/2]) {
    cube([antenna_hole_width,rx_board_cavity_length,antenna_hole_height],center=true);
  }
}

module minifig_area() {
  cube([minifig_area_x,minifig_area_y,minifig_area_z],center=true);
}

module cavities() {
  translate([rx_board_pos_x, rx_board_pos_y, rx_board_pos_z]) {
    rotate([0,-90,0]) {
      // rx_board();
    }
  }

  translate([rx_board_cavity_pos_x, rx_board_cavity_pos_y, rx_board_cavity_pos_z]) {
    rx_board_cavity();
  }

  // front servo
  translate([servo_pos_x,servo_pos_y,0]) {
    rotate([0,90,0]) {
      servo();

      // axle hole for opposite side
      hole(m3_thread_diam, overall_width*2, 8);
    }
  }

  // rear servo
  translate([-servo_pos_x,-servo_pos_y,0]) {
    rotate([0,90,0]) {
      rotate([180,0,0]) {
        servo();
      }

      // axle hole for opposite side
      hole(m3_thread_diam, overall_width*2, 8);
    }
  }

  // arm servo
  translate([servo_pos_x,arm_servo_pos_y,arm_servo_pos_z]) {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        servo();

        hole(2.5, overall_width*2, 8);
      }
    }
  }

  // battery
  battery_cable_hole_width = 3;
  battery_cable_hole_depth = 1.5;
  translate([0,battery_pos_y,battery_pos_z]) {
    rotate([90,0,0]) {
      battery();
    }

    // smooth area for cables
    translate([0,0,-battery_length/2-wall_thickness]) {
      rotate([0,0,90]) {
        round_a_square(battery_thickness+wall_thickness*2,14);
      }
    }

    // room for cable between rx board and battery
    translate([battery_cable_hole_width/2,battery_thickness,battery_length/4]) {
      cube([battery_cable_hole_width,battery_cable_hole_depth,battery_length/2],center=true);
    }
  }

  // rx board access
  translate([0,rx_board_pos_y-rx_board_length/2+rx_board_pin_area/2,rx_board_pos_z+rx_board_pin_height*0.75+10]) {
    // cube([overall_width+1,rx_board_pin_area,20.5],center=true);
  }

  translate([minifig_pos_x,minifig_pos_y,minifig_pos_z]) {
    // % minifig_area();
  }

  // cable clearances for arm servo
  translate([0,arm_servo_pos_y+servo_width/2,arm_servo_pos_z+servo_pinion_shoulder_diam/2-servo_length/2]) {
    cube([14,wall_thickness*2,servo_length+servo_flange_length*2],center=true);
  }

  // cable clearances for drive servos
  hull() {
    for (side=[left,right]) {
      translate([0,side*(servo_pos_y+servo_pinion_shoulder_diam/2-servo_length/2),servo_width/2]) {
        cube([14,servo_length+servo_flange_length*2,wall_thickness*4],center=true);
      }
    }
  }

  // cable clearance for rx board
  translate([0,rx_board_pos_y-rx_board_length/2,rx_board_pos_z]) {
    // cube([14,wall_thickness*2,servo_length+servo_flange_length*2],center=true);
  }

  clamp_coords = [
    [ rear_clamp_pos_x, rear_clamp_pos_y, rear_clamp_pos_z ],
    [ front_clamp_pos_x, front_clamp_pos_y, front_clamp_pos_z ],
  ];

  for(pos=clamp_coords) {
    translate(pos) {
      rotate([0,90,0]) {
        translate([0,0,-overall_width/4]) {
          // screw shaft
          hole(m3_thread_diam, overall_width/2+1, 8);
        }

        // screw head and nut
        translate([0,0,5-extrusion_height/2-0.05]) {
          hole(clamp_screw_diam, 10-extrusion_height, 8);
        }

        translate([0,0,overall_width/4+1+10]) {
          rotate([0,0,90]) {
            hole(clamp_nut_diam, overall_width/2+2, 6);
          }
        }
      }
    }
  }

  // screw holes for rear attachments
  attachment_hole_depth = 2*(abs(body_rear_y)-abs(rear_clamp_pos_y));
  for(side=[left,right]) {
    translate([servo_width/2*side,body_rear_y,arm_servo_pos_z+servo_pinion_shoulder_diam/2-servo_length-servo_flange_length-wall_thickness-m3_thread_diam/2]) {
      rotate([90,0,0]) {
        hole(m3_thread_diam,attachment_hole_depth*2,8);
      }
    }
  }
}

module battery() {
  hull() {
    for(side=[front,rear]) {
      translate([0,side*(battery_length/2-battery_thickness/2),0]) {
        rotate([0,90,0]) {
          hole(battery_thickness, battery_width, resolution);
        }
      }
    }
  }
}

module rounded_body_part(diam, width, res=resolution) {
  rotate([0,0,0]) {
    hole(diam, width-extrusion_width*4, res);
    hole(diam-extrusion_width*3, width, res);
  }
}

module outer_shell() {
  body_coords = [
    // front drive servo bottom
    [0,servo_pos_y+servo_pinion_shoulder_diam/2+servo_flange_length, -servo_width/2],

    // rear drive servo bottom
    [0,-servo_pos_y-servo_pinion_shoulder_diam/2-servo_flange_length, -servo_width/2],

    // arm servo top rear
    [0,body_rear_y+rounded_diam/2, arm_servo_pos_z + servo_pinion_shoulder_diam/2 + servo_flange_length],

    // arm servo top front
    [0,body_rear_y+rounded_diam/2+servo_width, arm_servo_pos_z + servo_pinion_shoulder_diam/2 + servo_flange_length],

    // minifig area
    [0,rx_board_pos_y+rx_board_length/2, rx_board_pos_z + rx_board_width/2],

    // in front of battery
    [0,battery_pos_y+battery_thickness/2+wall_thickness, body_top_z],
  ];

  clamp_coords = [
    // rear clamp area
    [0,rear_clamp_pos_y, rear_clamp_pos_z],

    // rear clamp area
    [0,front_clamp_pos_y, front_clamp_pos_z],
  ];

  hull() {
    for(pos=body_coords) {
      translate(pos) {
        rotate([0,90,0]) {
          rounded_body_part(rounded_diam, overall_width);
        }
      }
    }

    for(pos=clamp_coords) {
      translate(pos) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            rounded_body_part(clamp_nut_diam+rounded_diam, overall_width, 6);
          }
        }
      }
    }
  }
}

module main_body() {
  % difference() {
    outer_shell();
    translate([-overall_width/2,0,0]) {
      cube([overall_width,100,100],center=true);
    }
  }
  /*
  */
  difference() {
    //outer_shell();
    cavities();
    translate([-overall_width/2,0,0]) {
      //cube([overall_width,100,100],center=true);
    }
  }
}

module body_side(side=left) {
  difference() {
    outer_shell();
    cavities();
    translate([side*overall_width/2,0,0]) {
      cube([overall_width,100,100],center=true);
    }
  }
}

module round_a_square(width,depth) {
  translate([0,0,width/2]) {
    difference() {
      cube([width+wall_thickness*4,depth,width+4],center=true);

      hull() {
        rotate([90,0,0]) {
          hole(width,depth+1,resolution);
        }
        translate([0,0,width/2]) {
          cube([width,depth+1,width],center=true);
        }
      }
    }
  }
}

module wheel() {
  tooth_width    = 5;
  tooth_height   = 5;
  flat_bottom_width = 1.5;
  sidewall_width = (wheel_width - tooth_width)/2;
  inner_diam     = wheel_diam - tooth_height;

  module profile() {
    for(side=[left,right]) {
      hull() {
        translate([wheel_diam/4,side*(wheel_width/2-sidewall_width/2)]) {
          square([wheel_diam/2,sidewall_width], center=true);
        }

        translate([inner_diam/4,side*(1+flat_bottom_width/2),0]) {
          square([inner_diam/2,2],center=true);
        }
      }
    }

    translate([inner_diam/4,0,0]) {
      square([inner_diam/2,wheel_width-1],center=true);
    }
  }

  module wheel_body() {
    rotate_extrude($fn=wheel_res,convexity=10) {
      profile();
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
  degrees = 360 / wheel_teeth;

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
    union() {
      wheel();
      // Ribs to grip teeth. Probably YAGNI based on friction with rubber track
      for(i=[0:wheel_teeth-1]) {
        rotate([0,0,degrees*i+degrees/2]) {
          hull() {
            translate([0, wheel_diam/2-0.1,0]) {
              cube([extrusion_width*2, 0.1,wheel_width],center=true);
            }
            translate([0, bearing_outer/2+0.1, wheel_width/2-wheel_supported_width/2-0.05]) {
              cube([extrusion_width*2, 0.1,wheel_supported_width],center=true);
            }
          }
        }
      }
    }

    translate([0,0,wheel_width/2-1.5+extrusion_height]) {
      hole(2.75, bearing_thickness*2, 16);
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
        hole(bearing_outer-0.75, bearing_thickness*4, 16);
      }
    }

    translate([0,0,wheel_width/2-wheel_supported_width]) {
      hole(bearing_outer, bearing_thickness*2, 16);
    }
  }
}

module debug() {
  // driven_wheel();

  translate([servo_height,0,0]) {
    % cube([1,wheelbase,1],center=true);
  }

  translate([0,0,servo_height*2]) {
    // servo();
  }

  // cavities();
  main_body();

  translate([0,battery_pos_y,battery_pos_z]) {
    rotate([90,0,0]) {
      % battery();
    }
  }
}
