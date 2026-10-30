// Module 01 track-pod fit study part: Controller, electrical plate, E-stop operator and guard,
// main contactor, direct power harnesses and phase cable cleats.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module traction_controller() {
    color([0.23, 0.25, 0.28])
        translate(controller_origin)
        // Drawing length -> +Z, height -> +X, depth -> +Y (terminal face up).
        multmatrix([[0, 1, 0, 0], [0, 0, 1, 0], [1, 0, 0, 0]])
        difference() {
            union() {
                cube([controller_length, controller_height, 5]);
                translate([16, 14, 5])
                    cube([controller_length - 32, controller_height - 28, controller_depth - 15]);
                for (x = controller_terminal_offset)
                    translate([x, 100, controller_depth - 10])
                        cylinder(d = 16, h = 10);
            }
            // Published 150.50 x 180 mounting centers / four 7 mm holes.
            for (x = [10, 190])
                for (y = [6.75, 157.25])
                    translate([x, y, -0.1])
                        cylinder(d = 7, h = controller_depth + 0.2);
        }
}

module controller_support() {
    // One flat electrical plate, independent of the sliding battery cassette:
    // controller, contactor and E-stop all seat on its top face (Y = 411).
    // It bolts to both inboard masts and both outboard posts; the front notch
    // clears the track and battery leads, the rear slot takes the phase grommet.
    color([0.3, 0.45, 0.6])
        translate([0, electrical_plate_y, 0]) rotate([90, 0, 0])
            linear_extrude(height = electrical_plate_thickness)
            difference() {
                polygon(electrical_plate_outline);
                translate([electrical_plate_slot[0], electrical_plate_slot[2]])
                    square([electrical_plate_slot[1] - electrical_plate_slot[0],
                            electrical_plate_slot[3] - electrical_plate_slot[2]]);
            }
}

module main_contactor() {
    // Placeholder envelope only: E-stop chain opens the coil and isolates both packs.
    color([0.35, 0.23, 0.43]) {
        translate(contactor_min) cube(contactor_size);
        for (x = contactor_stud_x)
            translate([x, contactor_min[1] + contactor_size[1], contactor_stud_z])
                rotate([-90, 0, 0]) cylinder(d = 10, h = 6);
    }
}

module cable_path(points, diameter = 12, sweep = 0) {
    for (i = [1 : len(points) - 1])
        hull() {
            for (travel = [0, sweep]) {
                translate(points[i - 1] + [0, 0, travel]) sphere(d = diameter, $fn = 12);
                translate(points[i] + [0, 0, travel]) sphere(d = diameter, $fn = 12);
            }
        }
}

// Named power-cable routes so tests can hold them to shortest-route length budgets.
function path_length(points, i = 1) =
    i >= len(points) ? 0 : norm(points[i] - points[i - 1]) + path_length(points, i + 1);
function contactor_cable_y() = contactor_min[1] + contactor_size[1] + 12;
function battery_positive_path_a() =
    [[battery_terminal_x, battery_terminal_y, battery_terminal_z[1]],
     [battery_terminal_x, 400, battery_terminal_z[1]],
     [218, 430, battery_terminal_z[1]],
     [200, contactor_cable_y(), battery_terminal_z[1]],
     [contactor_stud_x[0], contactor_cable_y(), contactor_stud_z]];
function battery_positive_path_b() =
    [[contactor_stud_x[1], contactor_cable_y(), contactor_stud_z],
     [130, contactor_cable_y(), contactor_stud_z],
     [controller_terminal_x, controller_harness_y, controller_terminal_z[0]]];
function battery_negative_path() =
    [[battery_terminal_x, battery_terminal_y, battery_terminal_z[0]],
     [battery_terminal_x, 395, battery_terminal_z[0]],
     [110, controller_harness_y, battery_terminal_z[0]],
     [controller_terminal_x, controller_harness_y, controller_terminal_z[4]]];
// Phase leads rise beside the motor, run outboard of the drum along the rear
// post, pass a grommet in the electrical plate and lie on its top face to a
// riser clamp behind the controller; every span is clamped (see supports).
function motor_phase_path(i) =
    let(x = motor_landing[0] + i * 18, lane_y = phase_lane_y[i],
        column = phase_columns[i], top_z = phase_plate_lane_z[i],
        z = controller_terminal_z[i + 1])
    concat(
        [[x, motor_landing[1], motor_landing[2]], [x, lane_y, motor_landing[2]],
         [phase_post_x, lane_y, phase_post_lane_z],
         [column[0], lane_y, phase_post_lane_z]],
        column[1] == phase_post_lane_z ? [] : [[column[0], lane_y, column[1]]],
        [[column[0], phase_plate_lane_y, column[1]]],
        column[1] == top_z ? [] : [[column[0], phase_plate_lane_y, top_z]],
        [[harness_riser_x, phase_plate_lane_y, top_z],
         [harness_riser_x, controller_harness_y, top_z],
         [controller_terminal_x, controller_harness_y, z]]);

// Arc-length position of a point lying on a polyline (undef when it does not).
function point_segment_distance(p, a, b) =
    let(t = max(0, min(1, (p - a) * (b - a) / ((b - a) * (b - a)))))
    norm(p - (a + t * (b - a)));
