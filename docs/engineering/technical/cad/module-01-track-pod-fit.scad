/*
 Module 01 single-pod fit study; millimetres.

 Unqualified sourcing-candidate fit study, not a fabrication model or release.
 Owners: running-gear.md S34/S37/S38, propulsion.md S24, batteries.md S30.
 Track: 200x72x40 code interpreted as width/pitch/links; belt mid-thickness
 is an assumed pitch line. Guide lugs and tread blocks are schematic, not a
 supplier profile. The 350 mm drive OD remains flexible; teeth are undefined.
 Idler: two Interwheel 161.540 candidate envelopes (200 OD, 50 tread, 60 hub).
 Lower rollers: paired 120 mm PC/TPU study wheels, 50 wide, 8 mm tread,
 two 6004 envelopes each. Guide gap and lug dimensions require measurement.
 Motor: HPM5000B 206x126 body, 22.3x53 shaft, 5x43 keyway and four M8
 openings on 148 PCD from GD-JS-03000001; hole depth, keyway axial offset
 and clocking are illustrative. No thread, thermal or structural detail.
 Battery: DC HOUSE listing body 504x268x233 on an open 8 mm steel tray (no box)
 with hold-down straps. The tray rests on fixed seats; one flat telescopic ball
 guide beneath it carries it only during extraction (rating and seat-to-guide
 transfer HOLD). Tray-level two-position pin. Battery leads bolt directly to the
 terminals and run via a placeholder E-stop contactor to the controller; motor
 phases run directly to the controller. Terminal offsets remain assumptions.
 Three 66:1 planetary pitch-circle stages remain schematic; no tooth profiles,
 interstage bearing supports, coupling or brake installation. U supports, tray
 frame, motor reaction plate and fixed upper mast are custom proposals.
 Front idler now has a spring/guide carriage with +/-15 mm geometric stops;
 spring rate, preload, fatigue and actual belt compliance remain unqualified.
 Battery and tray are offset outboard; see clearance echoes and CAD README.

 Axes: X = track length, Y = vertical, Z = outboard/track width.
*/

$fn = 64;

// Used by the local documentation viewer; assembly remains the native default.
viewer_component = "assembly";
viewer_components = [
    "track", "drive-drum", "idler", "motor",
    "planetary-1", "planetary-2", "planetary-3", "output-carrier",
    "lower-roller-1", "lower-roller-2", "lower-roller-3", "lower-roller-4",
    "upper-roller", "pod-carrier", "battery", "removal-arrow",
    "lower-roller-supports", "pod-frame", "motor-mount",
    "idler-carriage", "idler-spring", "upper-roller-support",
    "battery-tray", "battery-hold-down", "slide-fixed", "slide-middle", "slide-inner",
    "tray-lock-pin", "tray-lock-strike", "controller", "controller-support", "main-contactor",
    "battery-harness", "motor-harness"
];

track_width = 200;
track_pitch = 72;
track_links = 40;
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
guide_gap_placeholder = 50; // Leaves 40 between idler hubs; actual lugs unpublished.
guide_lug_width_placeholder = 24;
guide_lug_height_placeholder = 20;
guide_lug_length_placeholder = 24;
tread_bar_height_placeholder = 6;
wheel_axis_diameter = 20;
drive_drum_wall_placeholder = 10;
drive_drum_inner_diameter =
    roller_outer_diameter - 2 * drive_drum_wall_placeholder;
carrier_thickness = 10; // Illustrative only.
carrier_edge_margin = 10;
roller_carrier_clearance = 10;

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
motor_reaction_thickness = 12;
motor_reaction_diameter = 250;
motor_speed_study_rpm = 4000; // S23 listing value; exact variant unverified.
planetary_stage_count = 3;
planetary_sun_teeth = [24, 24, 16];
planetary_ring_teeth = [72, 72, 50];
planetary_planet_teeth = [24, 24, 17];
planetary_module_placeholder = 3;
planetary_stage_width_placeholder = 18;
planetary_axial_gap_placeholder = 2;
output_carrier_thickness = 6;
planetary_total_ratio =
    (1 + planetary_ring_teeth[0] / planetary_sun_teeth[0])
    * (1 + planetary_ring_teeth[1] / planetary_sun_teeth[1])
    * (1 + planetary_ring_teeth[2] / planetary_sun_teeth[2]);
