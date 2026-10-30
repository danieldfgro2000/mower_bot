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

**Revised custom CAD proposal:** retain the 524 x 288 x 10 mm fixed carrier core and
extend its structure from the stationary motor mount to the sliding front idler.
Two fixed 10 mm side wings extend the carrier to X = -300 and +350 mm:
the rear wing is X = -300 to -195, Z = 128-188 mm; the front is
X = 245-350, Z = 148-188 mm. The resulting 650 x 288 mm bounding envelope
is not a full rectangular plate. Both wings stay at Y = 140-150 mm.
They carry the new upper-roller posts; **the removable battery tray is unchanged**.
The wings avoid the drum and idler rather than extending a solid plate through them.

Four solid **25 x 25 mm** axial motor supports occupy X = -572.5 to -547.5
and -332.5 to -307.5 mm, with centers at Y = 145 and 225 mm.
They run from the plate envelope at Z = -26 mm to Z = 153 mm, giving
240 mm horizontal and 80 mm vertical spacing. Each intersects the actual
290 mm motor plate over its full **625 mm²** footprint, not a narrow rim sliver.
Two straight outboard rails and two straight cross-ties at Z = 128-153 mm
form a rectangular cradle. Its forward tie at X = -300 to -275 mm seats
on the rear fixed carrier wing, giving 700 mm² total cradle/carrier overlap.
No support attaches to the rotating drum. Four supports are separate reaction
paths, not proof of equal load sharing or redundant capacity after a joint fails.
The existing 20 x 20 mm rear crossmember at X = -241 to -221 mm joins
both 10 mm side rails and the fixed carrier. The rear rails run from Y = 90 to 140 mm, with 39.9 mm
of depth left under the slide notch. The carrier remains locally relieved for
the idler's geometric stroke.

The front guide supports no longer depend on a 13 x 10 mm stepped rail and
5 x 3 mm overlap. Each side has a solid **20 x 65 mm** web from approximately
X = 210.3 to 477.3 mm, at Z = 131-151 mm or -151 to -131 mm. A 12 mm top
cap joins the guide blocks to this web; a 55 mm-long deep rear anchor connects
it to the existing rail and roller bridge. The cap starts at Y = 138 mm, 6 mm
above the highest yoke. Front guide blocks still carry the 10 mm rods at
Y = 120, Z = +/-114 mm; proposed 20 mm stop collars limit the 48 mm sleeves
to +/-15 mm. A transverse member at X = 225-233, Y = 134-140 mm joins the
spring reaction seat to both rails, with 4 mm over the lower wheel tops.
The front rails sit 10 mm further outboard than in the earlier 50 mm-groove
study because the R2 idler carriage is wider. A 70 mm-diameter relief, swept
over the +/-15 mm stroke and within Z = +/-95 mm, is cut into the rail strip
and front anchors around the 60 mm idler hubs. It leaves 5 mm radial and
axial running clearance; the local section loss is not stress-checked.