function path_position(points, p, i = 1, travelled = 0) =
    i >= len(points) ? undef
    : point_segment_distance(p, points[i - 1], points[i]) < 0.01
        ? travelled + norm(p - points[i - 1])
        : path_position(points, p, i + 1, travelled + norm(points[i] - points[i - 1]));

// Clamped stations per phase: riser clip, post cleat, plate grommet,
// plate bridge clip and riser clamp (motor and controller lugs close the ends).
function motor_phase_supports(i) =
    let(x = motor_landing[0] + i * 18, column = phase_columns[i], top_z = phase_plate_lane_z[i])
    [[x, phase_riser_clip_y, motor_landing[2]],
     [phase_post_cleat_x, phase_lane_y[i], phase_post_lane_z],
     [column[0], electrical_plate_y - electrical_plate_thickness / 2, column[1]],
     [phase_bridge_clip_x, phase_plate_lane_y, top_z],
     [harness_riser_x, phase_riser_clamp_y, top_z]];

module battery_positive_harness(grow = 0) {
    d = 12 + 2 * grow;
    color([214 / 255, 34 / 255, 24 / 255]) {
        translate([battery_terminal_x - 18 - grow, battery_terminal_y, battery_terminal_z[1]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path(battery_positive_path_a(), diameter = d);
        cable_path(battery_positive_path_b(), diameter = d);
    }
}

module battery_negative_harness(grow = 0) {
    d = 12 + 2 * grow;
    color([16 / 255, 17 / 255, 18 / 255]) {
        translate([battery_terminal_x - 18 - grow, battery_terminal_y, battery_terminal_z[0]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path(battery_negative_path(), diameter = d);
    }
}

module battery_power_harness(grow = 0) {
    // Fixed leads: ring lugs bolted directly on the battery studs (unbolt first).
    battery_positive_harness(grow);
    battery_negative_harness(grow);
}

module motor_power_harness() {
    // Direct phase leads, motor terminal face to controller U/V/W; inside the track side silhouette.
    for (i = [0 : 2])
        color(i == 0 ? [0.8, 0.65, 0.05] : i == 1 ? [0.12, 0.55, 0.18] : [0.08, 0.3, 0.8])
            cable_path(motor_phase_path(i));
}

// E-stop operator: outboard of the track, on the electrical plate beside the
// controller, pressed downward (parallel to the track side). Its coil loop opens
// the main contactor; wiring HOLD.
module estop_mount() {
    // Finger guard tab bolted to the plate between operator and belt; rises above the track top.
    color([0.3, 0.45, 0.6])
        translate([estop_min[0] - 5, electrical_plate_y - electrical_plate_thickness, estop_guard_z])
            cube([estop_size[0] + 15, 221, 6]);
}

module estop_button() {
    head = [estop_min[0] + estop_size[0] / 2, estop_min[2] + estop_size[2] / 2];
    color([0.95, 0.8, 0.1]) translate([estop_min[0], electrical_plate_y, estop_min[2]]) cube([estop_size[0], 60, estop_size[2]]);
    color([0.85, 0.08, 0.06]) {
        translate([head[0], 471, head[1]]) rotate([-90, 0, 0]) cylinder(d = 22, h = 10);
        translate([head[0], 481, head[1]]) rotate([-90, 0, 0]) cylinder(d = 40, h = 25);
    }
}

// Outer blocks of the phase cable cleats, before the cable bores are removed.
module motor_harness_support_envelopes() {
    lane_min = phase_lane_y[2] - 10;
    lane_max = phase_lane_y[0] + 10;
    top_y = phase_plate_lane_y;
    // Riser clip: upright bolted to the upper motor-cradle rail, clamp across all risers.
    translate([-470, 230, 128]) cube([18, phase_riser_clip_y + 6 - 230, 25]);
    translate([-470, phase_riser_clip_y - 6, 112]) cube([78, 12, 28]);
    // Bundle cleat bolted to the inboard face of the rear outboard post.
    translate([phase_post_cleat_x - 8.5, lane_min, 106]) cube([17, lane_max - lane_min, 23]);
    // Split grommet filling the plate slot, flanged 2 mm over its edges.
    translate([electrical_plate_slot[0] - 2, electrical_plate_y - electrical_plate_thickness - 2,
               electrical_plate_slot[2] - 2])
        cube([electrical_plate_slot[1] - electrical_plate_slot[0] + 4, electrical_plate_thickness + 4,
              electrical_plate_slot[3] - electrical_plate_slot[2] + 4]);
    // Bridge clip screwed to the plate top across the three lanes.
    translate([phase_bridge_clip_x - 8, electrical_plate_y - 1, 78]) cube([16, top_y + 10 - electrical_plate_y + 1, 72]);
    // Riser clamp: upright on the plate outboard of the lanes, bar around the three risers.
    translate([harness_riser_x - 12, electrical_plate_y - 1, 150])
        cube([24, phase_riser_clamp_y + 6 - electrical_plate_y + 1, 10]);
    translate([harness_riser_x - 12, phase_riser_clamp_y - 6, 78]) cube([24, 12, 82]);
}

module motor_harness_supports() {
    color([0.15, 0.15, 0.16])
        difference() {
            motor_harness_support_envelopes();
            for (i = [0 : 2]) cable_path(motor_phase_path(i));
        }
}