motor_outboard_face_z = track_width / 2 + motor_reaction_thickness;
motor_inboard_face_z = motor_outboard_face_z - motor_body_length;
planetary_output_rpm = motor_speed_study_rpm / planetary_total_ratio;
roller_speed_study_kmh =
    PI * effective_rolling_diameter_placeholder / 1000
    * planetary_output_rpm * 60 / 1000;

lower_support_roller_count = 4; // User-selected study layout per track.
lower_support_roller_diameter = 120; // Owner-selected S38 concept, not qualified.
upper_support_roller_diameter = 120;
upper_roller_center = [200, 535];
printed_tread_thickness = 8;
bearing_outer_diameter = 42;
bearing_width = 12;
bearing_face_recess_placeholder = 1;
support_plate_thickness = 6;
support_side_gap = 5;
idler_clearance_stroke = 15; // Geometric stops, not qualified working travel.
idler_guide_z = 104;
idler_guide_y = 120;
idler_guide_diameter = 10;
idler_slider_bore = 11;
spring_fixed_face_x = 233;
spring_wire_diameter = 4;
spring_mean_radius = 16;
spring_active_turns = 6;

battery_length = 504; // S30 listing; supplied revision has conflicting dimensions.
battery_width = 268;
battery_height = 233;
battery_center_x = 35;
service_stroke = 305; // Accuride DZ9301-0012U-E supplier SL/TR.
service_tray_thickness = 8; // Proposed S235 steel; see conservative load screen.
service_mass_screen_kg = 85; // Battery, tray, hold-down, inner guide, strip and hardware.
// Single flat Accuride DZ9301-class guide under the tray, between roller columns 2 and 3.
slide_length = 305;
slide_width = 76.2;
slide_thickness = 19.1;
slide_center_x = 12;
slide_bottom_y = 129.9; // Inner stage pad floats 1 mm below the seated tray.
slide_min_z = -100;
slide_slot = [slide_center_x - 40, slide_center_x + 40]; // Carrier slot / rail notch.
lock_pin_x = -243; // Tray-level pin, behind the battery terminal face.
lock_pin_z = 190;
// Placeholder E-stop main contactor envelope; rating, feedback and precharge HOLD.
contactor_min = [-295, 320, -100];
contactor_size = [45, 70, 70];
contactor_stud_y = [330, 375]; // Battery P+ in / controller B+ out.
contactor_stud_z = -45;
// Protected roof fallback: the inboard short-end position crosses the drum/return.
controller_origin = [-35, 411, 82];
controller_length = 200;
controller_height = 164;
controller_depth = 70.47;
// B+, U, V, W, B- order from the A-series drawing; local centers are approximate.
controller_terminal_offset = [25, 51, 100, 151, 177];
controller_terminal_x = [for (offset = controller_terminal_offset)
    controller_origin[0] + offset];
controller_terminal_face_y = controller_origin[1] + controller_depth;
controller_harness_y = controller_terminal_face_y + 6;
controller_terminal_z = controller_origin[2] - 100;
battery_terminal_y = 348; // Photo-based rear-face landing, not a released stud datum.
battery_terminal_z = [-35, 123]; // P- / P+; verify exact supplied battery.
motor_landing = [-440, 265, 118]; // 12 mm cable envelope tangent to assumed Z=112 motor face.
carrier_length = battery_length + 2 * carrier_edge_margin;
carrier_width = battery_width + 2 * carrier_edge_margin;
carrier_center_z = (carrier_width - track_width) / 2;

