/*
 Module 01 single-pod fit study; millimetres.

 Concept only: not a dimensional drawing, fit proof, fabrication model, or
 release for purchase/build. S01 identifies the listing as 200x72x36 but does
 not define that code or provide a dimensional drawing. The code interpretation,
 belt thickness and pitch-line offset, battery envelope, and carrier are
 assumptions requiring supplier/engineering confirmation. The owner-selected
 350 mm value means physical roller outside diameter. The speed screen
 temporarily treats that as the effective rolling diameter; the track
 pitch-line diameter is unknown. The HPM5000B body is modeled at the
 manufacturer's 206 mm diameter x 126 mm length;
 the published envelope does not include a selected gearbox. The motor is
 coaxial with the drive drum and extends inward from its outboard face. Three
 fixed-ring planetary stages are shown at a 66:1 study ratio; pitch circles
 use a visual-only 3 mm module and the 18 mm stage widths are placeholders.
 View from the final-carrier side (negative Z) to inspect the planetary stages;
 the outboard view exposes the motor package.
 Tooth profiles, carrier supports, bearings, shaft interfaces, strength and
 clearances are not designed. The upper-return support
 rollers are intended to push outward against the upper run on spring-loaded
 mounts to tension the track, but their location, movement, spring setting,
 travel and loads are not modeled. Four lower support rollers per track are
 shown evenly spaced as selected for this study; their size and load capacity
 are visual placeholders, not selected dimensions or verified clearances.

 Axes: X = track length, Y = vertical, Z = outboard/track width.
*/

$fn = 64;

track_width = 200;
track_pitch = 72;
track_links = 36;
nominal_pitch_loop = track_pitch * track_links;

roller_outer_diameter = 350; // Owner-selected physical outside-diameter study.
effective_rolling_diameter_placeholder = 350; // Track pitch-line diameter is unknown.
belt_thickness = 20; // Illustrative only; S01 does not publish this dimension.
track_path_diameter = roller_outer_diameter + belt_thickness;
// Simplified path estimate: assumes the modelled track path is at belt mid-thickness.
roller_width = track_width; // Placeholder; the matched roller width is unknown.
// Equal end-roller diameters are assumed solely for this conceptual path sketch.
// The idler is not a selected part; see docs/engineering/bom/sources.md#s26.
drive_drum_wall_placeholder = 10;
drive_drum_inner_diameter =
    roller_outer_diameter - 2 * drive_drum_wall_placeholder;
frame_gap = 80; // User target: lower belt inner face to carrier underside.
carrier_thickness = 10; // Illustrative only.
carrier_length = 650; // Illustrative only.
carrier_width = track_width; // Illustrative only.

motor_body_diameter = 206; // HPM5000B manufacturer family envelope, S24.
motor_body_length = 126; // HPM5000B manufacturer family envelope, S24.
motor_speed_study_rpm = 4000; // S23 listing value; exact variant unverified.
planetary_stage_count = 3;
planetary_sun_teeth = [24, 24, 16];
planetary_ring_teeth = [72, 72, 50];
planetary_planet_teeth = [24, 24, 17];
planetary_module_placeholder = 3;
planetary_stage_width_placeholder = 18;
planetary_total_ratio =
    (1 + planetary_ring_teeth[0] / planetary_sun_teeth[0])
    * (1 + planetary_ring_teeth[1] / planetary_sun_teeth[1])
    * (1 + planetary_ring_teeth[2] / planetary_sun_teeth[2]);
motor_inboard_face_z = track_width / 2 - motor_body_length;
motor_center_z = track_width / 2 - motor_body_length / 2;
planetary_output_rpm = motor_speed_study_rpm / planetary_total_ratio;
roller_speed_study_kmh =
    PI * effective_rolling_diameter_placeholder / 1000
    * planetary_output_rpm * 60 / 1000;

lower_support_roller_count = 4; // User-selected study layout per track.
lower_support_roller_placeholder_diameter = 80; // Visual placeholder only.
lower_support_roller_placeholder_width = 140; // Visual placeholder only.

battery_length = 522;
battery_width = 269;
battery_height = 217;

roller_radius = track_path_diameter / 2;
roller_center_spacing = (nominal_pitch_loop - 2 * PI * roller_radius) / 2;
loop_envelope_length = roller_center_spacing + track_path_diameter;
lower_belt_inner_face_y = belt_thickness / 2;
carrier_underside_y = lower_belt_inner_face_y + frame_gap;
battery_bottom_y = carrier_underside_y + carrier_thickness;
upper_belt_inner_face_y = track_path_diameter - belt_thickness / 2;
remaining_vertical_clearance =
    upper_belt_inner_face_y - battery_bottom_y - battery_height;
straight_run_margin_total = roller_center_spacing - battery_length;

echo("Assumed nominal pitch-loop length (mm): ", nominal_pitch_loop);
echo("Study main driven roller physical outside diameter (mm): ",
     roller_outer_diameter);
echo("Idler shown at same study diameter for loop geometry only; no part selected.");
echo("Estimated track-path diameter (mm): ", track_path_diameter);
echo("HPM5000B published motor body envelope (diameter x length mm): ",
     motor_body_diameter, " x ", motor_body_length);
