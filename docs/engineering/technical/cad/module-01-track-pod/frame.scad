// Module 01 track-pod fit study part: Fixed carrier, U supports, axles, connected pod frame and upper roller support.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module pod_carrier() {
    color([0.3, 0.45, 0.6])
        difference() {
            translate([battery_center_x - carrier_length / 2,
                       carrier_underside_y, carrier_center_z - carrier_width / 2])
                cube([carrier_length, carrier_thickness, carrier_width]);
            translate([idler_center[0] - idler_clearance_stroke, idler_path_radius, 0])
                cylinder(d = idler_outer_diameter + 10, h = 170, center = true);
            // Slot for the flat guide; the two remaining plates are the fixed seats.
            translate([slide_slot[0], carrier_underside_y - 1, -200])
                cube([slide_slot[1] - slide_slot[0], carrier_thickness + 2, 400]);
        }
}

module x_cylinder(diameter, length) {
    rotate([0, 90, 0]) cylinder(d = diameter, h = length);
}

module wheel_axle(x, y, collar_z = 88) {
    translate([x, y, 0])
        color([0.6, 0.62, 0.65]) {
            cylinder(d = wheel_axis_diameter, h = 184, center = true);
            for (side = [-1, 1])
                translate([0, 0, side * collar_z])
                    cylinder(d = 28, h = 3, center = true);
        }
}

module roller_u_support(x, y, upper = false) {
    bridge_y = upper ? 440 : 134;
    bottom_y = upper ? bridge_y : y - 16;
    top_y = upper ? y + 16 : bridge_y + support_plate_thickness;
    cheek_z = wheel_tread_width + guide_gap_placeholder / 2 + support_side_gap;
    color([0.48, 0.52, 0.58])
        difference() {
            union() {
                for (side = [-1, 1])
                    translate([x - 18, bottom_y,
                               side > 0 ? cheek_z : -cheek_z - support_plate_thickness])
                        cube([36, top_y - bottom_y, support_plate_thickness]);
                translate([x - 18, bridge_y, upper ? -86 : -100])
                    cube([36, support_plate_thickness, upper ? 172 : 200]);
            }
            translate([x, y, 0])
                cylinder(d = wheel_axis_diameter + 0.5, h = 210, center = true);
        }
    wheel_axle(x, y);
}

module lower_roller_supports() {
    for (i = [0 : lower_support_roller_count - 1])
        roller_u_support(lower_roller_x(i),
                         lower_belt_inner_face_y + lower_support_roller_diameter / 2);
}

module pod_frame() {
    tray_rear = battery_center_x - carrier_length / 2;
    color([0.3, 0.45, 0.6]) {
        for (dy = [-40, 40])
            hull() {
                translate([drive_center[0] + 110, drive_center[1] + dy, -21])
                    cube([20, 20, 8], center = true);
                translate([battery_center_x - battery_length / 2 - 50,
                           carrier_underside_y + 5, -21])
                    cube([20, 10, 8], center = true);
            }
        translate([battery_center_x - battery_length / 2 - 50, 140, -25])
            cube([50, 10, 8]);
        for (side = [-1, 1]) {
            rail_z = side > 0 ? 90 : -100;
            difference() {
                translate([tray_rear, 110, rail_z])
                    cube([idler_center[0] - 140 - tray_rear, 30, 10]);
                // Notch: the fixed guide stage bears on the rails at Y = 129.9.
                translate([slide_slot[0], slide_bottom_y, rail_z - 1])
                    cube([slide_slot[1] - slide_slot[0], 20, 12]);
            }
            translate([idler_center[0] - 145, 137, rail_z])
                cube([212, 13, 10]);
            for (dx = [-67, 55])
                difference() {
                    translate([idler_center[0] + dx, 112, side * idler_guide_z - 8])
                        cube([12, 38, 16]);
                    translate([idler_center[0] + dx - 0.1, idler_guide_y, side * idler_guide_z])
                        x_cylinder(idler_guide_diameter, 12.2);
                }
            translate([idler_center[0] - 60, idler_guide_y, side * idler_guide_z])
                x_cylinder(idler_guide_diameter, 120);
            for (dx = [-24 - idler_clearance_stroke - 4, 24 + idler_clearance_stroke])
                translate([idler_center[0] + dx, idler_guide_y, side * idler_guide_z])
                    x_cylinder(20, 4);
        }
        translate([spring_fixed_face_x - 8, 134, -100]) cube([8, 6, 200]);
    }
}

module upper_roller_support() {
    roller_u_support(upper_roller_center[0], upper_roller_center[1], true);
    color([0.3, 0.45, 0.6]) {
        translate([185, 140, -116]) cube([30, 306, 10]);
        hull() {
            translate([100, 146, -111]) cube([16, 16, 10], center = true);
            translate([200, 438, -111]) cube([16, 16, 10], center = true);
        }
        translate([90, 134, -116]) cube([130, 12, 22]);
        translate([182, 440, -116]) cube([36, 6, 36]);
    }
}
