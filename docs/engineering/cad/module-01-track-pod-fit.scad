/*
 Module 01 single-pod fit study; millimetres.

 Unqualified sourcing-candidate fit study, not a fabrication model or release.
 Owners: running-gear.md S34/S37/S38, propulsion.md S24, batteries.md S30.
 Track: 180x72x37 code interpreted as width/pitch/links; belt mid-thickness
 is an assumed pitch line. Guide lugs and tread blocks are schematic, not a
 supplier profile. The 350 mm drive OD remains flexible; teeth are undefined.
 Idler: two Interwheel 161.540 candidate envelopes (200 OD, 50 tread, 60 hub).
 Lower rollers: paired 120 mm PC/TPU study wheels, 50 wide, 8 mm tread,
 two 6004 envelopes each. Guide gap and lug dimensions require measurement.
 Motor: HPM5000B 206x126 body, 22.3x53 shaft, 5x43 keyway and four M8
 openings on 148 PCD from GD-JS-03000001; hole depth, keyway axial offset
 and clocking are illustrative. No thread, thermal or structural detail.
 Battery: DC HOUSE listing body 504x268x233; terminals/cables/restraints
 are excluded because their positions/envelopes are not established.
 Three 66:1 planetary pitch-circle stages remain schematic; no tooth profiles,
 bearing supports, coupling or brake installation. Upper tensioner unmodeled.
 Carrier placement is deliberately retained to expose clashes with the larger
 lower rollers and the sloped return run; see FIT HOLD echoes and CAD README.

 Axes: X = track length, Y = vertical, Z = outboard/track width.
*/

$fn = 64;

// Used by the local documentation viewer; assembly remains the native default.
viewer_component = "assembly";
viewer_components = [
    "track", "drive-drum", "idler", "motor",
    "planetary-1", "planetary-2", "planetary-3", "output-carrier",
    "lower-roller-1", "lower-roller-2", "lower-roller-3", "lower-roller-4",
    "pod-carrier", "battery", "removal-arrow"
];

track_width = 180;
track_pitch = 72;
track_links = 37;
nominal_pitch_loop = track_pitch * track_links;

roller_outer_diameter = 350; // Flexible physical-OD study placeholder, not a requirement.
effective_rolling_diameter_placeholder = 350; // Track pitch-line diameter is unknown.
belt_thickness = 20; // Illustrative only; S01 does not publish this dimension.
track_path_diameter = roller_outer_diameter + belt_thickness;
// Simplified path estimate: assumes the modelled track path is at belt mid-thickness.
roller_width = track_width; // Drum axial envelope, not a selected matched sprocket.
idler_outer_diameter = 200; // S37 candidate, not an approved fit.
wheel_tread_width = 50;
idler_hub_width = 60;
guide_gap_placeholder = 40; // Between tread faces; actual track lugs unpublished.
guide_lug_width_placeholder = 24;
guide_lug_height_placeholder = 20;
guide_lug_length_placeholder = 24;
tread_bar_height_placeholder = 6;
wheel_axis_diameter = 20;
drive_drum_wall_placeholder = 10;
drive_drum_inner_diameter =
    roller_outer_diameter - 2 * drive_drum_wall_placeholder;
frame_gap = 80; // User target: lower belt inner face to carrier underside.
carrier_thickness = 10; // Illustrative only.
carrier_length = 650; // Illustrative only.
carrier_width = track_width; // Illustrative only.

motor_body_diameter = 206; // HPM5000B manufacturer family envelope, S24.
motor_body_length = 126; // HPM5000B manufacturer family envelope, S24.
motor_shaft_diameter = 22.3;
motor_shaft_length = 53;
motor_key_width = 5;
motor_key_length = 43;
motor_key_seat_height = 19; // Drawing cross-section, not a 19 mm shaft.
motor_mount_pcd = 148;
motor_mount_nominal_diameter = 8; // Nominal M8 opening, not tapping drill size.
motor_mount_depth_placeholder = 10;
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
planetary_output_rpm = motor_speed_study_rpm / planetary_total_ratio;
roller_speed_study_kmh =
    PI * effective_rolling_diameter_placeholder / 1000
    * planetary_output_rpm * 60 / 1000;

lower_support_roller_count = 4; // User-selected study layout per track.
lower_support_roller_diameter = 120; // Owner-selected S38 concept, not qualified.
printed_tread_thickness = 8;
bearing_outer_diameter = 42;
bearing_width = 12;
bearing_face_recess_placeholder = 1;

battery_length = 504; // S30 listing; supplied revision has conflicting dimensions.
battery_width = 268;
battery_height = 233;

roller_radius = track_path_diameter / 2;
idler_path_radius = (idler_outer_diameter + belt_thickness) / 2;
radius_difference = roller_radius - idler_path_radius;
// Both lower tangencies lie at Y=0; the upper tangent slopes to the small idler.
function loop_length(spacing) =
    2 * spacing + PI * (roller_radius + idler_path_radius)
    + 2 * radius_difference * atan(radius_difference / spacing) * PI / 180;
