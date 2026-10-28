# Batteries, enclosures and charging

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Two independent 51.2 V / approximately 100 Ah LiFePO4 packs are
the sizing baseline; modestly higher capacity, including 105 Ah, is acceptable.
DC HOUSE's 100 Ah / 18 A charger bundle is the conditional first choice and
budget reference. Greenboatsolutions and Vatrer remain priced alternatives.
None is qualified for the mower; electrical, packaging and delivery holds remain.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [DC HOUSE 100 Ah bundle](batteries.md#48-v--approximately-2-kw-per-drive) | First-choice budget candidate; qualification HOLD | [Prices](batteries.md#battery-alternatives) · [Baseline costs](batteries.md#0401-battery-packs-with-integrated-bms) | [Battery-to-pod fit](batteries.md#battery-to-pod-fit) |
| [Greenboatsolutions metal pack](batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack) | Retained €1,199 battery-only alternative; conflicting ratings | [Price and limitations](batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack) | [Pack/BMS requirements](batteries.md#ps18-battery-packs-and-bms) |
| [Vatrer 105 Ah mobile packs](batteries.md#vatrer-105-ah-alternatives) | Separate supplier, bundled 20 A charger; excluded from totals | [UTV, standard and mini prices](batteries.md#vatrer-105-ah-alternatives) | [Controller compatibility](../02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| [BMS](batteries.md#ps18-battery-packs-and-bms) | Included in pack costs; limits and vehicle/regen behavior unqualified | [Pack/BMS requirements](batteries.md#ps18-battery-packs-and-bms) · [Included-cost treatment](batteries.md#0401-battery-packs-with-integrated-bms) | [Main protection](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| [Battery enclosure and restraints](batteries.md#ps19-battery-enclosures-and-restraints) | Separate allowance; containment design open | [Enclosure costs](batteries.md#0402-battery-enclosures-restraints-and-insulation) · [Mechanical requirements](batteries.md#ps19-battery-enclosures-and-restraints) | [Pod, track and tensioner clearance](batteries.md#battery-to-pod-fit) |
| [Charger and charge connector](batteries.md#ps20-charging-and-charge-interlocks) | 18 A chargers included in pack budget; interfaces unqualified | [Chargers](batteries.md#0403-matched-battery-chargers) · [Connectors/interlock harness](batteries.md#0404-charge-connectors-fuse-holders-and-interlock-harness) · [Charge requirements](batteries.md#ps20-charging-and-charge-interlocks) | [Motion-inhibit/stop interface](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |

**Further detail:** [Battery alternatives](batteries.md#battery-alternatives) ·
[Release requirements](batteries.md#specification-and-inspection-requirements) ·
[Sourcing](batteries.md#sourcing) · [Interfaces](batteries.md#interfaces-with-other-scopes) ·
[Itemized costs](batteries.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 04 overview](README.md)

## Battery alternatives

Prices follow the [estimate rules](../../bom/chassis-bom.md#estimate-rules).
Nominal voltage alone does not establish controller or charger compatibility.

**Confirmed direction:** two 48 V-class / **51.2 V, approximately 100 Ah
LiFePO4 packs**, one per independent pod, not a series-connected higher-voltage
bank. Small capacity variations are accepted, preferably upward; 105 Ah is
within scope. Capacity in Ah does not specify required current in A.

**Public-price snapshot, 2026-10-28:** three supplier options, all marketed for
mobile use. Prices are displayed offers, **not comparable landed quotes**:
GBS explicitly includes 19% VAT; destination tax for DC HOUSE and Vatrer is
unconfirmed. Pair figures below are twice the single-unit price. Only the
DC HOUSE bundle enters totals. Alternatives are replacements, not additions.

| Rank / option | Direct product and exact reference | Public price each | Two packs / bundles | Body dimensions / pair mass |
| --- | --- | ---: | ---: | --- |
| 1 - conditional first choice / budget reference | [DC HOUSE non-DE EU bundle, S-DE-L131211800094-1-C-1](https://de.dchousepower.com/products/5-tage-bearbeitungszeit48v-100ah-lifepo4-batterie-mit-metallgehause-bluetooth-und-niedertemperaturschutz-ladegerat-ausserhalb-de) | **€849.99**, 18 A charger included | **€1,699.98** | 504 × 268 × 233 mm / 89.8 kg |
| 2 - retained retailer alternative | [Greenboatsolutions metal pack, S-EU-L131211800094-1](https://greenboatsolutions.com/shop/battery/lithium/48v-100ah-metal-blue?v=a75f) | **€1,199.00**, charger excluded | **€2,398.00**, chargers excluded | 504 × 280 × 233 mm / 86 kg |
| 3 - different mobile-pack supplier | [Vatrer UTV/ATV 105 Ah, 51.2V-105AH-UTV-DE-1-KB](https://www.vatrerpower.de/products/vatrer-48v-105ah-utv-atv-lithium-batterie) | **€1,519.99**, 20 A charger included | **€3,039.98** | 493 × 318 × 232 mm / 91 kg |

DC HOUSE is the best-value **candidate**, not a released vehicle battery:
the nominal voltage, listed discharge capability, low-temperature charge
protection and lower-height case justify investigating it first. Its bundled
charger also removes a separate purchase. The unresolved specification
conflicts, delivery/tax basis and mower-duty evidence prevent purchase approval.
Heating is not mandatory for the owner's sheltered charging case.

### 48 V / approximately 2 kW per drive

**Inspect this pack:** [Cost table](batteries.md#0401-battery-packs-with-integrated-bms) ·
[Mounting in the pod](batteries.md#battery-to-pod-fit) ·
[Charger and connector](batteries.md#ps20-charging-and-charge-interlocks).

| Attribute | DC HOUSE 100 Ah / 18 A charger bundle |
| --- | --- |
| Planning price per bundle | **€1,028.49**; **€2,056.98 for two**, using `849.99 × 1.21` as a conditional tax-reserved cash provision, not a verified net-price conversion |
| Capacity | **51.2 V / 100 Ah / 5.12 kWh** per pack; **10.24 kWh nominal** for two |
| Voltage / current claims | Operating **40–58.4 V**, charging **58.4 V**; standard charge/discharge **50/50 A**; table claims maximum continuous **200/200 A**, integrated BMS |
| Packaging | **504 × 268 × 233 mm**, **44.9 kg** per pack; **89.8 kg** per pair, before enclosures/restraints; M8 terminals |
| Protection / support claims | Bluetooth, LCD and 5 m cable, low-temperature charge cut-off below 0°C, discharge cut-off below −20°C; advertised 3+2-year warranty; exact coverage and enclosure rating unconfirmed |
| Listing availability | Non-DE EU offer marked available, title says five-day processing; not proof of two-unit stock or accepted Romania shipment |

Evidence: [DC HOUSE exact offer, manual and charger (S30)](../../bom/sources.md#s30-dc-house-100-ah-charger-bundle).

**Equal-energy budgeting:** Planning assumption of 80% usable gives **8.192 kWh** from
two packs, before additional operational reserve, cold and aging margins. It
does not prove the preferred operating duration.

**Load plausibility, not qualification:** At 2 kW mechanical per pod, an
illustrative 85% battery-to-shaft efficiency gives approximately **46 A at
51.2 V**, or **59 A at 40 V**, before auxiliaries and transient loads. This
is below the claimed 200 A continuous discharge rating, but exceeds the
50 A standard-current example at low voltage. The controller's battery-side
current limit, low-speed/skid-steer duty, thermal derating and actual BMS
settings must be matched; motor phase current is not pack current.

**Unresolved electrical/mechanical evidence:** The table gives **280 A / 30 s
and 670 A / 0.5 s** peaks; marketing instead gives **250 A / 30 s and
700 A / 1 s**. Do not select either as an accepted transient rating. The
non-DE offer says 504 mm long, while the initial generic offer said 501 mm;
imperial dimensions also disagree. Obtain the exact supplied revision's
drawing, continuous/peak and charge/regen limits versus SOC/temperature,
BMS opening/recovery behavior, environmental/vibration evidence, transport
documentation and mower-use warranty. No battery enclosure IP rating was
established from the inspected DC HOUSE evidence.

The linked user guide is generic, not that missing exact-model datasheet.
It prohibits charging cold cells and warns that SOC can suddenly fall to zero
when its estimate drifts; establish reserve and low-voltage handling
independently of the app display. BMS recovery must not restart motion, and
neither a BMS nor regenerative braking replaces independent stopping.

**Charger budget:** One **18 A charger is included per bundle** in BAT-001;
BAT-005 is `I / N/A`, not another charger purchase. The linked charger lists
100–240 VAC input and 58.4 V output, but its **900 W** maximum-power claim
conflicts with `58.4 × 18 = 1,051.2 W`. Confirm the actual bundled model,
current-versus-voltage curve, AC demand, plug, connectors and interlocks.
Restoring an assumed 80 Ah at 18 A is **4.44 hours** before taper/balancing
and warm-up; near-empty to full is **5.56 hours** before these effects.
Two chargers at 58.4 V / 18 A and an assumed 90% efficiency would draw
**2.34 kW AC**, not a verified input rating or available household capacity.

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
With two separate 10 A chargers, the public pair reference is **€2,716**
including the displayed 19% VAT, before freight. The price is retained as
requested, but is no longer the cheapest offer in the wider comparison.

Evidence: [Seller-branded pack (S28)](../../bom/sources.md#s28-greenboatsolutions-100-ah-metal-pack).
Its 21%-VAT planning equivalent is €1,219.15 per pack plus €161.67 per
charger, or €2,761.64 for two of each, excluded from totals.
The SKU stem and seller image names containing “DC House” suggest related
hardware to S30; they do **not** establish identical cells, BMS, revisions,
dimensions or warranty. Treat this as a different seller offer, not proven
independent battery engineering.

### Vatrer 105 Ah alternatives

The **UTV/ATV 300 A BMS** pack is a candidate for its explicit mobile/off-road
application, 232 mm height and included **58.4 V / 20 A charger**. It claims
51.2 V / 105 Ah, 300 A continuous discharge, IP67, cold-charge cut-off below
0°C with recovery above 5°C, and 45.5 kg. Its **600 A peak duration conflicts:
35 s in prose versus 3 s in the table**; charge-current labels also need
clarification. Off-road marketing and UL/IP claims are not independently
verified mower qualification or permission to expose the assembly to water.

The 105 Ah pair provides **10.752 kWh nominal / 8.6016 kWh at assumed 80%
usable**, 5% more than the baseline, not a large endurance increase.
The higher current rating is not itself a reason to increase motor power.

Further priced variants from the same supplier:

| Variant | Public single / pair offer | Packaging and decision |
| --- | --- | --- |
| [Standard golf-cart 200 A BMS](https://www.vatrerpower.de/products/vatrer-48v-105ah-lifepo4-golfwagen-akku), D-51.2V-105AH-V-20A-EU | €1,499.99 each; explicit two-pack variant **€2,989.99**; 20 A charger per pack | 509 × 334 × 230 mm, 46.5 kg each; listed in stock. Only €20 cheaper per single pack than UTV, but wider/heavier; retains electrical and fit holds |
| [Mini 200 A BMS](https://www.vatrerpower.de/products/vatrer-48v-105ah-mini-lithium-batterie-200-a-bms), 51.2V-105AH-EB-DE-Z | €1,499.99 each / €2,999.98 for two; 20 A charger per pack | 335 × 310 × 255 mm, 41.08 kg each; **preorder**, despite structured `available` status. Taller body leaves only 5 mm of the historical illustrative upper clearance before all other needs |

The standard listing claims 200 A continuous discharge, 100 A continuous
charge, 400 A / 35 s peak, IP67 and cold-charge inhibition. Mini claims must
not be copied to the standard or UTV revisions. All need exact-model BMS,
regen, thermal, mounting and transport evidence.
Evidence and delivery limitations: [Vatrer German-store offers (S31)](../../bom/sources.md#s31-vatrer-105-ah-mobile-packs).

### Tax and delivery basis

**DC HOUSE:** The initially found €879.99 page defaults to “0% VAT (DE only)”;
that solar-use exemption is not a mower entitlement. Its selector links a
separate **EU/non-DE €849.99 bundle**, used here. That offer is marked taxable,
but this does not establish whether destination VAT is included. Budget
`849.99 × 1.21`, rounded half-up per unit, as an explicit **conditional
21% tax reserve**, not a claim that €849.99 is net. Remove/replace this reserve
once tax-inclusive Romanian pricing is confirmed; do not charge VAT twice.
The [shipping policy](https://de.dchousepower.com/policies/shipping-policy)
says “only DE” in one section but lists other EU destinations with extra
charges later. Romania delivery and freight remain unconfirmed.

**Greenboatsolutions:** Retain its explicit 19%-inclusive offer and compare
using `price / 1.19 × 1.21`, not the DC HOUSE tax-reserve method. Its
[shipping policy](https://greenboatsolutions.com/shipping) advertises EU
delivery but the parcel/oversize/hazardous-freight class is unconfirmed.

**Vatrer:** Use the German store, not US-only `.com` shipping assumptions.
Its [shipping policy](https://www.vatrerpower.de/policies/shipping-policy)
claims free shipping to Germany/EU countries, generally 2–9 working days
plus 1–2 processing days. Exact two-pack Romanian acceptance, stock and
destination tax still need confirmation; do not call the displayed prices
verified landed costs.

Keep freight outside pack prices. The existing freight provision is unchanged,
not proven adequate. No checkout transaction, order or supplier message was made.

### Other screened and historical options

[LiTime's 51.2 V / 100 Ah listing](https://www.litime.de/products/litime-51-2v-100ah-lifepo4-lithium-batterie)
showed **€899.99**, but its normal single-pack variant was **unavailable**.
The cheaper €756.29 0%-VAT variant was also unavailable and is not a mower
price basis. A 100 A BMS claim alone does not establish vehicle/regen or
cold-charge suitability; no included charger was established. Do not promote
this as an available bundle. Stationary rack-battery and unverified marketplace
leads are not substitutes for a documented mobile pack.

Ultimatron and ACES are removed from the active shortlist at the owner's
request. Their dated [S27](../../bom/sources.md#s27-ultimatron-ubl-48-100h-and-charger)
and [S29](../../bom/sources.md#s29-aces-al48v100hfa-bt) records remain historical;
neither supplies current prices, dimensions or recommendations.

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
is 504 × 268 × 233 mm and 44.9 kg; no complete pod fit is established.
The old CAD envelope was 522 × 269 × 217 mm and 36 kg. Its nominal 43 mm
vertical margin is reduced by the new pack's additional 16 mm height to
**27 mm arithmetic margin**, before installation, guarding or tensioner
clearance. This is a packaging hold, not proven fit in the unchanged study.
The [minimum-width calculation](../../width-and-slope-sizing.md#minimum-width-and-packaging)
checks lateral packaging; the
[battery-clearance calculation](../../width-and-slope-sizing.md#provisional-battery-clearance)
checks the illustrative track path and carrier. Neither is a released layout.

Also reconcile the [spring-tensioner sweep](../01-structure-and-running-gear/running-gear.md#spring-tensioner-concept),
restraint/load path, terminal protection, ventilation/drainage, cable clearance,
and outboard removal path. Update the mass/CG budget for the 89.8 kg pair;
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
| Pack and charger references | [DC HOUSE bundle (S30)](../../bom/sources.md#s30-dc-house-100-ah-charger-bundle) · [GBS pack (S28)](../../bom/sources.md#s28-greenboatsolutions-100-ah-metal-pack) · [Vatrer mobile packs (S31)](../../bom/sources.md#s31-vatrer-105-ah-mobile-packs) |
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
| [BAT-001 - DC HOUSE 51.2 V 100 Ah pack with BMS and 18 A charger](batteries.md#ps18-battery-packs-and-bms) (2 bundle) | €2,056.98 / C |
| **Module subtotal** | €2,056.98 |

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
| [BAT-005 - DC HOUSE bundled 18 A LiFePO4 charger](batteries.md#ps20-charging-and-charge-interlocks) (2 each) | N/A / I |
| **Module subtotal** | N/A |

<a id="cost-charge-harness"></a>

### 04.04 Charge connectors fuse holders and interlock harness

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [BAT-006 - Charge connector and protective cap](batteries.md#ps20-charging-and-charge-interlocks) (2 pair) | €40.00 / A |
| [BAT-007 - Charge fuse holder and interlock harness](batteries.md#ps20-charging-and-charge-interlocks) (2 pod set) | €50.00 / A |
| **Module subtotal** | €90.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €2,416.98 |
<!-- END GENERATED: details -->

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)
