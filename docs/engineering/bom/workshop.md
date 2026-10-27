# Workshop, bench equipment and service supplies

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowances and unqualified requirements for bench fixtures,
measurement tools, handling gear, service supplies, spares, and PPE. The
[specification and inspection section](workshop.md#specification-and-inspection-requirements)
identifies evidence still needed before purchasing or use.

**Navigate:** [Requirements](workshop.md#specification-and-inspection-requirements) ·
[Sourcing](workshop.md#sourcing) · [Interfaces](workshop.md#interfaces-with-other-scopes) ·
[Itemized costs](workshop.md#detailed-module-costs) |
[Chassis BOM](../chassis-bom.md#scope-and-decisions) ·
[Workshop cost totals](../cost-breakdown.md#workshop-and-support) ·
[Ledger](../chassis-bom.csv) · [Release checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-id-lookup)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS33: Slings, straps, shackles and supports

**Cost-ledger coverage:** MNT-003:MNT-006

**Required purchasing/manufacturing definition:** Sling/shackle working load limits for
actual arrangement/angles, strap lashing capacity, support stability/capacity and
compatibility with lifting/support points

**Receiving or first-article evidence:** Supplier rating/identity and condition;
handling instructions and inspection register; lifting WLL and transport lashing
capacity are not interchangeable

### PS34: Bench fixture and controls

**Cost-ledger coverage:** TST-001:TST-004

**Required purchasing/manufacturing definition:** Bench reaction-torque/mounting/anchor
load case, fixture drawings and guard containment needs; operator pendant and
independent hardwired stopping interface

**Receiving or first-article evidence:** Fixture/guard inspection and reviewed
test-area/stop arrangement before energizing; the bench pendant is not a
substitute for the industrial remote intended for the rolling-chassis phase

### PS35: Dynamometer and torque measurement

**Cost-ledger coverage:** TST-005:TST-008

**Required purchasing/manufacturing definition:** Matched torque/speed transducer,
readout, couplings and load device; range/overload, rpm, continuous power/heat
rejection, calibration and acquisition interfaces

**Receiving or first-article evidence:** Complete supplier package and fixture
integration review; traceable calibration and authorized shakedown; load device must
absorb selected full duty, not merely survive a peak

### PS36: Instruments and workshop tools

**Cost-ledger coverage:** TST-009:TST-015

**Required purchasing/manufacturing definition:** Exact instrument/tool ranges,
accuracy, DC capability, electrical ratings, torque range, compatible crimp dies and
calibration/inspection requirements

**Receiving or first-article evidence:** Tool/asset register, condition and calibration
evidence; correct crimp tooling and approved process coupons; IR reading not treated as
winding temperature

### PS37: Fabrication consumables

**Cost-ledger coverage:** CON-001:CON-004

**Required purchasing/manufacturing definition:** Welding filler/gas matched to released
materials/process; abrasive/drill suitability; specified lubricant/sealant/thread-lock
grade and storage/use limits

**Receiving or first-article evidence:** Batch/expiry and supplier compatibility where
applicable; consumables schedule tied to work instructions, no generic substitution on
critical joints

### PS38: Initial spare parts

**Cost-ledger coverage:** CON-005:CON-005

**Required purchasing/manufacturing definition:** Split spare lot into exact
fuse/contact/seal/fastener/pin MPNs, quantities and approved interchangeability after
installed selections freeze

**Receiving or first-article evidence:** Separate spare stock list and labels; fuse
substitutions need coordination review; no complete spare motor/pack/track included

### PS39: PPE, charging area and cleaning

**Cost-ledger coverage:** CON-006:CON-010

**Required purchasing/manufacturing definition:** Task-specific PPE and barrier list,
charging-area surface/layout, fire-adviser-selected equipment, compatible cleaning
products and inspection tools

**Receiving or first-article evidence:** Correct items/condition and expiry/service
checks where applicable; reviewed charging/incident/cleaning instructions; no
pressure-wash or battery-fire suppression capability assumed

[↑ Back to document overview](workshop.md#document-overview)


## Sourcing

[S04](sources.md#s04) · [S06](sources.md#s06) · [S07](sources.md#s07) · [S19](sources.md#s19) · [S20](sources.md#s20) · [S21](sources.md#s21) · [S22](sources.md#s22).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](workshop.md#document-overview)


## Interfaces with other scopes

- [Propulsion, reductions and brakes](propulsion.md)
- [Frame, scissor and spine](frame.md)
- [Electronics, power distribution and safety](electronics.md)

[↑ Back to document overview](workshop.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: loose-handling

**Loose slings straps shackles and service supports**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| MNT-003 - Rated lifting slings (2 each) | €40.00 / A |
| MNT-004 - Transport ratchet straps (4 each) | €72.00 / A |
| MNT-005 - Rated shackles (4 each) | €32.00 / A |
| MNT-006 - Machine service supports (2 each) | €80.00 / A |
| **Module subtotal** | €224.00 |

### Cost: bench-fixture

**Bench fixture guards and pendant**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| TST-001 - Guarded bench fixture steel (20 kg) | €70.00 / A |
| TST-002 - Fixture feet anchors and fasteners (1 set) | €30.00 / A |
| TST-003 - Fixture guarding and protective screen (1 m2) | €35.00 / A |
| TST-004 - Maintained-action bench pendant (1 set) | €35.00 / A |
| **Module subtotal** | €170.00 |

### Cost: dynamometer

**Dynamometer torque measurement and adapters**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| TST-005 - Rotary torque transducer and speed output provision (1 set) | €1,500.00 / A |
| TST-006 - Torque sensor readout interface and software provision (1 set) | €250.00 / A |
| TST-007 - Guarded dynamometer load and heat-dissipation provision (1 set) | €1,200.00 / A |
| TST-008 - Test coupling adapters and alignment hardware (1 set) | €100.00 / A |
| **Module subtotal** | €3,050.00 |

### Cost: bench-tools

**Meters instruments hand tools and crimp tooling**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| TST-009 - Digital multimeter (1 each) | €70.00 / A |
| TST-010 - DC-capable clamp meter (1 each) | €100.00 / A |
| TST-011 - Infrared spot thermometer (1 each) | €50.00 / A |
| TST-012 - Handheld tachometer (1 each) | €50.00 / A |
| TST-013 - Torque wrench (1 set) | €60.00 / A |
| TST-014 - Insulated hand tools (1 set) | €80.00 / A |
| TST-015 - Cable crimp tool dies and continuity accessories (1 set) | €90.00 / A |
| **Module subtotal** | €500.00 |

### Cost: consumables

**Fabrication consumables and initial spares**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| CON-001 - Welding wire and electrode allowance (1 lot) | €30.00 / A |
| CON-002 - Shielding gas refill allowance (1 lot) | €50.00 / A |
| CON-003 - Cutting grinding and drilling consumables (1 lot) | €40.00 / A |
| CON-004 - Thread locking sealant and grease (1 lot) | €25.00 / A |
| CON-005 - Initial electrical and mechanical spares (1 lot) | €100.00 / A |
| **Module subtotal** | €245.00 |

### Cost: ppe-support

**PPE barriers charging surface fire and cleaning supplies**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| CON-006 - General workshop and field PPE (1 set) | €80.00 / A |
| CON-007 - Warning signs and portable test-area barriers (1 set) | €100.00 / A |
| CON-008 - Noncombustible charging surface materials (1 set) | €60.00 / A |
| CON-009 - General workshop fire equipment allowance (1 set) | €60.00 / A |
| CON-010 - Cleaning and inspection kit (1 set) | €25.00 / A |
| **Module subtotal** | €325.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €4,514.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](workshop.md#document-overview)