function solve_spacing(low, high, iterations = 40) =
    iterations == 0 ? (low + high) / 2 :
    let(mid = (low + high) / 2)
    loop_length(mid) > nominal_pitch_loop
        ? solve_spacing(low, mid, iterations - 1)
        : solve_spacing(mid, high, iterations - 1);
roller_center_spacing = solve_spacing(abs(radius_difference) + 1, nominal_pitch_loop / 2);
upper_normal_angle = 90 - 2 * atan(radius_difference / roller_center_spacing);
idler_wrap_angle = 180 - 2 * atan(radius_difference / roller_center_spacing);
idler_arc_length = idler_path_radius * idler_wrap_angle * PI / 180;
drive_center = [-roller_center_spacing / 2, roller_radius];
idler_center = [roller_center_spacing / 2, idler_path_radius];
upper_normal = [cos(upper_normal_angle), sin(upper_normal_angle)];
upper_idler_tangent = idler_center + idler_path_radius * upper_normal;
upper_drive_tangent = drive_center + roller_radius * upper_normal;
loop_envelope_length = roller_center_spacing + roller_radius + idler_path_radius + belt_thickness;
lower_belt_inner_face_y = belt_thickness / 2;
carrier_underside_y = lower_belt_inner_face_y + frame_gap;
battery_bottom_y = carrier_underside_y + carrier_thickness;
function return_inner_y(x, lug_height = 0) =
    (drive_center * upper_normal + roller_radius
     - belt_thickness / 2 - lug_height - x * upper_normal[0]) / upper_normal[1];
upper_belt_inner_face_y = return_inner_y(battery_length / 2);
remaining_vertical_clearance =
    upper_belt_inner_face_y - battery_bottom_y - battery_height;
straight_run_margin_total = roller_center_spacing - battery_length;

echo("Assumed nominal pitch-loop length (mm): ", nominal_pitch_loop);
echo("Study main driven roller physical outside diameter (mm): ",
     roller_outer_diameter);
echo("Idler candidate diameter (mm): ", idler_outer_diameter);
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
echo("Four paired lower roller assemblies: 120 OD x 50 per wheel; capacity unqualified.");
echo("Study roller centre spacing (mm): ", roller_center_spacing);
echo("Study pitch envelope length (mm): ", loop_envelope_length);
echo("Study straight-run margin around battery (mm): ", straight_run_margin_total);
echo("Vertical clearance above battery before service clearance (mm): ",
     remaining_vertical_clearance);
echo("FIT HOLD: battery to return guide tips (mm; negative is interference): ",
     return_inner_y(battery_length / 2, guide_lug_height_placeholder)
         - battery_bottom_y - battery_height);
echo("FIT HOLD: roller top above retained carrier underside (mm): ",
     lower_belt_inner_face_y + lower_support_roller_diameter - carrier_underside_y);
echo("FIT HOLD: motor/stages/carrier axial overhang beyond drum (mm): ",
     motor_body_length + planetary_stage_count * planetary_stage_width_placeholder
         + 6 - roller_width);

module capsule_2d(offset) {
    hull() {
        translate(drive_center) circle(r = roller_radius + offset);
        translate(idler_center) circle(r = idler_path_radius + offset);
    }
}

// Position and outward-normal angle at distance s around the assumed pitch loop.
function track_frame(s) =
    s < roller_center_spacing
        ? [drive_center + [s, -roller_radius], -90] :
    s < roller_center_spacing + idler_arc_length
        ? let(a = -90 + (s - roller_center_spacing) / idler_path_radius * 180 / PI)
          [idler_center + idler_path_radius * [cos(a), sin(a)], a] :
    s < 2 * roller_center_spacing + idler_arc_length
        ? [upper_idler_tangent + (upper_drive_tangent - upper_idler_tangent)
             * ((s - roller_center_spacing - idler_arc_length) / roller_center_spacing),
           upper_normal_angle] :
    let(a = upper_normal_angle
        + (s - 2 * roller_center_spacing - idler_arc_length) / roller_radius * 180 / PI)
    [drive_center + roller_radius * [cos(a), sin(a)], a];

module track_loop() {
    linear_extrude(height = track_width, center = true)
        difference() {
            capsule_2d(belt_thickness / 2);
            capsule_2d(-belt_thickness / 2);
        }
    for (i = [0 : track_links - 1]) {
        frame = track_frame(i * track_pitch);
        translate([frame[0][0], frame[0][1], 0])
            rotate([0, 0, frame[1]]) {
                translate([-belt_thickness / 2 - guide_lug_height_placeholder / 2 + 0.5, 0, 0])
                    cube([guide_lug_height_placeholder + 1,
                          guide_lug_length_placeholder, guide_lug_width_placeholder], center = true);
                translate([belt_thickness / 2 + tread_bar_height_placeholder / 2 - 0.5, 0, 0])
                    cube([tread_bar_height_placeholder + 1, 22, track_width], center = true);
            }
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
                // Central relief leaves two running bands; engagement teeth remain undefined.
                cylinder(d = roller_outer_diameter + 2, h = guide_gap_placeholder, center = true);
            }
}

