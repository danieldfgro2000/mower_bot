# Frame, scissor and spine

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** The pod frames, scissor and spine carry the drive and implements.
Stock is budgeted, but sections, mounting holes, joints, and load ratings are
not released. Start with the physical part, then follow its attachment.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Pod, scissor and spine stock](frame.md#ps04-frame-stock-and-weldments) | DIY weldments; stock quantities are not a cut list | [Stock costs](frame.md#0104-frame-stock-and-mounting-plates) · [Material/drawing requirements](frame.md#ps04-frame-stock-and-weldments) | [Motor mounting plates](frame.md#motor-and-reducer-mounting-plates) |
| [Motor and reducer plates](frame.md#motor-and-reducer-mounting-plates) | Proposed motor reaction plate and connected pod frame modeled; no released joints or reducer supports | [Plate stock in frame costs](frame.md#0104-frame-stock-and-mounting-plates) · [Mount definition](frame.md#motor-and-reducer-mounting-plates) | [Motor → reduction → track](../02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Scissor pivots](frame.md#ps05-scissor-pivots) | Fits, retention and loads open | [Pivot costs](frame.md#0105-scissor-pivots-locks-and-hard-stops) · [Pivot requirements](frame.md#ps05-scissor-pivots) | [Width screw and supports](../03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) |
| [Width locks and hard stops](frame.md#ps06-width-holding-and-hard-stops) | Positive holding unresolved; worm-only proposal not accepted | [Lock/stop provision](frame.md#0105-scissor-pivots-locks-and-hard-stops) · [Holding requirements](frame.md#ps06-width-holding-and-hard-stops) | [Powered adjustment and stopping](../03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| [Guards and fastening](frame.md#ps07-guards-and-edge-protection) | Guard geometry and joint schedule open | [Finishing costs](frame.md#0106-guards-fasteners-coatings-and-labels) · [Guards](frame.md#ps07-guards-and-edge-protection) · [Fasteners/coatings](frame.md#ps08-fasteners-coatings-and-labels) | [Moving screw guard](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) |
| [Lifting and recovery points](frame.md#ps32-installed-lifting-and-recovery-points) | Installed points; no certified lifting capacity established | [Point costs](frame.md#0107-installed-lifting-and-recovery-points) · [Load-path requirements](frame.md#ps32-installed-lifting-and-recovery-points) | [Loose straps and service supports](../07-workshop-and-support/workshop.md#ps33-transport-straps-and-service-supports) |

**3D study:** The tray and connected frame below are custom fit proposals, not
released weldments or mounting drawings. Open them in the [local CAD reader](../../cad/README.md).
The fixed 524 x 288 x 10 mm carrier sits at Y = 140-150 mm, leaving 10 mm
above the unchanged 120 mm lower wheels. It is locally relieved for the
idler's complete geometric stroke. The new
[8 mm open moving tray](../04-battery-and-charging/batteries.md#sliding-battery-cassette)
rests on it in WORK; a single flat guide under the tray carries the extended
load into notched frame rails.
The frame now connects the motor reaction plate, tray, roller brackets and
front-idler guides/reaction seat. Joint details, restraint, strength and
shock-load capacity remain unqualified; see the
[candidate fit margins](../../cad/README.md#modeled-dimensions-and-limits).

[![3D pod carrier plate](../../../presentation/viewer/previews/pod-carrier.png)](../../../presentation/viewer/index.html?component=pod-carrier)

| Connected tray frame | Motor reaction plate |
| --- | --- |
| [![3D pod frame](../../../presentation/viewer/previews/pod-frame.png)](../../../presentation/viewer/index.html?component=pod-frame) | [![3D motor reaction plate](../../../presentation/viewer/previews/motor-mount.png)](../../../presentation/viewer/index.html?component=motor-mount) |

**Further detail:** [Release requirements](frame.md#specification-and-inspection-requirements) ·
[Sourcing](frame.md#sourcing) · [Interfaces](frame.md#interfaces-with-other-scopes) ·
[Itemized costs](frame.md#detailed-module-costs) ·
[Procurement and holds](frame.md#procurement-and-release-holds)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS04: Frame stock and weldments

**Cost-ledger coverage:** CHS-001:CHS-006

**Part links:** [Stock costs](frame.md#0104-frame-stock-and-mounting-plates) ·
[Motor mounting plates](frame.md#motor-and-reducer-mounting-plates) ·
[Pod/battery packaging](../../width-and-slope-sizing.md#minimum-width-and-packaging).

**Required purchasing/manufacturing definition:** Tube grade/standard, section/wall and
cut lengths; plate grade/thickness, profiles and hole datums; weldment drawing, weld
size/process/sequence, distortion limits, drainage and corrosion access

**Receiving or first-article evidence:** Stock traceability and actual cut list;
reviewed weld procedure and required welder competence; dimensional and weld-inspection
records against approved criteria

#### Connected pod frame proposal

**Custom CAD proposal, 2026-10-29:** retain the 524 x 288 x 10 mm fixed carrier and
extend its structure from the stationary motor mount to the sliding front idler.
Two diagonal 8 mm plates run in the drum's central relief at Z = -25 to -17 mm,
ending 40 mm further rearward than the former arms; a 50 x 10 x 8 mm low tie
then joins the carrier below the moving cassette. This clears its enlarged
terminal alcove without disconnecting the frame. They connect to the motor
flange, not the rotating drum shell. The carrier front is locally relieved
5 mm beyond the idler's worst-case wheel envelope.

Longitudinal side rails occupy Z = 90-100 / -100 to -90 mm. Their rear portions
run at Y = 110-140 mm; the front portions step up to Y = 137-150 mm, overlapping
by 5 mm longitudinally and 3 mm vertically. This leaves **5 mm above the
idler yoke** at its highest point and connects to the roller bridges and tray.
Front guide blocks carry two 10 mm rods at Y = 120, Z = +/-104 mm. Proposed
20 mm stop collars limit the 48 mm sleeves to +/-15 mm longitudinal movement.
A transverse member at X = 225-233, Y = 134-140 mm joins the spring reaction
seat to both rails, with 4 mm over the lower wheel tops.

The [cassette guides](../04-battery-and-charging/batteries.md#sliding-battery-cassette)
are now one flat 76.2 mm guide under the tray at X = -26.1 to +50.1 mm,
between the middle lower-roller columns. Its fixed stage bears on the side
rails, which are notched above Y = 129.9 mm over that width, and the carrier
has a matching slot; the guide keeps at least 5 mm to the lower rollers and
U supports. A bracket under the tray's rear corner (X = -255 to -225 mm)
guides the lock pin up into a strip on the tray edge, at tray level.
Guide mounting holes, welds and end-stop details remain open. The 85 kg /
1.5 g extraction screen is **not** a frame or joint capacity proof.

The two [fixed upper supports](running-gear.md#fixed-upper-roller-support) join the
tray/frame with inboard masts; each extends **16 mm inside the track edge**.
The [two-pod width screen](../../width-and-slope-sizing.md#minimum-width-and-packaging)
includes that intrusion. Frame sections, welds/bolts, stop retention, torsion,
motor reaction, skid-steer side loads, spring forces and fatigue require a
released load assessment. Positive modeled connection volumes are not
structural qualification. These additions are unpriced custom proposals
beyond existing generic allowances; baseline quantities and totals are unchanged.

#### Motor and reducer mounting plates

**Current definition:** CHS-004 reserves mounting-plate stock, not a finished
motor bracket. Its budgeted mass does not establish a released mounting drawing.

**Custom CAD proposal:** a 250 mm OD x 12 mm reaction plate on the motor's
published front mounting face, with a 26 mm shaft aperture and four 9 mm
clearance holes on the published 148 mm PCD. Proposed 14 mm head recesses are
8 mm deep, leaving 4 mm of plate behind them. Hole clocking, fastener head
geometry/length/engagement, tool access and strength still need qualification.
The unchanged 206 x 126 mm motor body moves 12 mm outboard to make space;
the reducer stages stay put. See the [axial package](../02-drive-train/propulsion.md#cad-package-envelope).

For the [HPM5000B in-drum concept](../02-drive-train/propulsion.md#motor-to-track-mounting),
the motor housing and stationary ring gears need defined attachment and load
paths to the pod, while the final carrier drives the drum. The former
[48 V planetary package](../02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive)
requires its own mounting geometry; it is not interchangeable with this concept.

The [FDB 13 C fit screen](../02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment)
also requires a stationary brake reaction mount: motor and brake hole circles
differ, and the 19H7 brake hub does not fit the published Ø22.3 mm motor shaft.
The brake is not included in the existing CAD axial stack. Any approved adapter,
supported shaft and revised packaging remain unpriced beyond generic stock.

The released drawing must reconcile the exact motor/gearhead face and shaft
projection, output-bearing datums, frame load path, joint definition, cooling
clearance, and assembly/service access. Those inputs remain open; the CAD
envelope is not a fabrication drawing.

**Continue:** [HPM5000B price and specifications](../02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) ·
[Track-side connection](running-gear.md#drive-drum-study) ·
[Mounting-plate cost allowance](frame.md#0104-frame-stock-and-mounting-plates).

### PS05: Scissor pivots

**Cost-ledger coverage:** CHS-007:CHS-009

**Part links:** [Pivot costs](frame.md#0105-scissor-pivots-locks-and-hard-stops) ·
[Screw-to-scissor interface](../03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) ·
[Width holding](frame.md#ps06-width-holding-and-hard-stops).

**Required purchasing/manufacturing definition:** Pivot materials/heat treatment,
shaft/bushing fits, bearing lengths, wear limits, lubrication, retainers and replacement
access; shear/bearing/fatigue load assessment

**Receiving or first-article evidence:** Material and dimensions; pivot alignment, end
float, retention and movement measured against drawing tolerances

### PS06: Width holding and hard stops

**Cost-ledger coverage:** CHS-010:CHS-011

**Part links:** [Lock and stop costs](frame.md#0105-scissor-pivots-locks-and-hard-stops) ·
[Actuator holding conflict](../03-width-adjustment/width-adjustment.md#width-holding-and-stopping) ·
[Width feedback and limits](../03-width-adjustment/width-adjustment.md#ps12-width-feedback-and-limits).

**Required purchasing/manufacturing definition:** Reviewed positive holding arrangement,
its load path and engagement indication; fail-state and unintended-release prevention;
hard-stop strength and location; compatibility with powered adjustment

**Receiving or first-article evidence:** Approved design resolving the
[worm-only holding proposal](../03-width-adjustment/width-adjustment.md#width-holding-and-stopping);
holding and stop-load evidence, lock-state/interlock checks under an authorized test
plan; pin allowance alone cannot close this

### PS07: Guards and edge protection

**Cost-ledger coverage:** CHS-012:CHS-013

**Part links:** [Guard costs](frame.md#0106-guards-fasteners-coatings-and-labels) ·
[Local screw guard](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) ·
[Guard interlocks](../06-safety-controls-and-sensors/safety-controls.md#ps30-tilt-sensing-and-interlocks).

**Required purchasing/manufacturing definition:** Guard material/thickness,
opening/access geometry, fasteners, service access, edge treatment and clearances at
every width; separate fixed/removable guards

**Receiving or first-article evidence:** Drawing and hazard-review conformity;
retention, edge and access inspection; no implied impact containment from sheet area

### PS08: Fasteners, coatings and labels

**Cost-ledger coverage:** CHS-014:CHS-016

**Part links:** [Fastener and finish costs](frame.md#0106-guards-fasteners-coatings-and-labels) ·
[Mounting-joint definition](frame.md#motor-and-reducer-mounting-plates) ·
[Torque wrench and tools](../07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools).

**Required purchasing/manufacturing definition:** Fastener schedule with
thread/length/grade/coating, washers/nuts and locking method; joint-specific tightening
method/torque; surface preparation and coating system; durable width/identity labels

**Receiving or first-article evidence:** Fastener identity and installation record;
coating preparation/thickness criteria where specified; labels legible and consistent
with actual configuration, no unearned conformity marks

### PS32: Installed lifting and recovery points

**Cost-ledger coverage:** MNT-001:MNT-002

**Part links:** [Installed-point costs](frame.md#0107-installed-lifting-and-recovery-points) ·
[Transport straps and supports](../07-workshop-and-support/workshop.md#ps33-transport-straps-and-service-supports).

**Required purchasing/manufacturing definition:** Lifting/tie-down/recovery points
separately identified, load cases/directions, weld/fastener attachment and frame load
path, allowed configurations and recovery method

**Receiving or first-article evidence:** Reviewed drawings/load assessment, material and
installation records; rated point markings and inspection criteria; recovery bracket not
a certified lifting point by default

[↑ Back to document overview](frame.md#frame-scissor-and-spine)


## Sourcing

[DOLD mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) ·
[Dedeman stock and consumables (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) ·
[RS hardware and tools (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](frame.md#frame-scissor-and-spine)


## Procurement and release holds

Prepared supplier requests and release holds owned by this scope. Sending a request needs separate user approval; every hold is **OPEN**. Shared document control, manufacturing packs and cross-cutting holds stay in the [Chassis Build and Procurement Checklist](../../chassis-build-requirements.md#chassis-build-and-procurement-checklist).

### Q04: local fabrication/machining

**Requirements:** [Frame and holding](frame.md#specification-and-inspection-requirements),
[width motor/screw interfaces](../03-width-adjustment/width-adjustment.md#specification-and-inspection-requirements),
[drive shafts](../02-drive-train/propulsion.md#ps16-output-shafts-and-bearings),
[battery containment](../04-battery-and-charging/batteries.md#ps19-battery-enclosures-and-restraints), and
[electronics packaging](../05-power-cables-and-electronics/power-distribution.md#ps25-printed-enclosures-and-cable-glands)
with [thermal hardware](../05-power-cables-and-electronics/power-distribution.md#ps27-thermal-paths-and-enclosure-hardware).
**Leads:** [Dedeman](../../bom/sources.md#s06-dedeman-fabrication-supplies) · [DOLD mechanical parts](../../bom/sources.md#s04-dold-mechanical-parts).

**Specific response needed:** Quote only against released drawings: stock/cut yield,
outsourced precision operations and material/inspection documentation; owner
welding/printing labor stays separate

[↑ Back to document overview](frame.md#frame-scissor-and-spine)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Powered movement versus positive holding | [Width holding and stopping](../03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| Track loads and pod clearances | [Sprockets, rollers and tensioners](running-gear.md#ps02-sprockets-rollers-and-tensioners) · [Packaging screen](../../width-and-slope-sizing.md#minimum-width-and-packaging) |
| Loose equipment versus installed lifting points | [Transport straps and service supports](../07-workshop-and-support/workshop.md#ps33-transport-straps-and-service-supports) |

[↑ Back to document overview](frame.md#frame-scissor-and-spine)

## Detailed module costs

**Cost context:** [Module 01 totals](../../cost-breakdown.md#01--structure-and-running-gear) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-frame-stock"></a>

### 01.04 Frame stock and mounting plates

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [CHS-001 - Pod frame tube stock](frame.md#ps04-frame-stock-and-weldments) (30 kg) | €105.00 / A |
| [CHS-002 - Scissor frame tube stock](frame.md#ps04-frame-stock-and-weldments) (25 kg) | €87.50 / A |
| [CHS-003 - Longitudinal spine tube stock](frame.md#ps04-frame-stock-and-weldments) (15 kg) | €52.50 / A |
| [CHS-004 - Motor and reducer mounting plate stock](frame.md#ps04-frame-stock-and-weldments) (12 kg) | €48.00 / A |
| [CHS-005 - Pod side and base plate stock](frame.md#ps04-frame-stock-and-weldments) (20 kg) | €80.00 / A |
| [CHS-006 - Scissor link and gusset plate stock](frame.md#ps04-frame-stock-and-weldments) (10 kg) | €40.00 / A |
| **Module subtotal** | €413.00 |

<a id="cost-frame-pivots"></a>

### 01.05 Scissor pivots locks and hard stops

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [CHS-007 - Pivot shaft stock](frame.md#ps05-scissor-pivots) (4 kg) | €32.00 / A |
| [CHS-008 - Scissor pivot bushings](frame.md#ps05-scissor-pivots) (12 each) | €48.00 / A |
| [CHS-009 - Scissor pivot pins and retainers](frame.md#ps05-scissor-pivots) (6 each) | €48.00 / A |
| [CHS-010 - Unresolved positive width-lock provision](frame.md#ps06-width-holding-and-hard-stops) (4 each) | €48.00 / A |
| [CHS-011 - Width hard-stop material](frame.md#ps06-width-holding-and-hard-stops) (1 set) | €20.00 / A |
| **Module subtotal** | €196.00 |

<a id="cost-frame-finish"></a>

### 01.06 Guards fasteners coatings and labels

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [CHS-012 - Guard sheet and mesh](frame.md#ps07-guards-and-edge-protection) (3 m2) | €105.00 / A |
| [CHS-013 - Guard edge trim](frame.md#ps07-guards-and-edge-protection) (5 m) | €15.00 / A |
| [CHS-014 - Structural bolts nuts washers and retainers](frame.md#ps08-fasteners-coatings-and-labels) (1 lot) | €90.00 / A |
| [CHS-015 - Primer topcoat and corrosion-preparation materials](frame.md#ps08-fasteners-coatings-and-labels) (1 kit) | €60.00 / A |
| [CHS-016 - Width markings and identification labels](frame.md#ps08-fasteners-coatings-and-labels) (1 set) | €10.00 / A |
| **Module subtotal** | €280.00 |

<a id="cost-handling-points"></a>

### 01.07 Installed lifting and recovery points

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [MNT-001 - Chassis lifting and tie-down eyes](frame.md#ps32-installed-lifting-and-recovery-points) (4 each) | €60.00 / A |
| [MNT-002 - Prototype recovery towing bracket](frame.md#ps32-installed-lifting-and-recovery-points) (1 set) | €40.00 / A |
| **Module subtotal** | €100.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €989.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](frame.md#frame-scissor-and-spine)
