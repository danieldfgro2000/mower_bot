# Chassis Build and Procurement Checklist

<a id="document-overview"></a>

**Summary:** Evidence needed before chassis purchasing, fabrication, or
energizing. All holds remain open; the workflow below links named requirements,
manufacturing packs, supplier requests, and release evidence.

**Document:** MBR-ENG-BOM-002 | **Revision:** E | **Date:** 2026-10-26

**Status:** DRAFT / HOLD. This is a production-oriented specification checklist,
not a released manufacturing BOM, approved component selection, or certification.
No purchase, fabrication, energizing, upload, or physical test is authorized.

**On this page:** [Current status](chassis-build-requirements.md#current-status) ·
[Release workflow](chassis-build-requirements.md#how-to-use-this-checklist) ·
[Named requirements](chassis-build-requirements.md#2-confirm-item-family-specifications) ·
[Open release holds](chassis-build-requirements.md#5-close-release-hold-points)

**Related documents:** [Chassis BOM](bom/chassis-bom.md) ·
[BOM Cost Breakdown](cost-breakdown.md) ·
[Cost ledger](bom/chassis-bom.csv) ·
[Width/slope limitations](width-and-slope-sizing.md) ·
[Product direction and build gates](../../plan.md)

## Current status

| Question | Current answer | Go to |
| --- | --- | --- |
| What does the chassis cost? | Cost estimate available; not a released purchase list | [BOM Cost Breakdown](cost-breakdown.md) |
| Are parts technically specified? | 39 requirement families defined; all remain **HOLD** | [Named requirement families](chassis-build-requirements.md#2-confirm-item-family-specifications) |
| Are manufacturing drawings released? | No | [Required deliverables](chassis-build-requirements.md#3-prepare-manufacturing-and-inspection-deliverables) |
| Are supplier quotes approved? | No; catalog pages are sourcing leads only | [RFQ packages](chassis-build-requirements.md#4-prepare-procurement-work-packages) |
| Can purchasing or fabrication begin? | No; all eight release holds are open | [Release holds and their scope](chassis-build-requirements.md#5-close-release-hold-points) |
| Is hardware operation authorized? | No | [Status and safety boundary](chassis-build-requirements.md#chassis-build-and-procurement-checklist) |

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## How to use this checklist

You can [inspect any part](chassis-build-requirements.md#2-confirm-item-family-specifications)
without reading this checklist front to back. For **release decisions**, complete
the gates below in order; opening a later section is not permission to skip one.

1. [Freeze the configuration](chassis-build-requirements.md#1-freeze-the-configuration-and-establish-control):
   choose one voltage scenario and define assemblies and
   [released-line records](chassis-build-requirements.md#required-released-line-record).
2. [Confirm specifications](chassis-build-requirements.md#2-confirm-item-family-specifications): open the
   linked requirement family for each item being purchased or manufactured.
3. [Prepare manufacturing evidence](chassis-build-requirements.md#3-prepare-manufacturing-and-inspection-deliverables):
   complete the applicable drawing, harness, traveler, verification, and service packs.
4. [Prepare supplier requests](chassis-build-requirements.md#4-prepare-procurement-work-packages): assemble
   RFQs, but do not send them without separate user approval.
5. [Close release holds](chassis-build-requirements.md#5-close-release-hold-points): provide the stated
   evidence before the affected purchase, fabrication, energizing, or release.
6. [Reconcile cost exposure](chassis-build-requirements.md#6-reconcile-unresolved-cost-exposure): update the
   BOM only after the design and supplier contents are known.

## 1. Freeze the configuration and establish control

The [cost ledger](bom/chassis-bom.csv) owns current estimating lines. This
checklist owns shared document control, manufacturing deliverables, procurement
packages and release holds.
The linked scope documents own technical definitions and inspection evidence.
Every line maps to one primary PS family; several families can share an
assembly drawing or safety review. PS IDs are requirement references, not
additional parts or costs. All families are currently **HOLD**.

The estimate covers **Stage 1 — bench propulsion prototype** and **Stage 2 —
rolling two-pod chassis** only. **Stage 3 — supervised mower integration** and
later autonomy/service work need their own requirements, costs and release
evidence; they are not authorized by closing this checklist.

The active estimate uses only the 48 V direction. Freeze an approved pack,
drive and interface configuration before issuing a manufacturing BOM.
Stage 2 quantities are cumulative. Installed parts, reusable bench equipment,
and consumables must remain separate in production and accounting records.

| Assembly/accounting scope | Existing line prefixes | Configuration detail required |
| --- | --- | --- |
| Left/right tracked pods | RUN, DRV, BAT; pod-specific PWR, SAF and INS | Separate left/right assembly drawings, handed parts and harness variants; do not divide shared items by two |
| Central frame and width drive | CHS, WID | Spine/scissor datums, swept envelopes, operating widths, actuator and holding interfaces |
| Shared electrical/control system | Shared PWR, SAF and INS | Explicit mounting location, supply origin, interface and stop-chain references |
| Handling/service kit | MNT | Separate installed eyes/brackets from loose lifting, transport and support equipment |
| Bench assets | TST | Asset IDs, ratings and calibration records; exclude from installed machine mass |
| Consumables and initial spares | CON | Separate production consumption from retained spares; do not duplicate installed quantities |

RUN/CHS/etc. IDs remain stable estimating references. A released assembly needs
its own controlled part number, revision, parent and reference designators.
Split an estimating lot into discrete child parts before release, retaining its
original ID as the cost-parent reference. Replace its parent extension with the
sum of children; never count both. A compatible supplier kit may instead absorb
children, with its contents and removed duplicate costs explicitly recorded.

### Required released-line record

These are required deliverables, **not populated or approved records**. Do not
fill unknowns with plausible ratings. Mark `HOLD: reason`, with the responsible
review role and evidence needed to close it. Roles below are proposed functions;
no engineer, buyer or inspector has been appointed by this document.

| Record area | Required content before the applicable release |
| --- | --- |
| Identity/effectivity | Stable item ID; parent assembly; part number and revision; description; left/right/shared location or reference designator; applicable voltage/build serial range |
| Make/buy/reuse | Disposition; exact manufacturer and full MPN/options for bought items; drawing/revision for made parts; asset identity/condition for reused parts |
| Engineering definition | Units and quantity per parent; drawing/datums/tolerances; material/finish; electrical/mechanical interfaces; accepted ratings, duty and environment; approved specification revision |
| Procurement | Approved supplier and order code distinct from MPN; exact product URL; quote ID/date/expiry; pack size/MOQ; order quantity; stock/lead time; delivery terms/location; warranty and approved substitutions |
| Cost | Currency; net unit price; VAT basis; gross price; exchange-rate date; freight/duty allocation; tooling/NRE separately; bundle contents; purchase extension and revised scenario/stage rollups |
| Quality | Critical characteristics; receiving/first-article/assembly checks; numeric limits and method references; sampling decision; lot/serial traceability; certificates/calibration where applicable |
| Release | Status and open holds; engineering/procurement/quality approval references and dates as applicable; deviation/change reference; as-built serial/lot and inspection result |

Current `each`, `m`, `kg`, `m2`, `pair`, `set`, `kit`, `lot` and `pod set` units
are estimate units, not necessarily supplier order units. Convert explicitly:
`order quantity = pack size x ceil(required purchase quantity / pack size)`,
after allowing for stock, reuse, approved cutting yield and spares. Re-price
pack rounding; do not change the installed quantity to conceal excess stock.
Record each half of a connector pair, including contacts, seals, wedges,
backshells and caps; two housings alone are not a complete mating pair.

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## 2. Confirm item-family specifications

All 39 requirement families remain **HOLD**. Each current cost line has one
primary owner; calculated-torque evidence has no equipment purchase.
Choose the physical part below. Its part view groups costs, available data,
open specifications, and fit/connection links; the complete inspection
requirements remain in that scope's PS sections. PS codes are stable
cross-references, not extra parts.

| Part being considered | Inspect the part and its interfaces | Relevant release evidence |
| --- | --- | --- |
| Motor, controller, reduction or brake | [Drive choices and costs](modules/02-drive-train/propulsion.md#parts-at-a-glance) · [Motor-to-track mounting](modules/02-drive-train/propulsion.md#motor-to-track-mounting) | [Drive/braking sizing](modules/02-drive-train/propulsion.md#h02-drive-and-braking-sizing) |
| Track, drum, roller or tensioner | [Running-gear parts](modules/01-structure-and-running-gear/running-gear.md#parts-at-a-glance) · [Track engagement](modules/01-structure-and-running-gear/running-gear.md#drive-drum-study) | [Configuration/package fit](chassis-build-requirements.md#h01-configuration-and-package-fit) |
| Frame, mounting plates, pivots or lifting points | [Frame parts](modules/01-structure-and-running-gear/frame.md#parts-at-a-glance) · [Motor mounting plates](modules/01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) | [Mechanical drawing pack](chassis-build-requirements.md#mechanical-drawing-pack) |
| Width motor, screw, driver or limits | [Width-drive parts](modules/03-width-adjustment/width-adjustment.md#parts-at-a-glance) · [Holding conflict](modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping) | [Width holding/adjustment](modules/03-width-adjustment/width-adjustment.md#h03-width-holding-and-adjustment) |
| Pack, BMS, enclosure or charger | [Battery/charging parts](modules/04-battery-and-charging/batteries.md#parts-at-a-glance) · [Battery-to-pod fit](modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) | [Bus/protection coordination](modules/05-power-cables-and-electronics/power-distribution.md#h04-bus-and-protection-coordination) |
| Cable, lug or connector | [Harness parts and tooling connections](modules/05-power-cables-and-electronics/cables-connectors.md#parts-at-a-glance) | [Electrical/harness pack](chassis-build-requirements.md#electricalharness-pack) |
| Fuse, contactor, converter or electronics box | [Power-distribution parts](modules/05-power-cables-and-electronics/power-distribution.md#parts-at-a-glance) | [Bus/protection coordination](modules/05-power-cables-and-electronics/power-distribution.md#h04-bus-and-protection-coordination) · [Printed enclosure pack](chassis-build-requirements.md#printed-enclosure-pack) |
| E-stop, board, interlock or sensor | [Control/sensor parts and connections](modules/06-safety-controls-and-sensors/safety-controls.md#parts-at-a-glance) | [Independent stopping](modules/06-safety-controls-and-sensors/safety-controls.md#h05-independent-stopping) |
| Bench fixture, tools or handling equipment | [Workshop buy/reuse choices](modules/07-workshop-and-support/workshop.md#parts-at-a-glance) · [Test-method limits](modules/07-workshop-and-support/workshop.md#test-method-and-evidence) | [Verification plan](chassis-build-requirements.md#verification-plan) |

These are entry points, not an exhaustive allocation of holds to parts.
The [complete release-hold table](chassis-build-requirements.md#5-close-release-hold-points)
and applicable manufacturing/inspection packs still govern every release.

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## 3. Prepare manufacturing and inspection deliverables

Before fabricated parts or harnesses can be released, the responsible designer
must set numerical acceptance limits and inspection methods. A blank tolerance,
generic "good weld", or "works on bench" result is not an acceptance criterion.

| Deliverable | Purpose |
| --- | --- |
| [Mechanical drawing pack](chassis-build-requirements.md#mechanical-drawing-pack) | Dimensions, materials, joints, alignment and service clearance |
| [Printed enclosure pack](chassis-build-requirements.md#printed-enclosure-pack) | Controlled CAD/process, thermal and ingress evidence |
| [Electrical and harness pack](chassis-build-requirements.md#electricalharness-pack) | Schematics, wire/connector schedule and installation checks |
| [Assembly traveler](chassis-build-requirements.md#assembly-traveler) | Traceable build, inspection and deviation record |
| [Verification plan](chassis-build-requirements.md#verification-plan) | Acceptance limits, safe fixtures and measured evidence |
| [Service pack](chassis-build-requirements.md#service-pack) | Isolation, handling, inspection and maintenance instructions |

### Mechanical drawing pack

**Minimum contents:** Assembly datums and envelope in every approved width; dimensioned
cut/bend/machining details; weld symbols/sizes, joint prep, material/finish and
tolerances; fastener and lubrication schedules; track alignment/tension settings;
service clearances

**Existing cost coverage / residual gap:** CHS/RUN/DRV/WID raw materials and machining
allowances only; design work and specialized inspection are not priced

### Printed enclosure pack

**Minimum contents:** Versioned CAD/export, print parameters, qualified polymer/process,
inserts/seals/glands, support removal and inspection; thermal/ingress acceptance method

**Existing cost coverage / residual gap:** PWR-015/016/021-024; failed prints, polymer
qualification and redesign may exceed allowances

### Electrical/harness pack

**Minimum contents:** Power and stop schematics; device/reference designators;
pin-to-pin list; wire gauge/type/colour/length; branch fuses; earthing/bonding/isolation
decision; shield terminations; crimp/torque/polarity instructions and labels

**Existing cost coverage / residual gap:** Existing PWR/WID/SAF provisions; exact
connector children, test adapters and additional safety parts require reconciliation

### Assembly traveler

**Minimum contents:** Build serial, configuration/revisions, operator/inspection
signoff, part serials/lots, joint torques, track tension, wiring checks, deviations and
rework disposition

**Existing cost coverage / residual gap:** Documentation/engineering labor excluded; no
cost claimed for a completed traveler

### Verification plan

**Minimum contents:** Hazard-derived limits and pass/fail thresholds; safe
fixture/containment; calibrated instruments; worst-case
load/temperature/SOC/configuration; independent observation and result references

**Existing cost coverage / residual gap:** [Bench and instrument provisions](modules/07-workshop-and-support/workshop.md#test-method-and-evidence)
are provisional; no separate calibration-service allowance is included.
Required calibration evidence remains open, and environmental/EMC/specialist
tests are not fully budgeted

### Service pack

**Minimum contents:** Isolation and residual-energy verification, lifting/support
instructions, track tension/lubrication, fastener inspection, battery charging/storage,
brake/lock inspection, replacement part list and configuration backup

**Existing cost coverage / residual gap:** Initial MNT/CON provisions only; service
intervals and wear limits need supplier/design evidence

Do not choose steel grade, tube size, screw lead, bearing fit, wire gauge, fuse
amps, braking energy, or safety-performance category simply to make this checklist
look complete. They depend on the frozen geometry, load cases and hazard review.
Reused equipment requires the same suitability evidence as a new item.

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## 4. Prepare procurement work packages

Prepare these requests only; **sending supplier requests needs separate user
approval**. Each response must identify exact MPN/options and its included
children, plus quantity, net/VAT/gross price, delivery to Romania, freight,
lead time, validity, warranty, drawings and technical exceptions. Each
package lives in its owning module page, beside that scope's requirements and
supplier evidence; catalogs are not quotes.

| Supplier request | Scope |
| --- | --- |
| [Complete running gear (Q01)](modules/01-structure-and-running-gear/running-gear.md#q01-complete-running-gear) | Matched tracks, rollers, shafts and bearings |
| [Alternative complete drives (Q02)](modules/02-drive-train/propulsion.md#q02-alternative-complete-drives) | Motor, controller, reduction and braking |
| [Battery and charging alternatives (Q03)](modules/04-battery-and-charging/batteries.md#q03-batterycharging-alternatives) | Matched pack/BMS and charger definitions |
| [Local fabrication and machining (Q04)](modules/01-structure-and-running-gear/frame.md#q04-local-fabricationmachining) | Quote against released drawings |
| [Electrical and safety (Q05)](modules/05-power-cables-and-electronics/power-distribution.md#q05-electrical-and-safety) | Protection, wiring and independent stop hardware |
| [Bench and service assets (Q06)](modules/07-workshop-and-support/workshop.md#q06-benchservice-assets) | Fixture, selected instruments and support equipment |

No claimed second source is interchangeable until form, fit, function, ratings,
firmware/interfaces and acceptance evidence are reviewed. A supplier "equivalent"
or marketplace stock substitution is a change request, not purchasing discretion.


[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## 5. Close release hold points

All hold points below are **OPEN**; required approval roles are not yet assigned.
An approval record must identify its scope, configuration, reviewer and evidence.
Engineering approval is not operational authorization. Module-specific holds
(H02–H05) live in their owning module pages; cross-cutting holds follow the table.

| Hold | What it blocks | Evidence theme |
| --- | --- | --- |
| [Configuration and package fit (H01)](chassis-build-requirements.md#h01-configuration-and-package-fit) | Long-lead purchase and dimension-dependent fabrication | Frozen configuration, package layout, mass/CG and load cases |
| [Drive and braking sizing (H02)](modules/02-drive-train/propulsion.md#h02-drive-and-braking-sizing) | Drive, reduction and brake purchase | Torque-speed duty, stopping, holding and power-loss strategy |
| [Width holding and adjustment (H03)](modules/03-width-adjustment/width-adjustment.md#h03-width-holding-and-adjustment) | Width mechanism fabrication or actuation | Positive holding, screw/load definition, guarding and limits |
| [Bus and protection coordination (H04)](modules/05-power-cables-and-electronics/power-distribution.md#h04-bus-and-protection-coordination) | Battery, controller, switchgear and harness release | Voltage/current compatibility, protection and schematics |
| [Independent stopping (H05)](modules/06-safety-controls-and-sensors/safety-controls.md#h05-independent-stopping) | Energizing any bench or chassis configuration | Hazard review, stop-state design and approved test plan |
| [Drawings and purchased-part qualification (H06)](chassis-build-requirements.md#h06-drawings-and-purchased-part-qualification) | Production purchase or fabrication release | Released records, drawings, exact MPNs and valid quotes |
| [First article and environment (H07)](chassis-build-requirements.md#h07-first-article-and-environment) | Replication or production-readiness claims | First-article evidence, environment assessment and closed defects |
| [Completed-product release (H08)](chassis-build-requirements.md#h08-completed-product-release) | Commercial machine use | Mower/safety integration, legal review and operating documentation |

### H01: configuration and package fit

**Must close before:** Long-lead component purchase and dimension-dependent fabrication

**Closure evidence / responsible review role:** Chosen voltage; complete
pod/track/spine/width layouts; mass/CG budget and load cases; mechanical/electrical
design review


### H06: drawings and purchased-part qualification

**Must close before:** Production purchase/fabrication release

**Closure evidence / responsible review role:** Complete released-line records,
drawings, exact approved suppliers/MPNs and valid delivered quotes; engineering and
procurement review

### H07: first article and environment

**Must close before:** Replication or claimed production readiness

**Closure evidence / responsible review role:** Receiving/assembly records, verified
torque/thermal/brake/lock/stop behavior, environment/EMC assessment,
configuration-specific operating envelope and nonconformance closure; quality and safety
review

### H08: completed-product release

**Must close before:** Commercial machine use

**Closure evidence / responsible review role:** Stage 3 — supervised mower
integration, including the mower, guarding and safety integration; applicable
legal/conformity review, technical file and service/operator documentation.
Qualified product/compliance review is outside the Stages 1–2 estimate.

The [independent stopping hold (H05)](modules/06-safety-controls-and-sensors/safety-controls.md#h05-independent-stopping)
requires a review and an approved sequence before energizing, not a claim
that live stop tests have already passed before power is first applied.
Commissioning must progress through separately authorized controlled steps.
Do not use the [40-degree site aspiration](width-and-slope-sizing.md#inputs-and-unresolved-definitions)
as an initial test angle or an accepted
tilt threshold. Production readiness needs actual evidence, not closed cells.

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)


## 6. Reconcile unresolved cost exposure

This checklist does not alter the [cost ledger's prices or totals](bom/chassis-bom.csv).
An allowance is not evidence that all children of a released design are funded.
The following remain explicit, unpriced exposures outside any claim of a final
production price; the 20% contingency is not proof that they are covered.

**Open exposure:** [Drives and stop hardware](chassis-build-requirements.md#different-reduction-higher-rated-brake-or-independent-stopping-hardware) ·
[Width holding](chassis-build-requirements.md#powered-compatible-positive-width-lock-and-monitoring) ·
[Detailed part breakdown](chassis-build-requirements.md#full-connectorfastenerharness-and-made-part-breakdown) ·
[Cooling and extra safety hardware](chassis-build-requirements.md#cooling-brake-energy-dissipation-extra-sensors-or-safety-hardware) ·
[Qualification and repeat manufacture](chassis-build-requirements.md#qualification-and-repeat-manufacture) ·
[Finished mower and support](chassis-build-requirements.md#finished-mowing-product-and-commercial-support).

### Different reduction, higher-rated brake or independent stopping hardware

**Reconciliation required:** Replace affected drive, power and safety provisions after
[drive/braking sizing (H02)](modules/02-drive-train/propulsion.md#h02-drive-and-braking-sizing),
[bus/protection coordination (H04)](modules/05-power-cables-and-electronics/power-distribution.md#h04-bus-and-protection-coordination), and
[independent stopping (H05)](modules/06-safety-controls-and-sensors/safety-controls.md#h05-independent-stopping),
not add an arbitrary performance premium

### Powered compatible positive-width lock and monitoring

**Reconciliation required:** Replace the
[width-lock reserve (CHS-010)](modules/01-structure-and-running-gear/frame.md#0105-scissor-pivots-locks-and-hard-stops)
and add exact actuator/interlock
children if required; current EUR 48 is not a complete solution

### Full connector/fastener/harness and made-part breakdown

**Reconciliation required:** Replace lots with discrete parts/cut lists, actual order
packs, scrap and installation yield; remove kit overlap

### Cooling, brake-energy dissipation, extra sensors or safety hardware

**Reconciliation required:** Determine need and architecture first; no selected dump
resistor, fan, redundant sensor or fire device is implied by a reserve

### Qualification and repeat manufacture

**Reconciliation required:** Quote design review, weld/fixture qualification,
first-article rework, environmental/EMC/compliance work, drawings, production jigs and
recurring calibration/inspection separately

### Finished mowing product and commercial support

**Reconciliation required:** Stage 3 — supervised mower integration (mower,
mounts/guards), later autonomy, packaging, operator training, warranty stock,
transport and ongoing service remain outside this chassis estimate

Maintain a dated change record: affected IDs, reason, old/new approved revision,
evidence, quantity/cost delta, applicable builds, approver and disposition of
stock/work in progress. Update CSV, totals and package definitions together.
After assembly, preserve an as-built BOM with serial/lot identities and approved
deviations; do not overwrite it with a later design revision.

[↑ Back to document overview](chassis-build-requirements.md#chassis-build-and-procurement-checklist)
