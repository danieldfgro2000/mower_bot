// Module 01 track-pod fit study part: Controller, controller support, E-stop operator and main contactor, and direct power harnesses.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module traction_controller() {
    color([0.23, 0.25, 0.28])
        translate(controller_origin)
        rotate([-90, 0, 0])
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
    // Frame-mounted controller support, independent of the sliding battery cassette.
    color([0.3, 0.45, 0.6]) {
        translate([-180, 140, -116]) cube([20, 265, 10]);
        translate([-180, 134, -116]) cube([20, 12, 22]);
        translate([-180, 405, -116]) cube([395, 6, 10]);
        for (x = [-35, 145])
            translate([x, 405, -106]) cube([20, 6, 188]);
        // Contactor shelf and arm back to the post.
        translate([-300, contactor_min[1] - 6, -116]) cube([55, 6, 91]);
        translate([-300, contactor_min[1] - 6, -116]) cube([140, 6, 10]);
    }
}

module main_contactor() {
    // Placeholder envelope only: E-stop chain opens the coil and isolates both packs.
    color([0.35, 0.23, 0.43]) {
        translate(contactor_min) cube(contactor_size);
        for (y = contactor_stud_y)
            translate([contactor_min[0] + contactor_size[0], y, contactor_stud_z])
                x_cylinder(10, 7);
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
function battery_stud_end() = contactor_min[0] + contactor_size[0] + 7 + 6;
function battery_positive_path_a() = [[-235, battery_terminal_y, battery_terminal_z[1]],
    [-235, contactor_stud_y[0], battery_terminal_z[1]],
    [-235, contactor_stud_y[0], contactor_stud_z],
    [battery_stud_end(), contactor_stud_y[0], contactor_stud_z]];
function battery_positive_path_b() = [[battery_stud_end(), contactor_stud_y[1], contactor_stud_z],
    [battery_stud_end(), 405, contactor_stud_z], [battery_stud_end(), 405, -30],
    [-60, controller_harness_y, -30], [controller_terminal_x[0], controller_harness_y, -30],
    [controller_terminal_x[0], controller_harness_y, controller_terminal_z]];
function battery_negative_path() = [[-235, battery_terminal_y, battery_terminal_z[0]],
    [-235, battery_terminal_y, -65], [-235, 405, -65], [-60, controller_harness_y, -65],
    [controller_terminal_x[4], controller_harness_y, -65],
    [controller_terminal_x[4], controller_harness_y, controller_terminal_z]];
function motor_phase_path(i) = let(lane = 118 + i * 18, x = motor_landing[0] + i * 18)
    [[x, motor_landing[1], motor_landing[2]], [x, 300, motor_landing[2]],
     [x, 300, lane], [-300, 395, lane], [-235, 425, lane],
     [controller_terminal_x[i + 1], controller_harness_y, lane],
     [controller_terminal_x[i + 1], controller_harness_y, controller_terminal_z]];

module battery_power_harness(grow = 0) {
    // Fixed leads: ring lugs bolted directly on the battery studs (unbolt first).
    d = 12 + 2 * grow;
    color([0.8, 0.08, 0.04]) {
        translate([-229 - grow, battery_terminal_y, battery_terminal_z[1]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path(battery_positive_path_a(), diameter = d);
        cable_path(battery_positive_path_b(), diameter = d);
    }
    color([0.08, 0.08, 0.09]) {
        translate([-229 - grow, battery_terminal_y, battery_terminal_z[0]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path(battery_negative_path(), diameter = d);
    }
}

module motor_power_harness() {
    // Direct phase leads, motor terminal face to controller U/V/W; inside the track side silhouette.
    for (i = [0 : 2])
        color(i == 0 ? [0.8, 0.65, 0.05] : i == 1 ? [0.12, 0.55, 0.18] : [0.08, 0.3, 0.8])
            cable_path(motor_phase_path(i));
}

// E-stop operator: outboard of the track, beside the controller, pressed downward
// (parallel to the track side). Its coil loop opens the main contactor; wiring HOLD.
module estop_mount() {
    color([0.3, 0.45, 0.6]) {
        // Arm from the fixed support cross bar to the outboard platform.
        translate([estop_min[0] + 10, 405, 72]) cube([20, 6, estop_min[2] + estop_size[2] - 72]);
        translate([estop_min[0], 405, estop_min[2]]) cube([estop_size[0], 6, estop_size[2]]);
        // Finger guard between operator and belt; rises above the track top.
        translate([estop_min[0] - 5, 405, estop_guard_z]) cube([estop_size[0] + 15, 221, 6]);
    }
}

module estop_button() {
    head = [estop_min[0] + estop_size[0] / 2, estop_min[2] + estop_size[2] / 2];
    color([0.95, 0.8, 0.1]) translate([estop_min[0], 411, estop_min[2]]) cube([estop_size[0], 60, estop_size[2]]);
    color([0.85, 0.08, 0.06]) {
        translate([head[0], 471, head[1]]) rotate([-90, 0, 0]) cylinder(d = 22, h = 10);
        translate([head[0], 481, head[1]]) rotate([-90, 0, 0]) cylinder(d = 40, h = 25);
    }
}
