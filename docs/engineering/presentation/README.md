# MowerBot engineering pitch

<a id="document-overview"></a>

**Status:** unqualified engineering study. Dimensions and listed prices
are sourcing references, not a released configuration or delivered quote.

## Engineering pitch

A supervised, low-speed tracked platform built around two self-contained
pods and a width-adjustable frame. The first implementation direction is
a battery-electric chassis carrying the DAC 9100 mower; autonomy and
production readiness are not claimed.

**Explore:** [Interactive 3D viewer](viewer/index.html?mode=presentation) · [All component cards](parts.md) · [Technical design and evidence](../technical/modules/README.md) · [Engineering agent guide](../agents/README.md)

## Component shortlist

| Component | Current presentation status |
| --- | --- |
| [Open moving battery tray (8 mm steel proposal)](parts.md#battery-tray) | Custom 8 mm open steel tray proposal on fixed seats; the battery box is removed. Plate load screen is not qualification of seats, brackets, joints or service stability. |
| [Slotted battery-base clamp concepts (four, unqualified)](parts.md#battery-base-clamps) | Slotted-jaw and hand-knob concepts only; actual flange grip, captive hardware, locking and restraint loads are unverified. |
| [Fixed flat ball-guide stage and pin bracket](parts.md#slide-fixed) | Single flat-mounted Accuride guide under the tray; carries the tray only during extraction. Flat rating (about 27.2 kg) is below the 44.9 kg pack, so the guide rating is HOLD. Excluded from baseline costs. |
| [Intermediate ball-guide stage (half travel)](parts.md#slide-middle) | See technical scope; this is a study element. |
| [Inner ball-guide stage and float pad](parts.md#slide-inner) | See technical scope; this is a study element. |
| [Tray locking pin (work / extract)](parts.md#tray-lock-pin) | Tray-level two-position positive pin proposal; retention, end stops and engagement indication are not released. |
| [Tray-level locking strip (two 12.5 mm bores)](parts.md#tray-lock-strike) | See technical scope; this is a study element. |
| [EZ-A48500 on fixed frame support (published case envelope)](parts.md#controller) | Published A-series envelope; terminal offsets, thermal path and exact supplied revision require confirmation. |
| [Fixed controller and contactor support (frame-mounted)](parts.md#controller-support) | See technical scope; this is a study element. |
| [E-stop main contactor (placeholder envelope)](parts.md#main-contactor) | E-stop-controlled main contactor envelope only; rating, precharge, coil supply and part selection are HOLD. |
| [Emergency stop operator (outboard, beside controller)](parts.md#estop-button) | E-stop operator envelope only; operator part, enclosure rating and coil wiring are HOLD. |
| [E-stop bracket and track finger guard](parts.md#estop-mount) | Study bracket and finger guard tied to the fixed controller support; material and fixings are HOLD. |
| [Battery leads: red P+ via contactor, black P- direct (fixed, bolted)](parts.md#battery-harness) | See technical scope; this is a study element. |
| [Motor phase leads direct to controller (fixed)](parts.md#motor-harness) | See technical scope; this is a study element. |
| [Rubber track (200x72x40 candidate fit study)](parts.md#track) | Current CAD candidate; modeled clashes cleared with provisional margins. Profile and load compatibility remain unqualified. |
| [Drive drum (350 mm placeholder)](parts.md#drive-drum) | See technical scope; this is a study element. |
| [Idler (paired 200x50 wheels; candidate)](parts.md#idler) | Priced wheel candidate; track profile and load fit unverified. |
| [HPM5000B (body, shaft and mounting pattern)](parts.md#motor) | Main cost/study candidate; exact configuration and duty unqualified. |
| [Planetary stage 1 (pitch circles)](parts.md#planetary-1) | See technical scope; this is a study element. |
| [Planetary stage 2 (pitch circles)](parts.md#planetary-2) | See technical scope; this is a study element. |
| [Planetary stage 3 (pitch circles)](parts.md#planetary-3) | See technical scope; this is a study element. |
| [Final carrier to drum (schematic)](parts.md#output-carrier) | See technical scope; this is a study element. |
| [Lower roller 1 (paired 120x50 PC/TPU study)](parts.md#lower-roller-1) | Owner-selected printed concept; loading and durability unqualified. |
| [Lower roller 2 (paired 120x50 PC/TPU study)](parts.md#lower-roller-2) | See technical scope; this is a study element. |
| [Lower roller 3 (paired 120x50 PC/TPU study)](parts.md#lower-roller-3) | See technical scope; this is a study element. |
| [Lower roller 4 (paired 120x50 PC/TPU study)](parts.md#lower-roller-4) | See technical scope; this is a study element. |
| [Front fixed upper roller (paired 70x50 study)](parts.md#upper-roller) | Front fixed return roller at the 70 mm minimum, with U support and inboard mast; printed capacity, bend radius and structural loads unqualified. |
| [Rear fixed upper roller (paired 70x50 study)](parts.md#upper-roller-2) | Rear fixed return roller above the battery at the 70 mm minimum; printed capacity, bend radius and structural loads unqualified. |
| [Battery tray (524x288x10 proposed plate)](parts.md#pod-carrier) | See technical scope; this is a study element. |
| [Lower roller U supports and axles (proposal)](parts.md#lower-roller-supports) | Four proposed U supports; unchanged 120 mm wheels. Axle fits and structural capacity unqualified. |
| [Connected motor-to-idler tray frame (proposal)](parts.md#pod-frame) | Reinforced custom frame proposal; local beam screens only. Joints and complete two-pod fit unqualified; no separately established price. |
| [Motor reaction plate (290x16 proposal)](parts.md#motor-mount) | Custom reaction-plate proposal on the published motor pattern; fasteners and loads unqualified. |
| [Sliding idler yoke and sleeves (proposal)](parts.md#idler-carriage) | Sliding front-idler proposal with geometric stops; usable belt travel and retained bearing fits unqualified. |
| [Idler spring, guide and reaction seat (proposal)](parts.md#idler-spring) | Schematic compression spring, not a selected commercial part or qualified tension setting; no established price. |
| [Fixed upper U supports and inboard masts (proposal)](parts.md#upper-roller-support) | Fixed U support, axle and braced inboard mast proposal; loads and joints unqualified. |
| [DC HOUSE battery (504x268x233 listing envelope)](parts.md#battery) | Listing body clears the revised CAD. Supplied dimensions, terminals, restraints and complete vehicle fit remain on hold. |
| [Battery removal arrow (annotation)](parts.md#removal-arrow) | See technical scope; this is a study element. |

Component cards show only decision-relevant dimensions, public price references and direct sources. Their technical links retain detailed assumptions, compatibility questions and holds.
