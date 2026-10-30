// Module 01 track-pod fit study part: Track loop, drive drum, idler wheels, paired bearing wheels and lower rollers.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module capsule_2d(offset) {
    hull() {
        for (i = [0 : path_count - 1])
            translate(path_centers(roller_center_spacing)[i])
                circle(r = path_radii[i] + offset);
    }
}

// Position and outward-normal angle at distance s around the assumed pitch loop.
function segment_length(segment) =
    segment % 2 == 0 ? edge_length(segment / 2, roller_center_spacing) :
    let(i = (floor(segment / 2) + 1) % path_count)
    path_radii[i] * arc_angle(i, roller_center_spacing) * PI / 180;

function track_frame(s, segment = 0) =
    s > segment_length(segment) && segment < 2 * path_count - 1
        ? track_frame(s - segment_length(segment), segment + 1) :
    let(i = floor(segment / 2), j = (i + 1) % path_count,
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
