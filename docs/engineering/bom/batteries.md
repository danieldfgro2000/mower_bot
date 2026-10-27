# Batteries, enclosures and charging

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Compares the [costed 48 V and 72 V battery scenarios](batteries.md#battery-alternatives) and
[pack, enclosure, charging, and interlock requirements](batteries.md#specification-and-inspection-requirements).
Candidate pack claims do not establish vehicle suitability or
controller/charger compatibility; compare them with the
[supplier evidence](sources.md#source-id-lookup).

**Navigate:** [Alternatives](batteries.md#battery-alternatives) ·
[Requirements](batteries.md#specification-and-inspection-requirements) ·
[Sourcing](batteries.md#sourcing) · [Interfaces](batteries.md#interfaces-with-other-scopes) ·
[Itemized costs](batteries.md#detailed-module-costs) |
[Chassis BOM](../chassis-bom.md#scope-and-decisions) ·
[Cost totals](../cost-breakdown.md#battery-and-charging) ·
[Ledger](../chassis-bom.csv) ·
[Release checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-id-lookup)

## Battery alternatives

Prices follow the [estimate rules](../chassis-bom.md#estimate-rules).
Nominal voltage alone does not establish controller or charger compatibility.

### 48 V / approximately 2 kW per drive

**Battery reference:** Elker LFP10048LCD: 51.2 V, 100 Ah, **5.12 kWh**, 100 A listed
maximum discharge, 300 A for 3 s; integrated BMS, 36 kg. **Two = 10.24 kWh nominal**.
[S16](https://elkersolutions.com/product/lifepo4-lithium-battery-48v-100ah/)

**Equal-energy budgeting:** Planning assumption of 80% usable gives **8.192 kWh** from
two reference packs, before any separately required operational reserve, cold, or aging
margin. Not a measured result.

**Battery qualification:** Off-grid/stationary-oriented listing is **not proven suitable
for vehicle vibration, shocks, continuous drive discharge, or regeneration**. 100 A is a
published maximum, not established continuous qualification.

**Chargers:** Two matched charger allowances of €160 each; exact chemistry and charge
profile to confirm.

### 72 V / approximately 4 kW per drive

**Battery reference:** TZI 72 V / 60 Ah reference: €1,735 at conditional 0% VAT; current
structured description says **100 A BMS / 200 A for 3 s** and an 83.95 V / 10 A charger.
Voltage/series count, mass, availability, and charging require clarification.
[S17](https://www.tzipower.de/lifepo4-akkus/72v-60ah-lithium-lifepo4-akku-pedelec-e-bike-e-bike-akkupack-roller-scooter-pv_1916_9570/)

**Equal-energy budgeting:** Two nominal 72 V / 60 Ah packs would give only **6.912 kWh
at 80%**. Budget **two 70 Ah packs**, approximately 10.08 kWh nominal / 8.064 kWh at
80%. Price allowance: `1735 × 70/60 × 1.21` = **€2,449.24 per pack**. No actual 70 Ah
offer is verified; linear capacity pricing is only an allowance.

**Battery qualification:** Reference page's salability flag is false in retrieved data;
do not assume stock. Conflicting mass metadata and the unusual charger voltage must be
resolved. The custom 70 Ah pack is **unquoted**.

**Chargers:** Two €220 charger allowances. BAT-001 is a custom battery-only budget,
conservatively anchored to a reference bundle that includes a charger; deduct BAT-005 if
the actual pack quotation includes the required charger.

[↑ Back to document overview](batteries.md#document-overview)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS18: Battery packs and BMS

**Cost-ledger coverage:** BAT-001:BAT-001

**Required purchasing/manufacturing definition:** Exact chemistry/series count,
full/cutoff voltage, usable energy, continuous/peak discharge and charge/regen limits
versus temperature/SOC; BMS limits/disconnect behavior; terminal layout/mass/envelope,
vibration and transport documentation

**Receiving or first-article evidence:** Pack/charger/controller compatibility,
traceable pack serials and BMS configuration; supplier battery transport evidence as
applicable, including UN 38.3 test summary for lithium shipment; separately authorized
capacity/thermal/fault results

### PS19: Battery enclosures and restraints

**Cost-ledger coverage:** BAT-002:BAT-004

**Required purchasing/manufacturing definition:** Battery enclosure material/thickness,
debris shielding, terminal insulation, removable restraint and shock/rollover load path;
drainage/venting/thermal design and galvanic compatibility

**Receiving or first-article evidence:** Drawing/material match, restraint installation
and isolation/clearance inspection; reviewed environmental evidence; no printed battery
containment or fire-containment assumption

### PS20: Charging and charge interlocks

**Cost-ledger coverage:** BAT-005:BAT-007

**Required purchasing/manufacturing definition:** Exact charge
profile/voltage/current/temperature restrictions, mains input/plug, BMS compatibility,
connectors/contact ratings/polarity and charge fuse; charging interlock inhibits motion

**Receiving or first-article evidence:** Correct charger identity/settings, keyed
polarity/continuity and interlock evidence; reconcile included charger bundles before
ordering

[↑ Back to document overview](batteries.md#document-overview)


## Sourcing

[S04](sources.md#s04) · [S06](sources.md#s06) · [S07](sources.md#s07) · [S16](sources.md#s16) · [S17](sources.md#s17).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](batteries.md#document-overview)


## Interfaces with other scopes

- [Propulsion, reductions and brakes](propulsion.md)
- [Electronics, power distribution and safety](electronics.md)
- [Frame, scissor and spine](frame.md)

[↑ Back to document overview](batteries.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: packs

**Battery packs with integrated BMS**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| BAT-001 - Battery module with integrated BMS (2 each) | €2,468.16 / C | €4,898.48 / A |
| **Module subtotal** | €2,468.16 | €4,898.48 |

### Cost: battery-housing

**Battery enclosures restraints and insulation**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| BAT-002 - Battery enclosure and terminal cover (2 each) | €180.00 / A |
| BAT-003 - Battery restraint and vibration-isolation hardware (2 pod set) | €60.00 / A |
| BAT-004 - Drain sealing and terminal-insulation materials (2 pod set) | €30.00 / A |
| **Module subtotal** | €270.00 |

### Cost: chargers

**Matched battery chargers**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| BAT-005 - Matched battery charger (2 each) | €320.00 / A | €440.00 / A |
| **Module subtotal** | €320.00 | €440.00 |

### Cost: charge-harness

**Charge connectors fuse holders and interlock harness**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| BAT-006 - Charge connector and protective cap (2 pair) | €40.00 / A |
| BAT-007 - Charge fuse holder and interlock harness (2 pod set) | €50.00 / A |
| **Module subtotal** | €90.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €3,148.16 | €5,698.48 |
<!-- END GENERATED: details -->

[↑ Back to document overview](batteries.md#document-overview)
