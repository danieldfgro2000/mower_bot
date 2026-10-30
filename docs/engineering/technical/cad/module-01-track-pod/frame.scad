// Module 01 track-pod fit study part: Fixed carrier, U supports, axles, connected pod frame and upper roller support.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

frame_rail_bottom_y = 90;
frame_rail_thickness = 10;
frame_rail_inner_z = 90;
frame_rear_x = battery_center_x - carrier_length / 2 - 14;
frame_crossmember_width = 20;
frame_crossmember_bottom_y = 130;
frame_crossmember_height = 20;
motor_brace_size = 24;
motor_brace_x_offset = 120;
motor_brace_y_offset = 40;
motor_brace_outer_z = track_width / 2 + 6;
motor_brace_depth = 12;
motor_brace_knee_x = battery_center_x - battery_length / 2 - 53;
front_rail_width = 20;
front_rail_height = 65;
front_rail_inner_z = idler_guide_z + 17;
front_rail_outer_z = front_rail_inner_z + front_rail_width;
front_rail_start_x = idler_center[0] - 200;
front_rail_root_x = idler_center[0] - 145;
front_rail_end_x = idler_center[0] + 67;

function frame_structural_study() = [
    ["post_width_mm", motor_brace_size],
    ["post_height_mm", motor_brace_size],
    ["post_span_mm", motor_brace_outer_z + motor_brace_depth
        - (motor_inboard_face_z - motor_reaction_thickness)],
    ["post_spacing_mm", 2 * motor_brace_y_offset],
    ["post_offset_mm", motor_brace_x_offset],
    ["motor_cg_from_post_root_mm", motor_body_length / 2 + motor_reaction_thickness],
    ["rail_width_mm", frame_rail_thickness],
    ["rail_height_mm", slide_bottom_y - frame_rail_bottom_y],
    ["rail_span_mm", max([for (i = [0 : lower_support_roller_count - 2])
        lower_roller_x(i + 1) - lower_roller_x(i)])],
    ["cross_width_mm", frame_crossmember_width],
    ["cross_height_mm", frame_crossmember_height],
    ["cross_span_mm", 2 * frame_rail_inner_z + frame_rail_thickness],
    ["front_width_mm", front_rail_width],
    ["front_height_mm", front_rail_height],
    ["front_span_mm", front_rail_end_x - front_rail_root_x],
    ["front_guide_offset_mm", front_rail_inner_z + front_rail_width / 2 - idler_guide_z],
    ["plate_net_thickness_mm", motor_reaction_thickness - 8],
    ["motor_pcd_mm", motor_mount_pcd],
    ["motor_bolt_mm", motor_mount_nominal_diameter]
];

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

module motor_frame_braces() {
    post_face_z = motor_inboard_face_z - motor_reaction_thickness;
    for (dy = [-motor_brace_y_offset, motor_brace_y_offset]) {
        translate([drive_center[0] + motor_brace_x_offset - motor_brace_size / 2,
                   drive_center[1] + dy - motor_brace_size / 2, post_face_z])
            cube([motor_brace_size, motor_brace_size,
                  motor_brace_outer_z + motor_brace_depth - post_face_z]);
        hull() {
            translate([drive_center[0] + motor_brace_x_offset, drive_center[1] + dy,
                       motor_brace_outer_z + motor_brace_depth / 2])
                cube([motor_brace_size, motor_brace_size, motor_brace_depth], center = true);
            translate([motor_brace_knee_x, 140, motor_brace_outer_z + motor_brace_depth / 2])
                cube([20, 10, motor_brace_depth], center = true);
        }
        hull() {
            translate([motor_brace_knee_x, 140, motor_brace_outer_z + motor_brace_depth / 2])
                cube([20, 10, motor_brace_depth], center = true);
            translate([frame_rear_x + frame_crossmember_width / 2, 140,
                       motor_brace_outer_z + motor_brace_depth / 2])
                cube([20, 10, motor_brace_depth], center = true);
        }
    }
}

module front_rail_reinforcement(side) {
    outer_web_z = side > 0 ? front_rail_inner_z : -front_rail_outer_z;
    anchor_z = side > 0 ? frame_rail_inner_z : -front_rail_outer_z;
    anchor_width = front_rail_outer_z - frame_rail_inner_z;
    translate([front_rail_start_x, 150 - front_rail_height, outer_web_z])
        cube([front_rail_end_x - front_rail_start_x, front_rail_height, front_rail_width]);
    translate([front_rail_start_x, 138, anchor_z])
        cube([front_rail_end_x - front_rail_start_x, 12, anchor_width]);
    translate([front_rail_start_x, 90, anchor_z])
        cube([front_rail_root_x - front_rail_start_x, 50, anchor_width]);
}

module pod_frame() {
    color([0.3, 0.45, 0.6]) {
        motor_frame_braces();
        translate([frame_rear_x, frame_crossmember_bottom_y, -100])
            cube([frame_crossmember_width, frame_crossmember_height,
                  motor_brace_outer_z + motor_brace_depth + 100]);
        for (side = [-1, 1]) {
            rail_z = side > 0 ? frame_rail_inner_z : -frame_rail_inner_z - frame_rail_thickness;
            front_rail_reinforcement(side);
            difference() {
                translate([frame_rear_x, frame_rail_bottom_y, rail_z])
                    cube([idler_center[0] - 140 - frame_rear_x,
                          140 - frame_rail_bottom_y, frame_rail_thickness]);
                // Notch: the fixed guide stage bears on the rails at Y = 129.9.
                translate([slide_slot[0], slide_bottom_y, rail_z - 1])
                    cube([slide_slot[1] - slide_slot[0], 20, frame_rail_thickness + 2]);
            }
            translate([idler_center[0] - 145, 138, rail_z])
                cube([212, 12, 10]);
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

module upper_roller_mast(x, y, flip = false) {
    // Inboard mast and diagonal from the tray frame rail; the rear copy is mirrored
    // so its brace lands on the rail ahead of it.
    roller_u_support(x, y, true);
    color([0.3, 0.45, 0.6])
        translate([x, 0, 0]) mirror([flip ? 1 : 0, 0, 0]) {
            translate([-15, 140, -116]) cube([30, 306, 10]);
            hull() {
                translate([-100, 146, -111]) cube([16, 16, 10], center = true);
                translate([0, 438, -111]) cube([16, 16, 10], center = true);
            }
            translate([-110, 134, -116]) cube([130, 12, 22]);
            translate([-18, 440, -116]) cube([36, 6, 36]);
        }
}

module upper_roller_support() {
    upper_roller_mast(upper_roller_center[0], upper_roller_center[1]);
    upper_roller_mast(upper_roller_2_center[0], upper_roller_2_center[1], true);
}