roller_radius = track_path_diameter / 2;
idler_path_radius = (idler_outer_diameter + belt_thickness) / 2;
upper_path_radius = (upper_support_roller_diameter + belt_thickness) / 2;
drive_center = [-440, roller_radius];
path_radii = [roller_radius, idler_path_radius, upper_path_radius];
function path_centers(spacing) =
    [drive_center, [drive_center[0] + spacing, idler_path_radius], upper_roller_center];
function sum_values(values, i = 0) =
    i == len(values) ? 0 : values[i] + sum_values(values, i + 1);
function tangent_normal(i, spacing) =
    let(centers = path_centers(spacing),
        j = (i + 1) % 3,
        delta = centers[j] - centers[i],
        distance = norm(delta),
        k = (path_radii[i] - path_radii[j]) / distance,
        q = sqrt(1 - k * k))
    [delta[0] * k + delta[1] * q, delta[1] * k - delta[0] * q] / distance;
function normal_angle(i, spacing) =
    let(n = tangent_normal(i, spacing)) atan2(n[1], n[0]);
function edge_length(i, spacing) =
    let(centers = path_centers(spacing), j = (i + 1) % 3)
    sqrt(pow(norm(centers[j] - centers[i]), 2) - pow(path_radii[i] - path_radii[j], 2));
function arc_angle(i, spacing) =
    (normal_angle(i, spacing) - normal_angle((i + 2) % 3, spacing) + 360) % 360;
function loop_length(spacing) =
    sum_values([for (i = [0 : 2])
        edge_length(i, spacing) + path_radii[i] * arc_angle(i, spacing) * PI / 180]);
function solve_spacing(low, high, iterations = 40) =
    iterations == 0 ? (low + high) / 2 :
    let(mid = (low + high) / 2)
    loop_length(mid) > nominal_pitch_loop
        ? solve_spacing(low, mid, iterations - 1)
        : solve_spacing(mid, high, iterations - 1);
spacing_low = upper_roller_center[0] - drive_center[0] + upper_path_radius + 10;
assert(loop_length(spacing_low) < nominal_pitch_loop
       && loop_length(nominal_pitch_loop / 2) > nominal_pitch_loop,
       "Track loop does not bracket the proposed three-wheel layout");
roller_center_spacing = solve_spacing(spacing_low, nominal_pitch_loop / 2);
idler_center = path_centers(roller_center_spacing)[1];
loop_envelope_length = roller_center_spacing + roller_radius + idler_path_radius + belt_thickness;
lower_belt_inner_face_y = belt_thickness / 2;
carrier_underside_y =
    lower_belt_inner_face_y + lower_support_roller_diameter + roller_carrier_clearance;
battery_bottom_y = carrier_underside_y + carrier_thickness + service_tray_thickness;
function return_guide_clearance(edge) =
    let(n = tangent_normal(edge, roller_center_spacing),
        c = path_centers(roller_center_spacing)[edge],
        corner = [battery_center_x + (n[0] > 0 ? 1 : -1) * battery_length / 2,
                  battery_bottom_y + battery_height])
    c * n + path_radii[edge] - belt_thickness / 2
        - guide_lug_height_placeholder - corner * n;
axial_stack_length = motor_body_length
    + motor_reaction_thickness
    + planetary_stage_count * planetary_stage_width_placeholder
    + (planetary_stage_count + 1) * planetary_axial_gap_placeholder
    + output_carrier_thickness;
inboard_axial_remainder = motor_outboard_face_z - axial_stack_length + roller_width / 2;

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
echo("Nominal three-circle pitch-loop closure error (mm): ",
     loop_length(roller_center_spacing) - nominal_pitch_loop);
echo("Battery to front/rear return guide-tip envelopes, normal gaps (mm): ",
     return_guide_clearance(1), return_guide_clearance(2));
