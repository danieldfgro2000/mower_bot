// Module 01 track-pod fit study part: Shared parameters, derived track-path geometry, clearance echoes and asserts.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

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
// Minimum printed upper wheel: 20 mm lug + 10 mm shaft radius + 5 mm gap; load and
// belt bend radius HOLD. Front return roller and a second roller above the battery.
upper_support_roller_diameter = 70;
upper_roller_center = [245, 510];
upper_roller_2_center = [-195, 510];
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
carrier_length = battery_length + 2 * carrier_edge_margin;
carrier_width = battery_width + 2 * carrier_edge_margin;
carrier_center_z = (carrier_width - track_width) / 2;
service_stroke = 305; // Accuride DZ9301-0012U-E supplier SL/TR.
service_tray_thickness = 8; // Proposed S235 steel; see conservative load screen.
service_mass_screen_kg = 85; // Battery, tray, inner guide, strip and hardware.
// Four custom removable clamp concepts; pack flange geometry and holding load are unknown.
battery_clamp_x = [battery_center_x - battery_length / 2 - 11,
                   battery_center_x + battery_length / 2 + 11];
battery_clamp_z = [carrier_center_z - 34, carrier_center_z + 96];
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
// Flat on the roof, with the drawing's 164 mm side along X and 200 mm across Z.
controller_length = 200;
controller_height = 164;
controller_depth = 70.47;
controller_origin = [battery_center_x - controller_height / 2, 411,
                     carrier_center_z - controller_length / 2];
// B+, U, V, W, B- order from the A-series drawing; local centers are approximate.
controller_terminal_offset = [25, 51, 100, 151, 177];
controller_terminal_x = controller_origin[0] + 100;
controller_terminal_z = [for (offset = controller_terminal_offset)
    controller_origin[2] + offset];
controller_terminal_face_y = controller_origin[1] + controller_depth;
controller_harness_y = controller_terminal_face_y + 6;
// Placeholder E-stop main contactor; top studs, rating and precharge are unverified.
contactor_min = [140, 411, -70];
contactor_size = [45, 70, 70];
contactor_stud_x = [175, 150]; // Battery P+ in / controller B+ out.
contactor_stud_z = -35;
// E-stop enclosure envelope (X, Z footprint on the platform; Y fixed by the support).
estop_min = [130, 0, 135];
estop_size = [65, 60, 65];
estop_guard_z = 105;
// Shared phase riser behind the centered controller.
harness_riser_x = controller_origin[0] - 16;
battery_terminal_y = 348; // Photo-based short-face landing, not a released stud datum.
battery_terminal_x = battery_center_x + battery_length / 2 + 18;
// The 180-degree upright rotation reverses both the terminal end and their Z positions.
battery_terminal_z = [for (z = [-35, 123]) 2 * carrier_center_z - z]; // P- / P+.
motor_landing = [-440, 265, 118]; // 12 mm cable envelope tangent to assumed Z=112 motor face.

roller_radius = track_path_diameter / 2;
idler_path_radius = (idler_outer_diameter + belt_thickness) / 2;
upper_path_radius = (upper_support_roller_diameter + belt_thickness) / 2;
drive_center = [-440, roller_radius];
// Loop order: drive, idler, front upper, rear upper. Edges: 0 bottom, 1 front
// return, 2 top, 3 rear return.
path_radii = [roller_radius, idler_path_radius, upper_path_radius, upper_path_radius];
path_count = len(path_radii);
function path_centers(spacing) =
    [drive_center, [drive_center[0] + spacing, idler_path_radius],
     upper_roller_center, upper_roller_2_center];
function sum_values(values, i = 0) =
    i == len(values) ? 0 : values[i] + sum_values(values, i + 1);
function tangent_normal(i, spacing) =
    let(centers = path_centers(spacing),
        j = (i + 1) % path_count,
        delta = centers[j] - centers[i],
        distance = norm(delta),
        k = (path_radii[i] - path_radii[j]) / distance,
        q = sqrt(1 - k * k))
    [delta[0] * k + delta[1] * q, delta[1] * k - delta[0] * q] / distance;
function normal_angle(i, spacing) =
    let(n = tangent_normal(i, spacing)) atan2(n[1], n[0]);
function edge_length(i, spacing) =
    let(centers = path_centers(spacing), j = (i + 1) % path_count)
    sqrt(pow(norm(centers[j] - centers[i]), 2) - pow(path_radii[i] - path_radii[j], 2));
function arc_angle(i, spacing) =
    (normal_angle(i, spacing) - normal_angle((i + path_count - 1) % path_count, spacing)
        + 360) % 360;
function loop_length(spacing) =
    sum_values([for (i = [0 : path_count - 1])
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
       "Track loop does not bracket the proposed four-wheel layout");
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
echo("Nominal four-circle pitch-loop closure error (mm): ",
     loop_length(roller_center_spacing) - nominal_pitch_loop);
echo("Battery to front/rear return guide-tip envelopes, normal gaps (mm): ",
     return_guide_clearance(1), return_guide_clearance(3));
echo("Lower roller to tray underside gap (mm): ", roller_carrier_clearance);
echo("Motor/stages/carrier stack and inboard drum remainder (mm): ",
     axial_stack_length, inboard_axial_remainder);
echo("Motor body outboard overhang for reaction flange (mm): ", motor_reaction_thickness);
echo("Fixed upper roller centres, front/rear (mm): ", upper_roller_center, upper_roller_2_center);
echo("Idler geometric stop positions (mm from nominal): ",
     -idler_clearance_stroke, idler_clearance_stroke);
echo("Spring seat separation at nominal/min/max stroke (mm): ",
     idler_center[0] - 114 - spring_fixed_face_x,
     idler_center[0] - 114 - spring_fixed_face_x - idler_clearance_stroke,
     idler_center[0] - 114 - spring_fixed_face_x + idler_clearance_stroke);
echo("Battery bottom and outboard centre (mm): ", battery_bottom_y, carrier_center_z);
assert(min(return_guide_clearance(1), return_guide_clearance(3)) >= 35,
       "Return clearance below 20 mm running, 5 mm deflection and 10 mm motion reserve");
assert(inboard_axial_remainder >= 5, "Reducer exceeds inboard study envelope");
