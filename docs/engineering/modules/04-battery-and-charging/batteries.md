# Batteries, enclosures and charging

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Two independent 51.2 V / 100 Ah LiFePO4 packs are the sizing
baseline. Ultimatron UBL-48-100H is the recommended budget reference, with two
priced alternatives below. None is qualified for the mower; inspect the
electrical and packaging holds before treating a price as a purchase decision.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Ultimatron UBL-48-100H](batteries.md#48-v--approximately-2-kw-per-drive) | Recommended budget reference; pack fit and duty remain HOLD | [Three priced options](batteries.md#battery-alternatives) · [Baseline costs](batteries.md#0401-battery-packs-with-integrated-bms) | [Battery-to-pod fit](batteries.md#battery-to-pod-fit) |
| [Greenboatsolutions metal pack](batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack) | Lower-cost alternative; conflicting current/power data | [Price and limitations](batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack) | [Pack/BMS requirements](batteries.md#ps18-battery-packs-and-bms) |
| [ACES AL48V100HFA-BT](batteries.md#premium-alternative-aces-al48v100hfa-bt) | Lighter premium alternative; excluded from totals | [Price and data](batteries.md#premium-alternative-aces-al48v100hfa-bt) | [Controller compatibility](../02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| [BMS](batteries.md#ps18-battery-packs-and-bms) | Included in pack costs; limits and vehicle/regen behavior unqualified | [Pack/BMS requirements](batteries.md#ps18-battery-packs-and-bms) · [Included-cost treatment](batteries.md#0401-battery-packs-with-integrated-bms) | [Main protection](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| [Battery enclosure and restraints](batteries.md#ps19-battery-enclosures-and-restraints) | Separate allowance; containment design open | [Enclosure costs](batteries.md#0402-battery-enclosures-restraints-and-insulation) · [Mechanical requirements](batteries.md#ps19-battery-enclosures-and-restraints) | [Pod, track and tensioner clearance](batteries.md#battery-to-pod-fit) |
| [Charger and charge connector](batteries.md#ps20-charging-and-charge-interlocks) | Matched chargers not selected; avoid duplicate bundle costs | [Chargers](batteries.md#0403-matched-battery-chargers) · [Connectors/interlock harness](batteries.md#0404-charge-connectors-fuse-holders-and-interlock-harness) · [Charge requirements](batteries.md#ps20-charging-and-charge-interlocks) | [Motion-inhibit/stop interface](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |

**Further detail:** [Battery alternatives](batteries.md#battery-alternatives) ·
[Release requirements](batteries.md#specification-and-inspection-requirements) ·
[Sourcing](batteries.md#sourcing) · [Interfaces](batteries.md#interfaces-with-other-scopes) ·
[Itemized costs](batteries.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 04 overview](README.md)

## Battery alternatives

Prices follow the [estimate rules](../../bom/chassis-bom.md#estimate-rules).
Nominal voltage alone does not establish controller or charger compatibility.

**Confirmed direction:** two 48 V-class / **51.2 V, 100 Ah LiFePO4 packs**, one
per independent pod, not a series-connected higher-voltage bank. Capacity in
Ah does not specify the required current in A. All three options include a
reported BMS and are marketed for mobile/boat-motor use, not merely rack storage.

**Public-price snapshot, 2026-10-28:** these are three distinct packs sold by
the German retailer Greenboatsolutions. Prices below include its displayed
**19% VAT**, exclude shipping and chargers, and use single-pack prices
multiplied by two, not an assumed pair discount.

| Rank / option | Direct product and exact reference | Public price each | Two packs | Body dimensions / pair mass |
| --- | --- | ---: | ---: | --- |
| 1 - recommended budget reference | [Ultimatron UBL-48-100H](https://greenboatsolutions.com/shop/battery/lithium/ultimatron-lithium-battery-48-v-100-ah-with-bluetooth) | **€1,699.00** | **€3,398.00** | 420 × 320 × 260 mm / 98.4 kg |
| 2 - lower-cost alternative | [Greenboatsolutions metal pack, S-EU-L131211800094-1](https://greenboatsolutions.com/shop/battery/lithium/48v-100ah-metal-blue?v=a75f) | **€1,199.00** | **€2,398.00** | 504 × 280 × 233 mm / 86 kg |
| 3 - lighter premium alternative | [ACES AL48V100HFA-BT](https://greenboatsolutions.com/shop/battery/lithium/ACES-48V-100Ah-lithium-battery?v=6796) | **€2,899.00** | **€5,798.00** | 522 × 267 × 218 mm / 78 kg |

The recommendation balances an identified manufacturer, advertised five-year
warranty, integrated heating and price. It is **conditional on repackaging and
qualification**, not a claim that the heavier/taller Ultimatron already fits.
The lower-cost pack has weaker model-specific evidence and conflicting ratings;
ACES offers the closest envelope to the former pack at a substantial price premium.
Alternatives are not additive purchases and do not enter baseline totals.

### 48 V / approximately 2 kW per drive

**Inspect this pack:** [Cost table](batteries.md#0401-battery-packs-with-integrated-bms) ·
[Mounting in the pod](batteries.md#battery-to-pod-fit) ·
[Charger and connector](batteries.md#ps20-charging-and-charge-interlocks).

| Attribute | Ultimatron UBL-48-100H budget reference |
| --- | --- |
| Planning price per pack | **€1,727.55**; **€3,455.10 for two**, using `1699 / 1.19 × 1.21` for the Romanian cash-budget comparison; not a checkout/delivered quote |
| Capacity | **51.2 V / 100 Ah / 5.12 kWh** per pack; **10.24 kWh nominal** for two |
| Current / BMS claims | Product table: **200 A maximum discharge**, **50 A maximum charge**, integrated BMS; continuous rating, peak duration and regen limits not established |
| Packaging | **420 × 320 × 260 mm**, **49.2 kg** per pack; **98.4 kg** per pair, before enclosures/restraints |
| Protection / support claims | Bluetooth, integrated heating, five-year warranty. Table says **IP64**, generic prose says **IP65**; protection rating and mower-duty warranty coverage need confirmation |
| Listing availability | Marked available, advertised dispatch 3-5 days; not proof of two-unit stock or Romania delivery |

Evidence: [Ultimatron and charger evidence (S27)](../../bom/sources.md#s27-ultimatron-ubl-48-100h-and-charger).

**Equal-energy budgeting:** Planning assumption of 80% usable gives **8.192 kWh** from
two packs, before additional operational reserve, cold and aging margins. It
does not prove the preferred operating duration.

**Electrical hold:** The generic seller prose also mentions 150 A, unlike the
200 A product table. Obtain an exact-model datasheet with full/cutoff voltage,
continuous/peak duty and duration, charge/regen limits versus SOC/temperature,
BMS opening/recovery and cold-charge behavior. Heating is a listed feature,
not an accepted cold-charge strategy. Marine marketing, CE claims and an IP
label do not qualify off-road vibration, shocks, mounting or mower use.

**Charger budget:** The product configurator separately lists a **48 V / 10 A
LiFePO4 charger at €159 including 19% VAT**. It is not included in the €1,699
battery price. Budget two at **€161.67 each / €323.34 total**, using the same
19%-to-21% tax normalization. This replaces the former €160 allowance with a
public-price reference, not a qualified charger selection: model, CV voltage,
connectors, mains demand and charge interlocks remain open. Restoring an
assumed 80 Ah per pack at 10 A takes about eight hours before taper/balancing
and any warm-up delay, with both chargers operating concurrently.

### Lower-cost alternative: greenboatsolutions metal pack

Seller SKU **S-EU-L131211800094-1**, branded Greenboatsolutions, with the
manufacturer/OEM identity not established. Listed 51.2 V / 100 Ah / 5.12 kWh,
43 kg, 504 × 280 × 233 mm, integrated BMS, Bluetooth, no heater and a three-year
warranty. The table claims IP65 but the seller explicitly requires a dry,
protected installation without direct water/rain contact.

Reported maxima are **200 A discharge / 50 A charge**, but the same table
states **5.12 kW maximum discharge power**, inconsistent with 200 A at 51.2 V.
Continuous/peak definitions, cold-charge inhibition and regen acceptance are
unconfirmed. The inverter-connection warning also requires interface review.
Listed available/immediately dispatchable; a 10 A charger is separately €159.
Its lower price and smaller envelope are attractive, but these evidence gaps
prevent it from displacing the branded budget reference.

Evidence: [Seller-branded pack (S28)](../../bom/sources.md#s28-greenboatsolutions-100-ah-metal-pack).
Its 21%-VAT planning equivalent would be €1,219.15 each, excluded from totals.

### Premium alternative: ACES AL48V100HFA-BT

ACES Energy is identified as a Netherlands supplier. Listed 51.2 V / 100 Ah /
5.12 kWh, **39 kg**, **522 × 267 × 218 mm**, integrated BMS, Bluetooth, IP65,
no heater and a five-year warranty. Seller maxima are **200 A discharge /
100 A charge**, not established continuous/peak-duration or regen ratings.
The seller explicitly says not to charge below 0°C; automatic BMS inhibition
and exact temperature limits still require manufacturer evidence.

Listed available with **3-4 weeks** dispatch, not immediate warehouse stock.
The configurator separately lists an ACES 48 V / 10 A charger at **€279**
including 19% VAT; it is not included in the €2,899 pack price. The compact
envelope and 78 kg pair are advantages, but the substantial premium is not
justified for the current budget without stronger application-specific evidence.
Evidence: [ACES pack (S29)](../../bom/sources.md#s29-aces-al48v100hfa-bt).
Its 21%-VAT planning equivalent would be €2,947.72 each, excluded from totals.

### Tax and delivery basis

The public prices include German 19% VAT. The ledger removes that tax and
applies the existing Romanian 21% planning rate, rounding unit costs half-up
before multiplying by quantity. This is a disclosed cash-budget calculation,
not another VAT addition or a verified destination checkout price.

The seller's [shipping policy](https://greenboatsolutions.com/shipping)
advertises EU delivery, with different charges for battery parcels, oversize
parcels and hazardous-goods freight (including a €299 EU freight category).
The correct class and total for two heavy packs delivered to Romania are
unconfirmed; do not assume the lower €39 battery-parcel rate covers this order.
Keep freight outside the pack prices. The existing provision is unchanged and
not proven adequate for this order; an actual delivery quote remains necessary.
No order or supplier message has been sent.

Direct-import leads were considered, not automatically treated as available in
Romania. For example, the [WattCycle shipping policy](https://www.wattcycle.com/policies/shipping-policy)
limits delivery to the continental US, contrary to a search summary suggesting
European delivery. No such unsupported shipping claim enters this shortlist.

### Historical Elker study reference

The former [Elker LFP10048LCD (S16)](../../bom/sources.md#s16-elker-lfp10048lcd-battery)
was 51.2 V / 100 Ah, **522 × 269 × 217 mm and 36 kg**, with 100 A maximum
discharge and unresolved vehicle/regen duty. Its €1,019.90 displayed price
plus the former conditional tax reserve produced €1,234.08 per pack.
It no longer supplies the active budget or current-pack dimensions.
The existing CAD and clearance examples still use that historical envelope;
they have not been redesigned for the recommended pack.

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS18: Battery packs and BMS

**Cost-ledger coverage:** BAT-001:BAT-001

**Part links:** [Pack choices and prices](batteries.md#parts-at-a-glance) ·
[Cumulative pack costs](batteries.md#0401-battery-packs-with-integrated-bms) ·
[Pod fit](batteries.md#battery-to-pod-fit) ·
[Motor/controller load](../02-drive-train/propulsion.md#compatibility-and-duty-limitations) ·
[Preferred runtime and energy cases](../../../../plan.md#eight-hour-runtime-and-charging-study) ·
[Flat-mowing draw screen](../../../../plan.md#flat-terrain-mowing-draw-at-4-kmh).

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

**Part links:** [Enclosure costs](batteries.md#0402-battery-enclosures-restraints-and-insulation) ·
[Pack data](batteries.md#parts-at-a-glance) ·
[Battery-to-pod fit](batteries.md#battery-to-pod-fit).

**Required purchasing/manufacturing definition:** Battery enclosure material/thickness,
debris shielding, terminal insulation, removable restraint and shock/rollover load path;
drainage/venting/thermal design and galvanic compatibility

**Receiving or first-article evidence:** Drawing/material match, restraint installation
and isolation/clearance inspection; reviewed environmental evidence; no printed battery
containment or fire-containment assumption

#### Battery-to-pod fit

The [recommended pack](batteries.md#48-v--approximately-2-kw-per-drive)
is 420 × 320 × 260 mm and 49.2 kg; no complete pod fit is established.
The old CAD envelope was 522 × 269 × 217 mm and 36 kg. Its nominal 43 mm
vertical margin is entirely consumed by the new pack's additional 43 mm
height, before installation, guarding or tensioner clearance. This is a
repackaging hold, not a claim that the new pack fits the unchanged study.
The [minimum-width calculation](../../width-and-slope-sizing.md#minimum-width-and-packaging)
checks lateral packaging; the
[battery-clearance calculation](../../width-and-slope-sizing.md#provisional-battery-clearance)
checks the illustrative track path and carrier. Neither is a released layout.

Also reconcile the [spring-tensioner sweep](../01-structure-and-running-gear/running-gear.md#spring-tensioner-concept),
restraint/load path, terminal protection, ventilation/drainage, cable clearance,
and outboard removal path. Update the mass/CG budget for the 98.4 kg pair;
the former 72 kg pair is not the current configuration. Do not silently
substitute new battery dimensions into the old CAD or infer a usable width.

**Continue:** [Enclosure/retention costs](batteries.md#0402-battery-enclosures-restraints-and-insulation) ·
[Pod frame](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) ·
[Power terminals and harness](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness).

### PS20: Charging and charge interlocks

**Cost-ledger coverage:** BAT-005:BAT-007

**Part links:** [Charger costs](batteries.md#0403-matched-battery-chargers) ·
[Connector/interlock costs](batteries.md#0404-charge-connectors-fuse-holders-and-interlock-harness) ·
[Pack/BMS limits](batteries.md#ps18-battery-packs-and-bms) ·
[Independent stop interface](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) ·
[Cold-shelter charging requirement](../../../../plan.md#charging-environment) ·
[Shared household supply and charging study](../../../../plan.md#eight-hour-runtime-and-charging-study).

**Required purchasing/manufacturing definition:** Exact charge
profile/voltage/current/temperature restrictions, mains input/plug, BMS compatibility,
connectors/contact ratings/polarity and charge fuse; charging interlock inhibits motion

**Receiving or first-article evidence:** Correct charger identity/settings, keyed
polarity/continuity and interlock evidence; reconcile included charger bundles before
ordering

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)


## Sourcing

| Evidence scope | Named sources |
| --- | --- |
| Pack and charger references | [Ultimatron and charger (S27)](../../bom/sources.md#s27-ultimatron-ubl-48-100h-and-charger) · [Lower-cost pack (S28)](../../bom/sources.md#s28-greenboatsolutions-100-ah-metal-pack) · [ACES pack (S29)](../../bom/sources.md#s29-aces-al48v100hfa-bt) |
| Containment, restraints and wiring | [DOLD mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) · [Dedeman fabrication supplies (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) · [RS electrical parts (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Drive current and regeneration | [Motor/controller compatibility](../02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| Fault current, isolation and precharge | [Main switching](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) · [Precharge and discharge](../05-power-cables-and-electronics/power-distribution.md#ps22-precharge-and-discharge) |
| BMS opening, stopping and stored energy | [Independent stop requirements](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Enclosure mounting and service clearance | [Frame stock and weldments](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) · [Minimum-width packaging screen](../../width-and-slope-sizing.md#minimum-width-and-packaging) |

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)

## Detailed module costs

**Cost context:** [Battery/charging totals](../../cost-breakdown.md#04--battery-and-charging) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-packs"></a>

### 04.01 Battery packs with integrated BMS

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [BAT-001 - Ultimatron UBL-48-100H 51.2 V 100 Ah pack with BMS](batteries.md#ps18-battery-packs-and-bms) (2 each) | €3,455.10 / C |
| **Module subtotal** | €3,455.10 |

<a id="cost-battery-housing"></a>

### 04.02 Battery enclosures restraints and insulation

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [BAT-002 - Battery enclosure and terminal cover](batteries.md#ps19-battery-enclosures-and-restraints) (2 each) | €180.00 / A |
| [BAT-003 - Battery restraint and vibration-isolation hardware](batteries.md#ps19-battery-enclosures-and-restraints) (2 pod set) | €60.00 / A |
| [BAT-004 - Drain sealing and terminal-insulation materials](batteries.md#ps19-battery-enclosures-and-restraints) (2 pod set) | €30.00 / A |
| **Module subtotal** | €270.00 |

<a id="cost-chargers"></a>

### 04.03 Matched battery chargers

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [BAT-005 - Retailer-listed 48 V 10 A LiFePO4 charger](batteries.md#ps20-charging-and-charge-interlocks) (2 each) | €323.34 / C |
| **Module subtotal** | €323.34 |

<a id="cost-charge-harness"></a>

### 04.04 Charge connectors fuse holders and interlock harness

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [BAT-006 - Charge connector and protective cap](batteries.md#ps20-charging-and-charge-interlocks) (2 pair) | €40.00 / A |
| [BAT-007 - Charge fuse holder and interlock harness](batteries.md#ps20-charging-and-charge-interlocks) (2 pod set) | €50.00 / A |
| **Module subtotal** | €90.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €4,138.44 |
<!-- END GENERATED: details -->

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)
