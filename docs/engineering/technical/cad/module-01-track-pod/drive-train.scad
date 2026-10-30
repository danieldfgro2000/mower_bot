// Module 01 track-pod fit study part: HPM5000B motor envelope, planetary stages, output carrier and motor reaction mount.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module hpm5000b_motor_envelope(x) {
    translate([x, roller_radius, motor_inboard_face_z]) {
        color([0.15, 0.35, 0.72, 0.8])
            difference() {
                cylinder(d = motor_body_diameter, h = motor_body_length);
                for (a = [45 : 90 : 315])
                    translate([motor_mount_pcd / 2 * cos(a), motor_mount_pcd / 2 * sin(a), -0.1])
                        cylinder(d = motor_mount_nominal_diameter, h = motor_mount_depth_placeholder + 0.1);
            }
        color([0.55, 0.57, 0.6])
            difference() {
                translate([0, 0, -motor_shaft_length])
                    cylinder(d = motor_shaft_diameter, h = motor_shaft_length + 0.1);
                translate([-motor_key_width / 2,
                           motor_key_seat_height - motor_shaft_diameter / 2,
                           -motor_shaft_length + 5])
                    cube([motor_key_width, motor_shaft_diameter, motor_key_length]);
            }
    }
}

module planetary_stage(x, stage_index) {
    sun_teeth = planetary_sun_teeth[stage_index];
    ring_teeth = planetary_ring_teeth[stage_index];
    planet_teeth = planetary_planet_teeth[stage_index];
    module_size = planetary_module_placeholder;
    ring_pitch_diameter = ring_teeth * module_size;
    sun_pitch_diameter = sun_teeth * module_size;
    planet_pitch_diameter = planet_teeth * module_size;
    planet_orbit_radius = (sun_pitch_diameter + planet_pitch_diameter) / 2;
    ring_envelope_diameter = ring_pitch_diameter + 2 * module_size;
    stage_z = motor_inboard_face_z
        - motor_reaction_thickness
        - planetary_stage_width_placeholder / 2
        - planetary_axial_gap_placeholder
        - stage_index * (planetary_stage_width_placeholder + planetary_axial_gap_placeholder);

    // Pitch-circle cylinders visualize tooth counts; they are not gear teeth.
    translate([x, roller_radius, stage_z]) {
        color([0.38, 0.4, 0.43, 0.9])
            difference() {
                cylinder(
                    d = ring_envelope_diameter,
                    h = planetary_stage_width_placeholder,
                    center = true
                );
                cylinder(
                    d = ring_pitch_diameter - 2 * module_size,
                    h = planetary_stage_width_placeholder + 1,
                    center = true
                );
            }

        color([0.82, 0.68, 0.25, 0.95])
            difference() {
                cylinder(d = sun_pitch_diameter, h = planetary_stage_width_placeholder, center = true);
                // Visual shaft passage only; coupling and supported stage shafts are undesigned.
                cylinder(d = motor_shaft_diameter + 2, h = planetary_stage_width_placeholder + 1, center = true);
            }

        for (angle = [0 : 120 : 240]) {
            translate([
                planet_orbit_radius * cos(angle),
                planet_orbit_radius * sin(angle),
                0
            ])
                color([0.2, 0.58, 0.42, 0.95])
                    cylinder(
                        d = planet_pitch_diameter,
                        h = planetary_stage_width_placeholder,
                        center = true
                    );
        }
    }
}

module final_carrier_to_drum(x) {
    // Schematic carrier spokes connect the final carrier to the rotating drum.
    planet_orbit_radius =
        (planetary_sun_teeth[2] + planetary_planet_teeth[2])
        * planetary_module_placeholder / 2;
    output_z = motor_inboard_face_z
        - motor_reaction_thickness
        - planetary_stage_width_placeholder * planetary_stage_count
        - planetary_axial_gap_placeholder * (planetary_stage_count + 1)
        - output_carrier_thickness / 2;
    translate([x, roller_radius, output_z])
        color([0.72, 0.43, 0.12, 0.95])
            linear_extrude(height = output_carrier_thickness, center = true)
                for (angle = [0 : 120 : 240]) {
                    hull() {
                        circle(d = 14);
                        translate([
                            drive_drum_inner_diameter / 2 * cos(angle),
                            drive_drum_inner_diameter / 2 * sin(angle)
                        ])
                            circle(d = 14);
                    }
                }
}

module motor_reaction_mount() {
    face = motor_inboard_face_z - motor_reaction_thickness;
    translate([drive_center[0], drive_center[1], face])
        color([0.48, 0.52, 0.58])
            difference() {
                cylinder(d = motor_reaction_diameter, h = motor_reaction_thickness);
                translate([0, 0, -0.1]) cylinder(d = 26, h = motor_reaction_thickness + 0.2);
                for (angle = [45 : 90 : 315])
                    translate([motor_mount_pcd / 2 * cos(angle),
                               motor_mount_pcd / 2 * sin(angle), -0.1]) {
                        cylinder(d = 9, h = motor_reaction_thickness + 0.2);
                        cylinder(d = 14, h = 8.1);
                    }
            }
}
