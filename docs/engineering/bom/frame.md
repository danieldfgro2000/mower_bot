# Frame, scissor and spine

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**On this page:** [Itemized costs](frame.md#detailed-module-costs) ·
[Requirements](frame.md#specification-and-inspection-requirements) ·
[Sourcing](frame.md#sourcing) · [Interfaces](frame.md#interfaces-with-other-scopes)

**BOM documents:** [BOM overview](../chassis-bom.md) ·
[Structure and running gear totals](../cost-breakdown.md#structure-and-running-gear)

**Related records:** [Cost ledger](../chassis-bom.csv) ·
[Build checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-register)

Structural stock, weldments, pivots, positive holding, guards, joints and installed handling points.

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: frame-stock

**Frame stock and mounting plates**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| CHS-001 - Pod frame tube stock (30 kg) | €105.00 / A | €105.00 / A |
| CHS-002 - Scissor frame tube stock (25 kg) | €87.50 / A | €87.50 / A |
| CHS-003 - Longitudinal spine tube stock (15 kg) | €52.50 / A | €52.50 / A |
| CHS-004 - Motor and reducer mounting plate stock (12 kg) | €48.00 / A | €48.00 / A |
| CHS-005 - Pod side and base plate stock (20 kg) | €80.00 / A | €80.00 / A |
| CHS-006 - Scissor link and gusset plate stock (10 kg) | €40.00 / A | €40.00 / A |
| **Module subtotal** | €413.00 | €413.00 |

### Cost: frame-pivots

**Scissor pivots locks and hard stops**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| CHS-007 - Pivot shaft stock (4 kg) | €32.00 / A | €32.00 / A |
| CHS-008 - Scissor pivot bushings (12 each) | €48.00 / A | €48.00 / A |
| CHS-009 - Scissor pivot pins and retainers (6 each) | €48.00 / A | €48.00 / A |
| CHS-010 - Unresolved positive width-lock provision (4 each) | €48.00 / A | €48.00 / A |
| CHS-011 - Width hard-stop material (1 set) | €20.00 / A | €20.00 / A |
| **Module subtotal** | €196.00 | €196.00 |

### Cost: frame-finish

**Guards fasteners coatings and labels**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| CHS-012 - Guard sheet and mesh (3 m2) | €105.00 / A | €105.00 / A |
| CHS-013 - Guard edge trim (5 m) | €15.00 / A | €15.00 / A |
| CHS-014 - Structural bolts nuts washers and retainers (1 lot) | €90.00 / A | €90.00 / A |
| CHS-015 - Primer topcoat and corrosion-preparation materials (1 kit) | €60.00 / A | €60.00 / A |
| CHS-016 - Width markings and identification labels (1 set) | €10.00 / A | €10.00 / A |
| **Module subtotal** | €280.00 | €280.00 |

### Cost: handling-points

**Installed lifting and recovery points**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| MNT-001 - Chassis lifting and tie-down eyes (4 each) | €60.00 / A | €60.00 / A |
| MNT-002 - Prototype recovery towing bracket (1 set) | €40.00 / A | €40.00 / A |
| **Module subtotal** | €100.00 | €100.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €989.00 | €989.00 |
<!-- END GENERATED: details -->

## Sourcing

[S04](sources.md#s04) · [S06](sources.md#s06) · [S07](sources.md#s07).

Catalog links and price proxies are not approved suppliers or delivered quotes.

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS04: Frame stock and weldments

**Cost-ledger coverage:** CHS-001:CHS-006

**Required purchasing/manufacturing definition:** Tube grade/standard, section/wall and
cut lengths; plate grade/thickness, profiles and hole datums; weldment drawing, weld
size/process/sequence, distortion limits, drainage and corrosion access

**Receiving or first-article evidence:** Stock traceability and actual cut list;
reviewed weld procedure and required welder competence; dimensional and weld-inspection
records against approved criteria

### PS05: Scissor pivots

**Cost-ledger coverage:** CHS-007:CHS-009

**Required purchasing/manufacturing definition:** Pivot materials/heat treatment,
shaft/bushing fits, bearing lengths, wear limits, lubrication, retainers and replacement
access; shear/bearing/fatigue load assessment

**Receiving or first-article evidence:** Material and dimensions; pivot alignment, end
float, retention and movement measured against drawing tolerances

### PS06: Width holding and hard stops

**Cost-ledger coverage:** CHS-010:CHS-011

**Required purchasing/manufacturing definition:** Reviewed positive holding arrangement,
its load path and engagement indication; fail-state and unintended-release prevention;
hard-stop strength and location; compatibility with powered adjustment

**Receiving or first-article evidence:** Approved design resolving worm-only proposal;
holding and stop-load evidence, lock-state/interlock checks under an authorized test
plan; pin allowance alone cannot close this

### PS07: Guards and edge protection

**Cost-ledger coverage:** CHS-012:CHS-013

**Required purchasing/manufacturing definition:** Guard material/thickness,
opening/access geometry, fasteners, service access, edge treatment and clearances at
every width; separate fixed/removable guards

**Receiving or first-article evidence:** Drawing and hazard-review conformity;
retention, edge and access inspection; no implied impact containment from sheet area

### PS08: Fasteners, coatings and labels

**Cost-ledger coverage:** CHS-014:CHS-016

**Required purchasing/manufacturing definition:** Fastener schedule with
thread/length/grade/coating, washers/nuts and locking method; joint-specific tightening
method/torque; surface preparation and coating system; durable width/identity labels

**Receiving or first-article evidence:** Fastener identity and installation record;
coating preparation/thickness criteria where specified; labels legible and consistent
with actual configuration, no unearned conformity marks

### PS32: Installed lifting and recovery points

**Cost-ledger coverage:** MNT-001:MNT-002

**Required purchasing/manufacturing definition:** Lifting/tie-down/recovery points
separately identified, load cases/directions, weld/fastener attachment and frame load
path, allowed configurations and recovery method

**Receiving or first-article evidence:** Reviewed drawings/load assessment, material and
installation records; rated point markings and inspection criteria; recovery bracket not
a certified lifting point by default

## Interfaces with other scopes

- [Powered width adjustment](width-adjustment.md)
- [Tracks and running gear](running-gear.md)
- [Workshop, bench equipment and service supplies](workshop.md)