echo("Lower roller to tray underside gap (mm): ", roller_carrier_clearance);
echo("Motor/stages/carrier stack and inboard drum remainder (mm): ",
     axial_stack_length, inboard_axial_remainder);
echo("Motor body outboard overhang for reaction flange (mm): ", motor_reaction_thickness);
echo("Fixed upper roller centre (mm): ", upper_roller_center);
echo("Idler geometric stop positions (mm from nominal): ",
     -idler_clearance_stroke, idler_clearance_stroke);
echo("Spring seat separation at nominal/min/max stroke (mm): ",
     idler_center[0] - 114 - spring_fixed_face_x,
     idler_center[0] - 114 - spring_fixed_face_x - idler_clearance_stroke,
     idler_center[0] - 114 - spring_fixed_face_x + idler_clearance_stroke);
echo("Battery bottom and outboard centre (mm): ", battery_bottom_y, carrier_center_z);
assert(min(return_guide_clearance(1), return_guide_clearance(2)) >= 35,
       "Return clearance below 20 mm running, 5 mm deflection and 10 mm motion reserve");
assert(inboard_axial_remainder >= 5, "Reducer exceeds inboard study envelope");

module capsule_2d(offset) {
    hull() {
        for (i = [0 : 2])
            translate(path_centers(roller_center_spacing)[i])
                circle(r = path_radii[i] + offset);
    }
}

// Position and outward-normal angle at distance s around the assumed pitch loop.
function segment_length(segment) =
    segment % 2 == 0 ? edge_length(segment / 2, roller_center_spacing) :
    let(i = (floor(segment / 2) + 1) % 3)
    path_radii[i] * arc_angle(i, roller_center_spacing) * PI / 180;
function track_frame(s, segment = 0) =
    s > segment_length(segment) && segment < 5
        ? track_frame(s - segment_length(segment), segment + 1) :
    let(i = floor(segment / 2), j = (i + 1) % 3,
        centers = path_centers(roller_center_spacing),
        n = tangent_normal(i, roller_center_spacing),
        a = normal_angle(i, roller_center_spacing))
    segment % 2 == 0
        ? [centers[i] + path_radii[i] * n
            + (centers[j] + path_radii[j] * n - centers[i] - path_radii[i] * n)
                * s / segment_length(segment), a] :
    let(angle = a + s / path_radii[j] * 180 / PI)
    [centers[j] + path_radii[j] * [cos(angle), sin(angle)], angle];

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

function lower_roller_x(i) =
    let(drive_margin = roller_outer_diameter / 2 + lower_support_roller_diameter / 2 + 10,
        idler_margin = idler_outer_diameter / 2 + lower_support_roller_diameter / 2 + 25)
    drive_center[0] + drive_margin
        + i * (roller_center_spacing - drive_margin - idler_margin)
            / (lower_support_roller_count - 1);
module lower_support_roller(i) {
    translate([
        lower_roller_x(i),
        belt_thickness / 2 + lower_support_roller_diameter / 2,
        0
    ])
        color([0.22, 0.55, 0.34, 0.9])
            wheel_pair(lower_support_roller_diameter, wheel_tread_width, true);
}

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

module battery_envelope() {
    translate([battery_center_x - battery_length / 2,
               battery_bottom_y, carrier_center_z - battery_width / 2])
        color([0.9, 0.55, 0.12, 0.8])
            cube([battery_length, battery_height, battery_width]);
}

module battery_service_tray() {
    color([0.38, 0.45, 0.52])
        difference() {
            translate([-253, battery_bottom_y - service_tray_thickness, -100])
                cube([550, service_tray_thickness, 288]);
            translate([idler_center[0] - idler_clearance_stroke, idler_path_radius, 0])
                cylinder(d = idler_outer_diameter + 10, h = 170, center = true);
            // Pin clearance notch at the WORK position.
            translate([lock_pin_x, battery_bottom_y - service_tray_thickness - 1, lock_pin_z])
                rotate([-90, 0, 0]) cylinder(d = 14, h = service_tray_thickness + 2);
        }
}

