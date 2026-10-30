// Module 01 track-pod fit study part: R2 track loop, toothed drive drum, idler wheels, paired bearing wheels and lower rollers.
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

// Width-profile hulls of the convex path offsets. Outer body: ground-edge chamfer.
module track_rubber() {
    shoulder_z = track_inner_shoulder[0];
    difference() {
        hull() {
            linear_extrude(height = track_width - 2 * track_ground_chamfer[0], center = true)
                capsule_2d(belt_thickness / 2);
            linear_extrude(height = track_width, center = true)
                capsule_2d(belt_thickness / 2 - track_ground_chamfer[1]);
        }
        linear_extrude(height = track_width + 2, center = true)
            capsule_2d(-belt_thickness / 2);
        // Inner-face shoulders lift off the wheels towards both belt edges.
        for (side = [-1, 1])
            mirror([0, 0, side > 0 ? 0 : 1])
                hull() {
                    translate([0, 0, shoulder_z - 0.01])
                        linear_extrude(height = 0.01) capsule_2d(-belt_thickness / 2);
                    translate([0, 0, track_width / 2 - 2])
                        linear_extrude(height = 3)
                            capsule_2d(-belt_thickness / 2 + track_inner_shoulder[1]);
                }
        // Open centre between the horn pairs; links bridge it at each pitch.
        translate([-2000, -1000, -link_land_width / 2])
            cube([4000, 2000, link_land_width]);
    }
}

// One R2 metal link in the local track frame: X outward normal, Y travel, Z width.
module track_link() {
    translate([-belt_thickness / 2, -link_land_length / 2, -link_land_width / 2 - 0.5])
        cube([belt_thickness / 2, link_land_length, link_land_width + 1]);
    for (side = [-1, 1])
        hull() {
            translate([-belt_thickness / 2 + 0.99, -horn_base_length / 2,
                       side * horn_center_offset - horn_base_width / 2])
                cube([0.01, horn_base_length, horn_base_width]);
            translate([-belt_thickness / 2 - horn_height + horn_tip_width / 2, 0,
                       side * horn_center_offset])
                rotate([90, 0, 0])
                    cylinder(d = horn_tip_width, h = horn_tip_length, center = true);
        }
}

// Staggered transverse block; embedded 5 mm so it stays attached on small wraps.
module tread_block(side) {
    translate([belt_thickness / 2 - 5, -tread_block_length / 2,
               side > 0 ? tread_block_z[0] : -tread_block_z[1]])
        cube([tread_block_height + 5, tread_block_length,
              tread_block_z[1] - tread_block_z[0]]);
}

module track_frame_place(s) {
    frame = track_frame(s);
    translate([frame[0][0], frame[0][1], 0])
        rotate([0, 0, frame[1]]) children();
}

module track_loop() {
    track_rubber();
    for (i = [0 : track_links - 1]) {
        track_frame_place(i * track_pitch) {
            track_link();
            tread_block(1);
        }
        track_frame_place(i * track_pitch + track_pitch / 2) tread_block(-1);
    }
}

module main_driven_roller(x) {
    root_radius = 153; // 3 mm under the wrapped horn tips at r 156.
    web_z = [guide_gap_placeholder / 2 - 1, guide_gap_placeholder / 2 + 7];
    translate([x, roller_radius, 0])
        color([0.72, 0.43, 0.12, 0.85]) {
            // Running bands carry the rubber outboard of the R2 horn pair.
            difference() {
                cylinder(d = roller_outer_diameter, h = roller_width, center = true);
                cylinder(
                    d = drive_drum_inner_diameter,
                    h = roller_width + 1,
                    center = true
                );
                cylinder(d = roller_outer_diameter + 2, h = guide_gap_placeholder, center = true);
            }
            difference() {
                union() {
                    cylinder(r = root_radius, h = 2 * web_z[1], center = true);
                    for (side = [-1, 1])
                        translate([0, 0, side > 0 ? web_z[0] : -web_z[1]])
                            cylinder(r = drive_drum_inner_diameter / 2 + 5, h = web_z[1] - web_z[0]);
                    cylinder(r = drive_drum_inner_diameter / 2 + 5, h = 10, center = true);
                    // Sixteen schematic teeth enter the open windows between link lands.
                    for (tooth = [0 : 15])
                        rotate([0, 0, normal_angle(0, roller_center_spacing) + (tooth + 0.5) * 360 / 16])
                            linear_extrude(height = 10, center = true)
                                polygon([[165, -10], [roller_radius, -5],
                                         [roller_radius, 5], [165, 10]]);
                }
                cylinder(r = 150.2, h = 2 * web_z[1] + 2, center = true);
            }
        }
}

module bearing_wheel(diameter, hub_width, printed = false, tread_width = wheel_tread_width) {
    core_diameter = diameter - (printed ? 2 * printed_tread_thickness : 0);
    difference() {
        union() {
            cylinder(d = core_diameter, h = tread_width, center = true);
            if (printed)
                color([0.15, 0.16, 0.18])
                    difference() {
                        cylinder(d = diameter, h = tread_width - 2, center = true);
                        cylinder(d = core_diameter - 1, h = tread_width + 1, center = true);
                    }
            if (hub_width > tread_width)
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

// Printed wheels are narrower than the S37 catalog idler; both sit in the R2 groove.
module wheel_pair(diameter, hub_width, printed = false) {
    tread_width = printed ? printed_wheel_tread_width : wheel_tread_width;
    for (side = [-1, 1])
        translate([0, 0, side * (guide_gap_placeholder + tread_width) / 2])
            bearing_wheel(diameter, hub_width, printed, tread_width);
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
            wheel_pair(lower_support_roller_diameter, printed_wheel_tread_width, true);
}
