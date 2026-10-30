// Module 01 track-pod fit study part: Battery envelope, tray, base-clamp concepts, guide and lock.
// Included by ../module-01-track-pod-fit.scad; not a standalone model.
// Shares its global parameters (parameters.scad); millimetres.

module battery_envelope() {
    translate([battery_center_x, battery_bottom_y, carrier_center_z])
        rotate([0, 180, 0])
        translate([-battery_length / 2, 0, -battery_width / 2])
        color([0.9, 0.55, 0.12, 0.8])
            cube([battery_length, battery_height, battery_width]);
}

module battery_service_tray() {
    color([0.38, 0.45, 0.52])
        difference() {
            union() {
                translate([-253, battery_bottom_y - service_tray_thickness, -100])
                    cube([550, service_tray_thickness, 288]);
                for (z = battery_clamp_z)
                    translate([battery_center_x + battery_length / 2,
                               battery_bottom_y - service_tray_thickness, z - 9])
                        cube([11, service_tray_thickness, 18]);
            }
            translate([idler_center[0] - idler_clearance_stroke, idler_path_radius, 0])
                cylinder(d = idler_outer_diameter + 10, h = 170, center = true);
            // Pin clearance notch at the WORK position.
            translate([lock_pin_x, battery_bottom_y - service_tray_thickness - 1, lock_pin_z])
                rotate([-90, 0, 0]) cylinder(d = 14, h = service_tray_thickness + 2);
        }
}

module battery_base_stud(end, lane) {
    x = battery_clamp_x[end];
    z = battery_clamp_z[lane];
    translate([x, battery_bottom_y + 3, z])
        rotate([-90, 0, 0]) cylinder(d = 6, h = 20);
}

module battery_base_mount(end, lane) {
    x = battery_clamp_x[end];
    z = battery_clamp_z[lane];
    translate([x - 3, battery_bottom_y, z - 7]) cube([6, 3, 14]);
    battery_base_stud(end, lane);
}

module battery_base_jaw(end, lane) {
    x = battery_clamp_x[end];
    z = battery_clamp_z[lane];
    difference() {
        translate([end == 0 ? x - 5.5 : x - 9.5, battery_bottom_y + 6, z - 7])
            cube([15, 4, 14]);
        translate([x, battery_bottom_y + 5.9, z])
            rotate([-90, 0, 0]) cylinder(d = 7, h = 4.2);
        translate([end == 0 ? x : x - 10, battery_bottom_y + 5.9, z - 3.5])
            cube([10, 4.2, 7]);
    }
}

module battery_base_knob(end, lane) {
    x = battery_clamp_x[end];
    z = battery_clamp_z[lane];
    difference() {
        union() {
            translate([x, battery_bottom_y + 10, z])
                rotate([-90, 0, 0]) cylinder(d = 14, h = 4);
            translate([x - 2, battery_bottom_y + 14, z - 10]) cube([4, 3, 20]);
        }
        translate([x, battery_bottom_y + 9.9, z])
            rotate([-90, 0, 0]) cylinder(d = 7, h = 7.2);
    }
}

module battery_base_clamp(end, lane) {
    // Custom slotted jaw and tool-free knob concept; the pack flange, threads,
    // secondary lock and actual holding loads remain unmodeled and unqualified.
    color([0.75, 0.48, 0.18]) {
        battery_base_mount(end, lane);
        battery_base_jaw(end, lane);
        battery_base_knob(end, lane);
    }
}

module battery_base_clamps() {
    for (end = [0 : 1])
        for (lane = [0 : 1])
            battery_base_clamp(end, lane);
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