module battery_hold_down() {
    // Two 3 mm straps over the battery, bolted to the moving tray (restraint HOLD).
    top = battery_bottom_y + battery_height;
    color([0.62, 0.68, 0.72])
        for (x = [-120, 160]) {
            translate([x, top, -93]) cube([30, 3, 274]);
            for (z = [-93, 178])
                translate([x, battery_bottom_y, z]) cube([30, top + 3 - battery_bottom_y, 3]);
        }
}

module battery_service_mounts() {
    // Fixed pin bracket on the rear frame rail end; the pin arrests travel only.
    color([0.3, 0.45, 0.6])
        difference() {
            translate([-255, 130, 90]) cube([30, 10, 110]);
            translate([lock_pin_x, 129, lock_pin_z]) rotate([-90, 0, 0]) cylinder(d = 12.5, h = 12);
        }
}

module slide_stage(stage = 0, sweep = 0) {
    // Simplified flat nested C sections stacked under the tray.
    w = slide_width - stage * 10;
    color(stage == 0 ? [0.35, 0.4, 0.45] : [0.68, 0.7, 0.73])
        translate([slide_center_x - slide_width / 2 + stage * 5,
                   slide_bottom_y + stage * 6.3, slide_min_z])
            union() {
                cube([w, 2, slide_length + sweep]);
                for (dx = [0, w - 2])
                    translate([dx, 0, 0]) cube([2, 6.1, slide_length + sweep]);
                if (stage == 2)
                    // Float pad: picks the tray up only once it leaves the fixed seats.
                    translate([slide_width / 2 - stage * 5 - 22, 2, 0])
                        cube([44, battery_bottom_y - service_tray_thickness - 1
                              - slide_bottom_y - stage * 6.3 - 2, slide_length + sweep]);
            }
}

module battery_lock_strike() {
    // Tray-level strip bolted to the tray top behind the battery terminals.
    color([0.65, 0.45, 0.18])
        difference() {
            translate([lock_pin_x - 8, battery_bottom_y, -125]) cube([16, 8, 330]);
            for (z = [lock_pin_z, lock_pin_z - service_stroke])
                translate([lock_pin_x, battery_bottom_y - 0.1, z])
                    rotate([-90, 0, 0]) cylinder(d = 12.5, h = 8.2);
        }
}

module battery_lock_pin() {
    // Spring pin from below through bracket, tray notch and strip; knob withdraws 35 mm down.
    color([0.85, 0.55, 0.15]) {
        translate([lock_pin_x, 128, lock_pin_z]) rotate([-90, 0, 0]) cylinder(d = 12, h = 43);
        translate([lock_pin_x, 122, lock_pin_z]) rotate([-90, 0, 0]) cylinder(d = 25, h = 6);
    }
}

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

