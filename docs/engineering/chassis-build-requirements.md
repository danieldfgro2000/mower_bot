# Chassis Build and Procurement Checklist

**Document:** MBR-ENG-BOM-002 | **Revision:** D | **Date:** 2026-10-26

**Status:** DRAFT / HOLD. This is a production-oriented specification checklist,
not a released manufacturing BOM, approved component selection, or certification.
No purchase, fabrication, energizing, upload, or physical test is authorized.

**Purpose:** track the drawings, supplier confirmations, manufacturing records
and inspections needed before the chassis can be bought or built.
For **parts and prices**, use the [Chassis BOM and Cost Breakdown](chassis-bom.md#cost-breakdown).
This document is not another BOM, a software release, or proof of production
readiness. A **release hold** means a requirement is still unresolved and blocks
the applicable purchase/build approval; all existing holds remain in effect.

[BOM scope, supplier links and estimates](chassis-bom.md) |
[Cost and quantity ledger](chassis-bom.csv) |
[Product authority](../../plan.md) |
[Width/slope sizing limitations](width-and-slope-sizing.md)

**Jump to:** [Specifications](#item-family-specification-and-inspection-matrix) ·
[Manufacturing deliverables](#manufacturing-and-inspection-deliverables) ·
[Supplier requests](#procurement-work-packages-and-rfq-content) ·
[Release holds](#release-hold-points) ·
[Cost gaps](#cost-exposure-not-resolved-by-this-detail).

## Configuration and document control

The cost ledger has 129 estimating lines. This companion owns shared document
control, manufacturing deliverables, procurement packages and release holds.
The linked scope documents own technical definitions and inspection evidence.
Every line maps to one primary PS family; several families can share an
assembly drawing or safety review. PS IDs are requirement references, not
additional parts or costs. All families are currently **HOLD**.

**Revision D change:** linked directly to the cost summary and each scope's
specification section. Coverage, requirements, inspection evidence and
qualification status are unchanged.

The two voltage scenarios are alternatives. Freeze one approved configuration
before issuing a manufacturing BOM; retain the other only as an estimate.
Stage 2 quantities are cumulative. Installed parts, reusable bench equipment,
and consumables must remain separate in production and accounting records.

### Left/right tracked pods

**Existing line prefixes:** RUN, DRV, BAT; pod-specific PWR, SAF and INS

**Configuration detail required:** Separate left/right assembly drawings, handed parts
and harness variants; do not divide shared items by two

### Central frame and width drive

**Existing line prefixes:** CHS, WID

**Configuration detail required:** Spine/scissor datums, swept envelopes, operating
widths, actuator and holding interfaces

### Shared electrical/control system

**Existing line prefixes:** Shared PWR, SAF and INS

**Configuration detail required:** Explicit mounting location, supply origin, interface
and stop-chain references

### Handling/service kit

**Existing line prefixes:** MNT

**Configuration detail required:** Separate installed eyes/brackets from loose lifting,
transport and support equipment

### Bench assets

**Existing line prefixes:** TST

**Configuration detail required:** Asset IDs, ratings and calibration records; not
installed machine mass

### Consumables and initial spares

**Existing line prefixes:** CON

**Configuration detail required:** Production consumption versus retained spares; no
duplicate installed quantities

RUN/CHS/etc. IDs remain stable estimating references. A released assembly needs
its own controlled part number, revision, parent and reference designators.
Split an estimating lot into discrete child parts before release, retaining its
original ID as the cost-parent reference. Replace its parent extension with the
sum of children; never count both. A compatible supplier kit may instead absorb
children, with its contents and removed duplicate costs explicitly recorded.

### Required released-line fields

These are required deliverables, **not populated or approved records**. Do not
fill unknowns with plausible ratings. Mark `HOLD: reason`, with the responsible
review role and evidence needed to close it. Roles below are proposed functions;
no engineer, buyer or inspector has been appointed by this document.

#### Identity/effectivity

**Required content before the applicable release:** Stable item ID; parent assembly;
part number and revision; description; left/right/shared location or reference
designator; applicable voltage/build serial range

#### Make/buy/reuse

**Required content before the applicable release:** Disposition; exact manufacturer and
full MPN/options for bought items; drawing/revision for made parts; asset
identity/condition for reused parts

#### Engineering definition

**Required content before the applicable release:** Units and quantity per parent;
drawing/datums/tolerances; material/finish; electrical/mechanical interfaces; accepted
ratings, duty and environment; approved specification revision

#### Procurement

**Required content before the applicable release:** Approved supplier and order code
distinct from MPN; exact product URL; quote ID/date/expiry; pack size/MOQ; order
quantity; stock/lead time; delivery terms/location; warranty and approved substitutions

#### Cost

**Required content before the applicable release:** Currency; net unit price; VAT basis;
gross price; exchange-rate date; freight/duty allocation; tooling/NRE separately; bundle
contents; purchase extension and revised scenario/stage rollups

#### Quality

**Required content before the applicable release:** Critical characteristics;
receiving/first-article/assembly checks; numeric limits and method references; sampling
decision; lot/serial traceability; certificates/calibration where applicable

#### Release

**Required content before the applicable release:** Status and open holds;
engineering/procurement/quality approval references and dates as applicable;
deviation/change reference; as-built serial/lot and inspection result

Current `each`, `m`, `kg`, `m2`, `pair`, `set`, `kit`, `lot` and `pod set` units
are estimate units, not necessarily supplier order units. Convert explicitly:
`order quantity = pack size x ceil(required purchase quantity / pack size)`,
after allowing for stock, reuse, approved cutting yield and spares. Re-price
pack rounding; do not change the installed quantity to conceal excess stock.
Record each half of a connector pair, including contacts, seals, wedges,
backshells and caps; two housings alone are not a complete mating pair.

## Item-family specification and inspection matrix

All 39 PS families remain **HOLD**. Their definitions and inspection evidence now
live in the scope documents; each of the 129 cost lines has one primary owner.
Cross-scope interfaces are linked, not copied.

- [Tracks and running gear](bom/running-gear.md#specification-and-inspection-requirements) — PS01, PS02, PS03
- [Propulsion, reductions and brakes](bom/propulsion.md#specification-and-inspection-requirements) — PS14, PS15, PS16, PS17
- [Frame, scissor and spine](bom/frame.md#specification-and-inspection-requirements) — PS04, PS05, PS06, PS07, PS08, PS32
- [Powered width adjustment](bom/width-adjustment.md#specification-and-inspection-requirements) — PS09, PS10, PS11, PS12, PS13
- [Batteries, enclosures and charging](bom/batteries.md#specification-and-inspection-requirements) — PS18, PS19, PS20
- [Cables, connectors and harnesses](bom/cables-connectors.md#specification-and-inspection-requirements) — PS23, PS26
- [Electronics, power distribution and safety](bom/electronics.md#specification-and-inspection-requirements) — PS21, PS22, PS24, PS25, PS27, PS28, PS29, PS30, PS31
- [Workshop, bench equipment and service supplies](bom/workshop.md#specification-and-inspection-requirements) — PS33, PS34, PS35, PS36, PS37, PS38, PS39

## Manufacturing and inspection deliverables

Before fabricated parts or harnesses can be released, the responsible designer
must set numerical acceptance limits and inspection methods. A blank tolerance,
generic "good weld", or "works on bench" result is not an acceptance criterion.

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

**Existing cost coverage / residual gap:** TST and calibration allowance are
provisional; environmental/EMC/specialist tests are not fully budgeted

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

## Procurement work packages and RFQ content

Prepare these requests only; **sending supplier requests needs separate user
approval**. Each response must identify exact MPN/options and its included
children, plus quantity, net/VAT/gross price, delivery to Romania, freight,
lead time, validity, warranty, drawings and technical exceptions. Use the
[source register](bom/sources.md#source-register); its catalogs are not quotes.

### Q01: complete running gear

**Families / sourcing leads:** PS01-03; S01/S02, S03 for excluded bearings

**Specific response needed:** Two matched tracks/undercarriages with sprocket drawings,
load/speed/tension data and every included axle/bearing/roller; quote service spares
separately

### Q02: alternative complete drives

**Families / sourcing leads:** PS14-17; S11/S12 versus S13, with S10/S05 alternatives

**Specific response needed:** One bench drive with second identical drive priced
separately; documented operating-point curves, reduction and brake ratings, controller
configuration and all wiring/interfaces; flag present voltage/current contradictions

**Additional non-additive candidate:** [HPM5000B ALT-DRV-001](bom/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals),
S23/S24 with S25 as an EU fallback. Confirm 48 V air-cooled winding/shaft and
motor-only contents at the published quantity tier. Price a compatible controller,
independent holding/stopping solution and two-stage chain hardware separately;
do not transfer S11/S12 compatibility or infer approval of a 5 kW power increase.

### Q03: battery/charging alternatives

**Families / sourcing leads:** PS18-20; S16/S17

**Specific response needed:** Pack drawing/mass, cell/series/BMS details,
vehicle/regen/current limits, charger and shipment documentation; price matched
battery-only and charger-bundled offers separately; no unquoted 70 Ah substitute

### Q04: local fabrication/machining

**Families / sourcing leads:** PS04-10, PS16/19/25/27; S06/S04

**Specific response needed:** Quote only against released drawings: stock/cut yield,
outsourced precision operations and material/inspection documentation; owner
welding/printing labor stays separate

### Q05: electrical and safety

**Families / sourcing leads:** PS11-13, PS21-31; S07/S08/S09/S18

**Specific response needed:** Exact full-voltage-rated protective devices, complete
connector/harness children, independent stop/remote configuration and evidence; no
automatic approval of catalog examples

### Q06: bench/service assets

**Families / sourcing leads:** PS32-39; S19-22, S04/S06/S07

**Specific response needed:** Complete matched load/measurement setup, fixture
interfaces, continuous absorption/heat rejection and calibration; separately quote
rental/outsourcing without dropping required measurements

No claimed second source is interchangeable until form, fit, function, ratings,
firmware/interfaces and acceptance evidence are reviewed. A supplier "equivalent"
or marketplace stock substitution is a change request, not purchasing discretion.

## Release hold points

All hold points below are **OPEN**; required approval roles are not yet assigned.
An approval record must identify its scope, configuration, reviewer and evidence.
Engineering approval is not operational authorization.

### H01: configuration and package fit

**Must close before:** Long-lead component purchase and dimension-dependent fabrication

**Closure evidence / responsible review role:** Chosen voltage; complete
pod/track/spine/width layouts; mass/CG budget and load cases; mechanical/electrical
design review

### H02: drive and braking sizing

**Must close before:** Drive/reduction/brake purchase

**Closure evidence / responsible review role:** Torque-speed/duty and stopping/holding
assessment using actual radius, loaded mass and terrain; qualified full-SOC/power-loss
strategy; drivetrain and safety review

### H03: width holding and adjustment

**Must close before:** Width mechanism fabrication/actuation

**Closure evidence / responsible review role:** Positive-holding conflict resolved
through explicit plan decision and engineering evidence; screw/load/guard/reference/stop
definitions; mechanical and safety review

### H04: bus and protection coordination

**Must close before:** Pack, controller, switchgear and harness release

**Closure evidence / responsible review role:** Full-charge/cutoff/regen and
fault-current compatibility, precharge/branch protection, DC/DC/coil loads and
schematics; electrical review

### H05: independent stopping

**Must close before:** Energizing any bench or chassis configuration

**Closure evidence / responsible review role:** Hazard assessment, reviewed stop-state
diagram, selected hardware/firmware configuration and approved test plan; safety review,
followed by separately authorized commissioning

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

**Closure evidence / responsible review role:** Later-stage mower/guarding/safety
integration, applicable legal/conformity review, technical file and service/operator
documentation; qualified product/compliance review outside this Stage 1-2 estimate

H05 requires a review and an approved sequence before energizing, not a claim
that live stop tests have already passed before power is first applied.
Commissioning must progress through separately authorized controlled steps.
Do not use the 40-degree site aspiration as an initial test angle or an accepted
tilt threshold. Production readiness needs actual evidence, not closed cells.

## Cost exposure not resolved by this detail

This revision changes technical detail, **not the 129-line prices or totals**.
An allowance is not evidence that all children of a released design are funded.
The following remain explicit, unpriced exposures outside any claim of a final
production price; the 20% contingency is not proof that they are covered.

### Different reduction, higher-rated brake or independent stopping hardware

**Reconciliation required:** Replace affected DRV/PWR/SAF provisions after H02/H04/H05,
not add an arbitrary performance premium

### Powered compatible positive-width lock and monitoring

**Reconciliation required:** Replace CHS-010 reserve and add exact actuator/interlock
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

**Reconciliation required:** Stage 3+ mower/mounts/guards, later autonomy, packaging,
operator training, warranty stock, transport and ongoing service remain outside this
chassis estimate

Maintain a dated change record: affected IDs, reason, old/new approved revision,
evidence, quantity/cost delta, applicable builds, approver and disposition of
stock/work in progress. Update CSV, totals and package definitions together.
After assembly, preserve an as-built BOM with serial/lot identities and approved
deviations; do not overwrite it with a later design revision.
