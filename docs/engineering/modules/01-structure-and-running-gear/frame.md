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
| [Motor and reducer plates](frame.md#motor-and-reducer-mounting-plates) | Stock allowance only; no approved bracket or bolt pattern | [Plate stock in frame costs](frame.md#0104-frame-stock-and-mounting-plates) · [Mount definition](frame.md#motor-and-reducer-mounting-plates) | [Motor → reduction → track](../02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Scissor pivots](frame.md#ps05-scissor-pivots) | Fits, retention and loads open | [Pivot costs](frame.md#0105-scissor-pivots-locks-and-hard-stops) · [Pivot requirements](frame.md#ps05-scissor-pivots) | [Width screw and supports](../03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) |
| [Width locks and hard stops](frame.md#ps06-width-holding-and-hard-stops) | Positive holding unresolved; worm-only proposal not accepted | [Lock/stop provision](frame.md#0105-scissor-pivots-locks-and-hard-stops) · [Holding requirements](frame.md#ps06-width-holding-and-hard-stops) | [Powered adjustment and stopping](../03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| [Guards and fastening](frame.md#ps07-guards-and-edge-protection) | Guard geometry and joint schedule open | [Finishing costs](frame.md#0106-guards-fasteners-coatings-and-labels) · [Guards](frame.md#ps07-guards-and-edge-protection) · [Fasteners/coatings](frame.md#ps08-fasteners-coatings-and-labels) | [Moving screw guard](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) |
| [Lifting and recovery points](frame.md#ps32-installed-lifting-and-recovery-points) | Installed points; no certified lifting capacity established | [Point costs](frame.md#0107-installed-lifting-and-recovery-points) · [Load-path requirements](frame.md#ps32-installed-lifting-and-recovery-points) | [Loose straps and service supports](../07-workshop-and-support/workshop.md#ps33-transport-straps-and-service-supports) |

**Further detail:** [Release requirements](frame.md#specification-and-inspection-requirements) ·
[Sourcing](frame.md#sourcing) · [Interfaces](frame.md#interfaces-with-other-scopes) ·
[Itemized costs](frame.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 01 overview](README.md)

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

#### Motor and reducer mounting plates

**Current definition:** CHS-004 reserves mounting-plate stock, not a finished
motor bracket. No plate thickness, hole pattern, fastener size, or released
mounting-face drawing is established by its budgeted mass.

For the [HPM5000B in-drum concept](../02-drive-train/propulsion.md#motor-to-track-mounting),
the motor housing and stationary ring gears need defined attachment and load
paths to the pod, while the final carrier drives the drum. The costed
[48 V planetary package](../02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive)
requires its own mounting geometry; it is not interchangeable with this concept.

The released drawing must reconcile the exact motor/gearhead face and shaft
projection, output-bearing datums, frame load path, joint definition, cooling
clearance, and assembly/service access. Those inputs remain open; the CAD
envelope is not a fabrication drawing.

**Continue:** [HPM5000B price and specifications](../02-drive-train/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals) ·
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