The [cassette guides](../04-battery-and-charging/batteries.md#sliding-battery-cassette)
are now one flat 76.2 mm guide under the tray at X = -26.1 to +50.1 mm,
between the middle lower-roller columns. Its fixed stage bears on the side
rails, which are notched above Y = 129.9 mm over that width, and the carrier
has a matching slot; the guide keeps at least 5 mm to the lower rollers and
U supports. A bracket under the tray's rear corner (X = -255 to -225 mm)
guides the lock pin up into a strip on the tray edge, at tray level.
Guide mounting holes, welds and end-stop details remain open. The 85 kg /
1.5 g extraction screen is **not** a frame or joint capacity proof.

The [fixed upper supports](running-gear.md#fixed-upper-roller-support) extend
16 mm inside the track edge and are held outboard by notched flat crossheads
and straight posts on the fixed carrier wings, independent of the idler carriage.
The front rail, however, extends **41 mm** inside.
The [two-pod width screen](../../width-and-slope-sizing.md#minimum-width-and-packaging)
includes the more restrictive intrusion. Positive modeled connection volumes
are not welds or structural qualification.

**Manufacturing review:** the motor dogleg/hulled braces are replaced by
square-cut 25 mm solid bars. Each new roller support uses one 25 mm square
post and one 12 mm flat crosshead with a single square belt-clearance relief;
the carrier wings are rectangular 10 mm plate. The inboard mast diagonals
are retained to brace the tall thin masts; front guide webs/caps retain their
idler-stroke clearance and the slide notch remains necessary. Lower U supports,
the existing motor plate is unchanged. This simplifies
the added load paths, not a released weldment: weld access/size, plate-to-bar
joint preparation, distortion control, fatigue and actual stock supply need review.
Solid-bar results must not be used to justify substituting hollow tube.

At an assumed steel density of 7,850 kg/m³, the rendered solid pod frame is
about **19.39 kg per pod**, excluding the carrier and other supports; both
frames alone are about **38.79 kg**, exceeding the 30 kg CHS-001 generic tube-stock
allowance by **8.79 kg**. This is not a tube cut list or evidence that the allowance covers
the actual material. Each modeled motor plate is about **8.16 kg**; two are
about **16.32 kg**, exceeding the 12 kg CHS-004 plate-stock allowance by at
least **4.32 kg** before reducer plates and cutting waste. The modeled union
of frame and motor plate is about **27.24 kg per pod**. The fixed carrier with
wings is about **10.54 kg** and the complete upper supports about **9.19 kg**
per pod, outside that union. These are unpriced
candidate exposures, not approved BOM changes; actual stock, additional parts
and fabrication costs require a new cut list and estimate.

#### Local structural load screen

Run `npm run stress --prefix tool/cad-viewer` from the repository root. It
reads the member dimensions from the SCAD model, verifies the material and
clearance probes, and applies simplified elastic beam calculations. It is
an **analytical local screening tool, not finite-element analysis or a physical
stress test**. For assumed solid S235 steel, it uses E = 200,000 MPa, Poisson
ratio 0.3, yield = 235 MPa and provisional limits of **117.5 MPa** and **1 mm**.
The command fails if a screened case exceeds either limit.

The motor case combines the supplier's unverified **45 Nm peak claim x 2**
with an 11 kg motor at 2 g. It includes the 120 mm post offset, an assumed
mid-body CG 79 mm from the plate's rear face, and the full 179 mm post span.
It conservatively assigns the whole synthetic motor load to the forward pair;
the added rear pair receives no capacity credit in this two-post calculation.
Each post receives 1,448.7 N transverse, 107.9 N vertical and 213.1 N axial.
For the pod cases, the plan's provisional 300 kg machine mass is split equally
between two pods and multiplied by 2 g: 2,943 N per pod. The notched rail
receives 75% of this synthetic load; the crossmember receives all of it at
midspan. The front case applies **2,943 N vertical and 2,943 N axial
simultaneously** to one ideal fixed-end rail, at the guide's 27 mm offset.
It includes eccentric bending and torsion; solid-rectangle torsion coefficients
0.20 for shear and 0.14 for the torsion constant bound the idealized
[rectangular-bar calculation](https://amesweb.info/Torsion/Torsion-Rectangular-Sections-Calculator.aspx)
conservatively. These loads are study assumptions, not measured maxima.

| Idealized local case | Combined stress | Tip / midspan deflection | Provisional screen |
| --- | ---: | ---: | --- |
| One motor post | 107.5 MPa | 0.427 mm | Pass |
| Notched rear rail | 30.0 MPa | 0.012 mm | Pass |
| Rear crossmember | 105.3 MPa | 0.158 mm | Pass |
| One front idler rail, including eccentricity | 72.5 MPa | 0.332 mm | Pass |

Ideal four-bolt **average** plate-bearing pressure is 5.6 MPa and is
informational only. The calculations assume ideal supports and load transfer;
they do not establish plate bending, bolt/thread strength, welds, local
stress concentrations, guide rods, axle/bearings, buckling or fatigue.
They do not determine actual track tension, reducer fixed-ring reaction
(which can greatly exceed motor torque), braking, impacts, lateral skid
loads, scissor/spine attachments, complete-frame stiffness or vehicle
stability. Analyze and independently validate the complete load paths and
joint details before any fabrication or use; all release holds remain.

**Regression evidence:** `fit-structural-frame.test.mjs` first failed for the
missing rear motor seats and absent continuous carrier-supported crossheads.
The replacement checks actual plate intersections at all four seats, complete
post/crosshead material, full post footprints on the fixed carrier, the idler
stroke and 5 mm service/harness/running clearances. `fit-drive-teeth.test.mjs`
first failed because the suns were cylinders and the drum had no central teeth.
These are geometry regressions, not validation of welds or load capacity.

#### Motor and reducer mounting plates

**Current definition:** CHS-004 reserves mounting-plate stock, not a finished
motor bracket. Its budgeted mass does not establish a released mounting drawing.

**Custom CAD proposal:** a 290 mm OD x 16 mm reaction plate on the motor's
published front mounting face, with a 26 mm shaft aperture and four 9 mm
clearance holes on the published 148 mm PCD. Proposed 14 mm head recesses are
8 mm deep, leaving 8 mm of plate behind them. Hole clocking, fastener head
geometry/length/engagement, tool access and strength still need qualification.
The unchanged 206 x 126 mm motor body moves 16 mm outboard relative to the
no-plate reference, 4 mm farther than the previous proposal; the reducer stages
stay put. See the [axial package](../02-drive-train/propulsion.md#cad-package-envelope).

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