module battery_power_harness(grow = 0) {
    // Fixed leads: ring lugs bolted directly on the battery studs (unbolt first).
    d = 12 + 2 * grow;
    stud_end = contactor_min[0] + contactor_size[0] + 7 + 6;
    ty = controller_harness_y;
    tz = controller_terminal_z;
    color([0.8, 0.08, 0.04]) {
        translate([-229 - grow, battery_terminal_y, battery_terminal_z[1]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path([[-235, battery_terminal_y, battery_terminal_z[1]],
            [-235, contactor_stud_y[0], battery_terminal_z[1]],
            [-235, contactor_stud_y[0], contactor_stud_z],
            [stud_end, contactor_stud_y[0], contactor_stud_z]], diameter = d);
        cable_path([[stud_end, contactor_stud_y[1], contactor_stud_z],
            [stud_end, 405, contactor_stud_z], [stud_end, 405, -30], [-60, ty, -30],
            [controller_terminal_x[0], ty, -30], [controller_terminal_x[0], ty, tz]], diameter = d);
    }
    color([0.08, 0.08, 0.09]) {
        translate([-229 - grow, battery_terminal_y, battery_terminal_z[0]])
            x_cylinder(16 + 2 * grow, 12 + 2 * grow);
        cable_path([[-235, battery_terminal_y, battery_terminal_z[0]],
            [-235, battery_terminal_y, -65], [-235, 405, -65], [-60, ty, -65],
            [controller_terminal_x[4], ty, -65], [controller_terminal_x[4], ty, tz]], diameter = d);
    }
}

module motor_power_harness() {
    // Direct phase leads, motor terminal face to controller U/V/W; inside the track side silhouette.
    for (i = [0 : 2]) {
        lane = 118 + i * 18;
        x = motor_landing[0] + i * 18;
        color(i == 0 ? [0.8, 0.65, 0.05] : i == 1 ? [0.12, 0.55, 0.18] : [0.08, 0.3, 0.8])
            cable_path([[x, motor_landing[1], motor_landing[2]], [x, 300, motor_landing[2]],
                [x, 300, lane], [-300, 395, lane], [-235, 425, lane],
                [controller_terminal_x[i + 1], controller_harness_y, lane],
                [controller_terminal_x[i + 1], controller_harness_y, controller_terminal_z]]);
    }
}

module removal_arrow() {
    // Annotation only, not a physical component.
    translate([battery_center_x, battery_bottom_y + battery_height / 2,
               carrier_center_z + battery_width / 2 + 5])
        color([0.1, 0.45, 0.85])
            cylinder(h = 95, d = 5);
    translate([battery_center_x, battery_bottom_y + battery_height / 2,
               carrier_center_z + battery_width / 2 + 100])
        color([0.1, 0.45, 0.85])
            cylinder(h = 18, d1 = 16, d2 = 0);
}

module pod_component(id) {
    if (id == "track")
        color([0.12, 0.12, 0.14, 0.65]) track_loop();
    else if (id == "drive-drum") main_driven_roller(drive_center[0]);
    else if (id == "idler") idler_placeholder(idler_center[0]);
    else if (id == "motor") hpm5000b_motor_envelope(drive_center[0]);
    else if (id == "output-carrier") final_carrier_to_drum(drive_center[0]);
    else if (id == "upper-roller")
        translate([upper_roller_center[0], upper_roller_center[1], 0])
            color([0.22, 0.55, 0.34, 0.9])
                wheel_pair(upper_support_roller_diameter, wheel_tread_width, true);
    else if (id == "pod-carrier") pod_carrier();
    else if (id == "pod-frame") pod_frame();
    else if (id == "motor-mount") motor_reaction_mount();
    else if (id == "lower-roller-supports") lower_roller_supports();
    else if (id == "upper-roller-support") upper_roller_support();
    else if (id == "idler-carriage") idler_carriage();
    else if (id == "idler-spring") idler_spring();
    else if (id == "battery") battery_envelope();
    else if (id == "battery-tray") battery_service_tray();
    else if (id == "battery-hold-down") battery_hold_down();
    else if (id == "controller-support") controller_support();
    else if (id == "main-contactor") main_contactor();
    else if (id == "slide-fixed") { slide_stage(0); battery_service_mounts(); }
    else if (id == "slide-middle") slide_stage(1);
    else if (id == "slide-inner") slide_stage(2);
    else if (id == "tray-lock-pin") battery_lock_pin();
    else if (id == "tray-lock-strike") battery_lock_strike();
    else if (id == "controller") traction_controller();
    else if (id == "battery-harness") battery_power_harness();
    else if (id == "motor-harness") motor_power_harness();
    else if (id == "removal-arrow") removal_arrow();
    else {
        for (stage = [0 : planetary_stage_count - 1])
            if (id == str("planetary-", stage + 1))
                planetary_stage(drive_center[0], stage);
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
