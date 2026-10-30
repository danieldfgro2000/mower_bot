// Module 01 track-pod fit study part: Sliding idler carriage, reaction blocks and compression spring.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module idler_carriage(offset = 0) {
    x = idler_center[0] + offset;
    color([0.48, 0.52, 0.58])
        difference() {
            union() {
                translate([x - 111, 94, -91]) cube([6, 32, 182]);
                translate([x - 114, idler_path_radius, 0]) x_cylinder(40, 3);
                for (side = [-1, 1]) {
                    translate([x - 111, 94, side > 0 ? 85 : -91])
                        cube([127, 38, 6]);
                    translate([x - 24, 126, side > 0 ? 85 : -idler_guide_z])
                        cube([48, 6, idler_guide_z - 85]);
                    translate([x - 24, idler_guide_y, side * idler_guide_z])
                        x_cylinder(22, 48);
                }
            }
            translate([x, idler_path_radius, 0])
                cylinder(d = wheel_axis_diameter + 0.5, h = 240, center = true);
            for (side = [-1, 1])
                translate([x - 25, idler_guide_y, side * idler_guide_z])
                    x_cylinder(idler_slider_bore, 50);
            translate([x - 115, idler_path_radius, 0]) x_cylinder(14, 14);
        }
    wheel_axle(x, idler_path_radius, 82);
}

module idler_reaction() {
    color([0.3, 0.45, 0.6])
        translate([spring_fixed_face_x - 8, 90, -20]) cube([8, 52, 40]);
    color([0.6, 0.62, 0.65])
        translate([spring_fixed_face_x - 18, idler_path_radius, 0]) x_cylinder(12, 120);
}

function spring_point(t, length) =
    [spring_fixed_face_x + spring_wire_diameter / 2
        + (length - spring_wire_diameter) * t,
     idler_path_radius + spring_mean_radius * cos(360 * spring_active_turns * t),
     spring_mean_radius * sin(360 * spring_active_turns * t)];

module idler_spring(offset = 0) {
    length = idler_center[0] + offset - 114 - spring_fixed_face_x;
    assert(length > 8 * spring_wire_diameter + 5, "Spring below schematic solid-height reserve");
    idler_reaction();
    color([0.7, 0.3, 0.12]) {
        for (i = [0 : 143])
            hull() {
                translate(spring_point(i / 144, length))
                    sphere(d = spring_wire_diameter, $fn = 8);
                translate(spring_point((i + 1) / 144, length))
                    sphere(d = spring_wire_diameter, $fn = 8);
            }
        for (x = [spring_fixed_face_x + spring_wire_diameter / 2,
                  spring_fixed_face_x + length - spring_wire_diameter / 2])
            translate([x, idler_path_radius, 0])
                rotate([0, 90, 0])
                    rotate_extrude($fn = 32)
                        translate([spring_mean_radius, 0])
                            circle(d = spring_wire_diameter, $fn = 8);
    }
}