echo("Motor is coaxial and extends from the outboard drum face into the roller.");
echo("Fixed-ring planetary study ratio: ", planetary_total_ratio, ":1");
echo("Planetary sun teeth by stage: ", planetary_sun_teeth);
echo("Planetary ring teeth by stage: ", planetary_ring_teeth);
echo("Planetary planet teeth by stage: ", planetary_planet_teeth);
echo("Study gear module and stage width (mm): ",
     planetary_module_placeholder, " / ", planetary_stage_width_placeholder);
echo("Study drum speed at 4000 motor rpm (rpm): ", planetary_output_rpm);
echo("Assumed effective rolling diameter for speed screen (mm): ",
     effective_rolling_diameter_placeholder);
echo("Study surface speed at assumed effective diameter (km/h): ",
     roller_speed_study_kmh);
echo("Planetary module/stage extents and drum wall are visual placeholders only.");
echo("Drive-sprocket tooth profile and motor coupling are not modeled.");
echo("Four lower support rollers per track shown; size and capacity are placeholders.");
echo("Study roller centre spacing (mm): ", roller_center_spacing);
echo("Study pitch envelope length (mm): ", loop_envelope_length);
echo("Study straight-run margin around battery (mm): ", straight_run_margin_total);
echo("Vertical clearance above battery before service clearance (mm): ",
     remaining_vertical_clearance);

module capsule_2d(radius) {
    hull() {
        translate([-roller_center_spacing / 2, roller_radius])
            circle(r = radius);
        translate([roller_center_spacing / 2, roller_radius])
            circle(r = radius);
    }
}

module track_loop() {
    linear_extrude(height = track_width, center = true)
        difference() {
            capsule_2d(roller_radius + belt_thickness / 2);
            capsule_2d(roller_radius - belt_thickness / 2);
        }
}

module main_driven_roller(x) {
    // Hollow drum envelope exposes the internal reduction concept.
    // Outer teeth and drum wall thickness are not selected.
    translate([x, roller_radius, 0])
        color([0.72, 0.43, 0.12, 0.85])
            difference() {
                cylinder(d = roller_outer_diameter, h = roller_width, center = true);
                cylinder(
                    d = drive_drum_inner_diameter,
                    h = roller_width + 1,
                    center = true
                );
            }
}

module idler_placeholder(x) {
    translate([x, roller_radius, 0])
        color([0.25, 0.25, 0.28, 0.65])
            cylinder(d = roller_outer_diameter, h = roller_width, center = true);
}

module hpm5000b_motor_envelope(x) {
    // Published body envelope only; shaft and mounting details are unknown.
    translate([x, roller_radius, motor_center_z])
        color([0.15, 0.35, 0.72, 0.48])
            cylinder(d = motor_body_diameter, h = motor_body_length, center = true);
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
        - planetary_stage_width_placeholder / 2
        - stage_index * planetary_stage_width_placeholder;

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
            cylinder(
                d = sun_pitch_diameter,
                h = planetary_stage_width_placeholder,
                center = true
            );

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
        - planetary_stage_width_placeholder * planetary_stage_count
        - 3;
    translate([x, roller_radius, output_z])
        color([0.72, 0.43, 0.12, 0.95])
            linear_extrude(height = 6, center = true)
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

module lower_support_rollers() {
    for (i = [0 : lower_support_roller_count - 1]) {
        x = -roller_center_spacing / 4
            + i * roller_center_spacing / (2 * (lower_support_roller_count - 1));
        translate([
            x,
            belt_thickness / 2 + lower_support_roller_placeholder_diameter / 2,
            0
        ])
            color([0.22, 0.55, 0.34, 0.9])
                cylinder(
                    d = lower_support_roller_placeholder_diameter,
                    h = lower_support_roller_placeholder_width,
                    center = true
                );
    }
}

color([0.12, 0.12, 0.14, 0.65])
    track_loop();

main_driven_roller(-roller_center_spacing / 2);
idler_placeholder(roller_center_spacing / 2);
hpm5000b_motor_envelope(-roller_center_spacing / 2);
for (stage = [0 : planetary_stage_count - 1])
    planetary_stage(-roller_center_spacing / 2, stage);
final_carrier_to_drum(-roller_center_spacing / 2);
lower_support_rollers();

translate([-carrier_length / 2,
           carrier_underside_y,
           -carrier_width / 2])
    color([0.3, 0.45, 0.6])
        cube([carrier_length, carrier_thickness, carrier_width]);

translate([-battery_length / 2,
           battery_bottom_y,
           -battery_width / 2])
    color([0.9, 0.55, 0.12, 0.8])
        cube([battery_length, battery_height, battery_width]);

// Arrow indicates the proposed outboard battery-removal direction only.
translate([0, battery_bottom_y + battery_height / 2, battery_width / 2 + 5])
    color([0.1, 0.45, 0.85])
        cylinder(h = 95, d = 5);
translate([0, battery_bottom_y + battery_height / 2, battery_width / 2 + 100])
    color([0.1, 0.45, 0.85])
        cylinder(h = 18, d1 = 16, d2 = 0);
