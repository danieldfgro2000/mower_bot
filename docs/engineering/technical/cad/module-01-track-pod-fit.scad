/*
 Module 01 single-pod fit study; millimetres.

 Unqualified sourcing-candidate fit study, not a fabrication model or release.
 Owners: running-gear.md S34/S37/S38, propulsion.md S24, batteries.md S30.
 Track: 200x72x40 code interpreted as width/pitch/links; belt mid-thickness
 is an assumed pitch line. Link profile follows the PowerTrack R2 roller
 drawing: twin trapezoidal horns, centre lands with open sprocket windows and
 staggered tread blocks, scaled from an undimensioned illustration (HOLD).
 The 350 mm drive OD remains flexible; 16 central drive teeth enter the link
 windows but are illustrative, not a matched track sprocket.
 Idler: two Interwheel 161.540 candidate envelopes (200 OD, 50 tread, 60 hub).
 Lower rollers: paired 120 mm PC/TPU study wheels, 40 wide, 8 mm tread,
 two 6004 envelopes each, in the 70 mm R2 groove. Horn and groove dimensions
 require measurement of the delivered track.
 Motor: HPM5000B 206x126 body, 22.3x53 shaft, 5x43 keyway and four M8
 openings on 148 PCD from GD-JS-03000001; hole depth, keyway axial offset
 and clocking are illustrative. No thread, thermal or structural detail.
 Battery: DC HOUSE listing body 504x268x233 on an open 8 mm steel tray (no box).
 It is rotated 180 degrees upright; custom removable base-clamp envelopes are
 shown, but the pack's flange and clamp locking interfaces are not modeled.
 The tray rests on fixed seats; one flat telescopic ball
 guide beneath it carries it only during extraction (rating and seat-to-guide
 transfer HOLD). Tray-level two-position pin. Battery leads bolt directly to the
 terminals and run via a placeholder E-stop contactor to the controller; motor
 phases run directly to the controller. Terminal offsets remain assumptions.
 Three 66:1 planetary stages have trapezoidal illustrative teeth; no qualified tooth profiles,
 interstage bearing supports, coupling or brake installation. U supports, tray
 frame, motor reaction plate and two fixed upper masts are custom proposals.
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
    "upper-roller", "upper-roller-2", "pod-carrier", "battery", "removal-arrow",
    "lower-roller-supports", "pod-frame", "motor-mount",
    "idler-carriage", "idler-spring", "upper-roller-support",
    "battery-tray", "battery-base-clamps", "slide-fixed", "slide-middle", "slide-inner",
    "tray-lock-pin", "tray-lock-strike", "controller", "controller-support", "main-contactor",
    "estop-button", "estop-mount",
    "battery-harness", "motor-harness", "motor-harness-supports"
];

// Part files share one global scope; parameters must be included first.
include <module-01-track-pod/parameters.scad>
include <module-01-track-pod/running-gear.scad>
include <module-01-track-pod/drive-train.scad>
include <module-01-track-pod/frame.scad>
include <module-01-track-pod/idler-tensioner.scad>
include <module-01-track-pod/battery-cassette.scad>
include <module-01-track-pod/electrical.scad>

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
                wheel_pair(upper_support_roller_diameter, printed_wheel_tread_width, true);
    else if (id == "upper-roller-2")
        translate([upper_roller_2_center[0], upper_roller_2_center[1], 0])
            color([0.22, 0.55, 0.34, 0.9])
                wheel_pair(upper_support_roller_diameter, printed_wheel_tread_width, true);
    else if (id == "pod-carrier") pod_carrier();
    else if (id == "pod-frame") pod_frame();
    else if (id == "motor-mount") motor_reaction_mount();
    else if (id == "lower-roller-supports") lower_roller_supports();
    else if (id == "upper-roller-support") upper_roller_support();
    else if (id == "idler-carriage") idler_carriage();
    else if (id == "idler-spring") idler_spring();
    else if (id == "battery") battery_envelope();
    else if (id == "battery-tray") battery_service_tray();
    else if (id == "battery-base-clamps") battery_base_clamps();
    else if (id == "controller-support") controller_support();
    else if (id == "main-contactor") main_contactor();
    else if (id == "estop-button") estop_button();
    else if (id == "estop-mount") estop_mount();
    else if (id == "slide-fixed") { slide_stage(0); battery_service_mounts(); }
    else if (id == "slide-middle") slide_stage(1);
    else if (id == "slide-inner") slide_stage(2);
    else if (id == "tray-lock-pin") battery_lock_pin();
    else if (id == "tray-lock-strike") battery_lock_strike();
    else if (id == "controller") traction_controller();
    else if (id == "battery-harness") battery_power_harness();
    else if (id == "motor-harness") motor_power_harness();
    else if (id == "motor-harness-supports") motor_harness_supports();
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