module bearing_wheel(diameter, hub_width, printed = false) {
    core_diameter = diameter - (printed ? 2 * printed_tread_thickness : 0);
    difference() {
        union() {
            cylinder(d = core_diameter, h = wheel_tread_width, center = true);
            if (printed)
                color([0.15, 0.16, 0.18])
                    difference() {
                        cylinder(d = diameter, h = wheel_tread_width - 2, center = true);
                        cylinder(d = core_diameter - 1, h = wheel_tread_width + 1, center = true);
                    }
            if (hub_width > wheel_tread_width)
                cylinder(d = 60, h = hub_width, center = true);
        }
        cylinder(d = wheel_axis_diameter, h = hub_width + 2, center = true);
        if (printed)
            for (side = [-1, 1])
                translate([0, 0, side * (hub_width / 2 - (bearing_width + 1) / 2)])
                    cylinder(d = bearing_outer_diameter, h = bearing_width + 1.02, center = true);
    }
    if (printed)
        for (side = [-1, 1])
            translate([0, 0, side * (hub_width / 2 - bearing_face_recess_placeholder - bearing_width / 2)])
                color([0.55, 0.57, 0.6])
                    difference() {
                        cylinder(d = bearing_outer_diameter, h = bearing_width, center = true);
                        cylinder(d = wheel_axis_diameter, h = bearing_width + 1, center = true);
                    }
}

module wheel_pair(diameter, hub_width, printed = false) {
    for (side = [-1, 1])
        translate([0, 0, side * (guide_gap_placeholder + wheel_tread_width) / 2])
            bearing_wheel(diameter, hub_width, printed);
}

module idler_placeholder(x) {
    translate([x, idler_path_radius, 0])
        color([0.25, 0.25, 0.28, 0.65])
            wheel_pair(idler_outer_diameter, idler_hub_width);
}

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

module lower_support_roller(i) {
    drive_margin = roller_outer_diameter / 2 + lower_support_roller_diameter / 2 + 10;
    idler_margin = idler_outer_diameter / 2 + lower_support_roller_diameter / 2 + 10;
    x = -roller_center_spacing / 2 + drive_margin
        + i * (roller_center_spacing - drive_margin - idler_margin)
            / (lower_support_roller_count - 1);
    translate([
        x,
        belt_thickness / 2 + lower_support_roller_diameter / 2,
        0
    ])
        color([0.22, 0.55, 0.34, 0.9])
            wheel_pair(lower_support_roller_diameter, wheel_tread_width, true);
}

module pod_carrier() {
    translate([-carrier_length / 2, carrier_underside_y, -carrier_width / 2])
        color([0.3, 0.45, 0.6])
            cube([carrier_length, carrier_thickness, carrier_width]);
}

module battery_envelope() {
    translate([-battery_length / 2, battery_bottom_y, -battery_width / 2])
        color([0.9, 0.55, 0.12, 0.8])
            cube([battery_length, battery_height, battery_width]);
}

module removal_arrow() {
    // Annotation only, not a physical component.
    translate([0, battery_bottom_y + battery_height / 2, battery_width / 2 + 5])
        color([0.1, 0.45, 0.85])
            cylinder(h = 95, d = 5);
    translate([0, battery_bottom_y + battery_height / 2, battery_width / 2 + 100])
        color([0.1, 0.45, 0.85])
            cylinder(h = 18, d1 = 16, d2 = 0);
}

module pod_component(id) {
    if (id == "track")
        color([0.12, 0.12, 0.14, 0.65]) track_loop();
    else if (id == "drive-drum") main_driven_roller(-roller_center_spacing / 2);
    else if (id == "idler") idler_placeholder(roller_center_spacing / 2);
    else if (id == "motor") hpm5000b_motor_envelope(-roller_center_spacing / 2);
    else if (id == "output-carrier") final_carrier_to_drum(-roller_center_spacing / 2);
    else if (id == "pod-carrier") pod_carrier();
    else if (id == "battery") battery_envelope();
    else if (id == "removal-arrow") removal_arrow();
    else {
        for (stage = [0 : planetary_stage_count - 1])
            if (id == str("planetary-", stage + 1))
                planetary_stage(-roller_center_spacing / 2, stage);
        for (i = [0 : lower_support_roller_count - 1])
            if (id == str("lower-roller-", i + 1))
                lower_support_roller(i);
    }
}

assert(viewer_component == "assembly"
       || len([for (id = viewer_components) if (id == viewer_component) id]) == 1,
       str("Unknown viewer component: ", viewer_component));
if (viewer_component == "assembly")
    for (id = viewer_components) pod_component(id);
else
    pod_component(viewer_component);
