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
[Itemized costs](batteries.md#detailed-module-costs) ·
[Procurement and holds](batteries.md#procurement-and-release-holds) ·
[Decision records](batteries.md#decision-records) ·
[Supplier evidence](batteries.md#supplier-evidence)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

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

Evidence: [DC HOUSE exact offer, manual and charger (S30)](batteries.md#s30-dc-house-100-ah-charger-bundle).

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

Evidence: [Seller-branded pack (S28)](batteries.md#s28-greenboatsolutions-100-ah-metal-pack).
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
Evidence and delivery limitations: [Vatrer German-store offers (S31)](batteries.md#s31-vatrer-105-ah-mobile-packs).

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
request. Their dated [S27](batteries.md#s27-ultimatron-ubl-48-100h-and-charger)
and [S29](batteries.md#s29-aces-al48v100hfa-bt) records remain historical;
neither supplies current prices, dimensions or recommendations.

### Historical Elker study reference

The former [Elker LFP10048LCD (S16)](batteries.md#s16-elker-lfp10048lcd-battery)
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
[battery-clearance calculation](batteries.md#provisional-battery-clearance)
checks the illustrative track path and carrier. Neither is a released layout.

Also reconcile the [spring-tensioner sweep](../01-structure-and-running-gear/running-gear.md#spring-tensioner-concept),
restraint/load path, terminal protection, ventilation/drainage, cable clearance,
and outboard removal path. Update the mass/CG budget for the 89.8 kg pair;
the former 72 kg pair is not the current configuration. Do not silently
substitute new battery dimensions into the old CAD or infer a usable width.

**Continue:** [Enclosure/retention costs](batteries.md#0402-battery-enclosures-restraints-and-insulation) ·
[Pod frame](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) ·
[Power terminals and harness](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness).

#### Provisional battery clearance

For the **historical Elker envelope**, with the model's assumed 20 mm belt,
80 mm frame gap, and 10 mm carrier, only
**43 mm** remains above the 217 mm pack before installation or service
clearance. The assumed 2,592 mm pitch loop leaves about **193 mm total** along
the straight run around a centered 522 mm pack. Both margins depend on the
unverified track-code interpretation and placeholder geometry; neither proves
fit. The current DC HOUSE pack is 16 mm taller, leaving **27 mm nominal
arithmetic vertical margin**, not qualified installation or tensioner clearance.
Its listed body is 18 mm shorter and 1 mm narrower, but heavier. Check the
complete carrier, track return and tensioner envelope before claiming fit.
The CAD has not been changed and the old 72 kg pair is not the current
89.8 kg battery mass.

**Continue with the part:** [Battery-to-pod fit](batteries.md#battery-to-pod-fit) ·
[Spring tensioner](../01-structure-and-running-gear/running-gear.md#spring-tensioner-concept) ·
[Frame definition](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments).


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
| Pack and charger references | [DC HOUSE bundle (S30)](batteries.md#s30-dc-house-100-ah-charger-bundle) · [GBS pack (S28)](batteries.md#s28-greenboatsolutions-100-ah-metal-pack) · [Vatrer mobile packs (S31)](batteries.md#s31-vatrer-105-ah-mobile-packs) |
| Containment, restraints and wiring | [DOLD mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) · [Dedeman fabrication supplies (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) · [RS electrical parts (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)


## Procurement and release holds

Prepared supplier requests and release holds owned by this scope. Sending a request needs separate user approval; every hold is **OPEN**. Shared document control, manufacturing packs and cross-cutting holds stay in the [Chassis Build and Procurement Checklist](../../chassis-build-requirements.md#chassis-build-and-procurement-checklist).

### Q03: battery/charging alternatives

**Requirements:** [Packs, BMS, enclosures and charging](batteries.md#specification-and-inspection-requirements).
**Leads:** [DC HOUSE bundle (S30)](batteries.md#s30-dc-house-100-ah-charger-bundle) ·
[GBS metal pack (S28)](batteries.md#s28-greenboatsolutions-100-ah-metal-pack) ·
[Vatrer mobile packs (S31)](batteries.md#s31-vatrer-105-ah-mobile-packs).

**Specific response needed:** Pack drawing/mass, cell/series/BMS details,
vehicle/regen/current limits, charger and shipment documentation; price matched
battery-only and charger-bundled offers separately. Confirm two 51.2 V /
approximately 100 Ah packs (105 Ah accepted), exact revision/drawing,
continuous/peak and regen ratings, cold-charge inhibition/recovery,
Romania freight/tax and enclosure/IP claims. Resolve the DC HOUSE peak,
dimensions and charger-power conflicts before selection; its bundled charger
must not be bought twice. A maximum-current number or heating feature is not
qualification.

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


## Decision records

Dated owner decisions and qualification loops for this scope. Read each date with its later corrections; a decision closes an estimating assumption, not a component qualification. Cross-module decisions remain in [BOM feedback](../../bom/feedback.md#feedback-decisions).

### F12: 48 V battery baseline and scenario retirement

**Decision recorded on 2026-10-28:** Use two 48 V-class / 51.2 V, 100 Ah
LiFePO4 packs, one per pod; assess current capability separately from capacity.
Prioritize European-stocked mobile/traction packs and consider worthwhile
direct imports. Document three publicly priced options and use the recommended
option as the budget reference. Remove the 72 V scenario from all active BOM
and cost-comparison tables; this does not change the retained 48 V drive scenario.

**Historical budget recommendation, superseded by F13:** [Ultimatron UBL-48-100H](batteries.md#s27-ultimatron-ubl-48-100h-and-charger),
with the separately listed 10 A charger, replaces the former Elker reference.
The other two [priced packs](batteries.md#battery-alternatives)
are non-additive alternatives. This is a recommended estimating baseline,
not a purchased or mower-qualified assembly. Pack fit, current/regen, cold
charging and supplier-rating conflicts remain HOLD.

**Historical effect on estimate:** Retire the 72 V CSV columns and its five external-drive
lines DRV-007–011, which had no 48 V purchase cost. Preserve all other 48 V
costs before the battery update. The new pack/charger references add €990.28
to materials: €13,879.10 total and €17,710.92 including the existing provisions
and contingency. Freight remains a provision, not a confirmed delivery price.

### F13: value battery shortlist and bundled chargers

**Decision recorded on 2026-10-28:** Retain only the €1,199 Greenboatsolutions
offer from the previous shortlist and research other suppliers. Capacity is
approximately 100 Ah, with modest upward variation such as 105 Ah accepted.
The owner initially approved GBS as the provisional budget reference, then
preferred DC HOUSE's charger bundle as first option if suitable while
continuing research.

**Conditional recommendation:** [DC HOUSE's non-DE EU €849.99 bundle](batteries.md#s30-dc-house-100-ah-charger-bundle)
passes a voltage/load/envelope candidate screen, not vehicle qualification.
Use it first and as the estimating reference; preserve GBS and add Vatrer's
priced 105 Ah mobile variants. LiTime's inspected 100 Ah offer is unavailable.
Ultimatron/ACES remain only dated source history, not active recommendations.
The GBS/DC HOUSE SKU relationship does not prove independent pack designs.

**Effect on estimate:** BAT-001 includes an 18 A charger and BMS per pack.
Apply the disclosed conditional 21% tax reserve to €849.99: **€1,028.49
per bundle / €2,056.98 for two**. Destination VAT inclusion is unresolved;
replace the reserve once confirmed, without double taxation. BAT-005 becomes
included (`I / N/A`), avoiding a duplicate charger purchase. Other component
costs and the retired 72 V status are unchanged. Materials decrease by
**€1,721.46 to €12,157.64**; battery/charging costs become **€2,416.98**;
the indicative budget with unchanged provisions and 20% contingency becomes
**€15,645.17**.

**Open holds:** Exact revision and dimensions, contradictory peak/charger
ratings, regen/BMS behavior, cell-temperature protection, environmental and
vibration evidence, 89.8 kg pair mass/CG and full pod fit, household charger
capacity, Romania shipment/tax and warranty. No hardware, purchasing or
supplier-contact authorization is implied.

### L3: energy and battery

**Inputs needed / next feedback:** Required usable capacity versus job-energy
measurements; reserve, cold/aging provision, module size/mass and vehicle-duty evidence

**What changes:** Confirm chemistry, exact full-charge/cutoff voltages,
capacity/current, BMS behavior, chargers, and realistic quote

**Closure evidence:** Compatible pack/controller/charger documentation, shipping quote,
and later measured usable energy; no online claim alone closes this

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)


## Supplier evidence

Dated supplier claims for this scope, recorded under the [common sourcing weights](../../bom/sources.md#common-sourcing-weights). Catalog listings are leads, not quotes or qualification. Source IDs stay stable for the [cost ledger](../../bom/chassis-bom.csv).

<a id="s16"></a>

### S16: Elker LFP10048LCD battery

**Status:** Former budget/packaging reference, superseded first by S27 and now
by S30. The recorded
price below is historical, not reverified for this shortlist.

**Source / source type:** [Elker
LFP10048LCD](https://elkersolutions.com/product/lifepo4-lithium-battery-48v-100ah/),
product

**Evidence or limitation:** €1,019.90 displayed; 51.2 V / 100 Ah / 5,120 Wh; 56.8–58.4 V
charging, listed 100 A maximum discharge, integrated BMS, IP65 claim.
Vehicle/regenerative duty and tax basis unqualified.

**Engineering detail:** [Historical Elker study](batteries.md#historical-elker-study-reference) ·
[Battery-to-pod fit](batteries.md#battery-to-pod-fit).

<a id="s17"></a>

### S17: TZI 72 V battery proxy

**Status:** Historical source only; its extrapolated 70 Ah allowance is retired
from the active BOM, not preserved as a current battery alternative.

**Source / source type:** [TZI 72 V / 60
Ah](https://www.tzipower.de/lifepo4-akkus/72v-60ah-lithium-lifepo4-akku-pedelec-e-bike-e-bike-akkupack-roller-scooter-pv_1916_9570/),
capacity/price proxy

**Evidence or limitation:** €1,735 at conditional 0% VAT; structured description says
100 A BMS, 200 A for 3 s and included charger. No 70 Ah quote; no confirmed stock. Do
not reuse the earlier 60 A or tax-inclusive assumptions.

**Decision history:** [Scenario retirement](batteries.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s27"></a>

### S27: Ultimatron UBL-48-100H and charger

**Status:** Historical, removed from the active shortlist; S30 supersedes its
pack/charger budget. The dated evidence below is retained for traceability.

**Checked:** 2026-10-28. **Source / source type:** [Greenboatsolutions product
page](https://greenboatsolutions.com/shop/battery/lithium/ultimatron-lithium-battery-48-v-100-ah-with-bluetooth),
retailer listing and structured Product/Offer data.

**Price evidence:** SKU UBL-48-100H, €1,699 including 19% VAT per pack; two
packs €3,398 before shipping. The configurator separately lists a 48 V / 10 A
LiFePO4 charger at €159 including 19% VAT; it is not included in the pack price.
The 21%-VAT cash-budget references are €1,727.55 per pack and €161.67 per
charger, calculated as `displayed price / 1.19 × 1.21`, not destination quotes.

**Technical claims:** 51.2 V / 100 Ah / 5.12 kWh, 420 × 320 × 260 mm, 49.2 kg;
integrated BMS, Bluetooth, heating and a five-year warranty. The table says
200 A maximum discharge, 50 A maximum charge and IP64; generic prose mentions
150 A and IP65. Continuous/peak duration, regen, exact charge profile,
cold-charge control, vibration and mower-duty warranty are unqualified.
Do not treat broad fire/touch-safety marketing as engineering evidence.

**Supply limits:** Listed available with 3-5 days dispatch, not confirmed
two-unit stock or Romania delivery. The [shipping policy](https://greenboatsolutions.com/shipping)
advertises EU shipment with different parcel/oversize/hazardous-freight rates;
exact class, freight charge and destination tax require confirmation.

**Decision history:** [Original selection (F12)](batteries.md#f12-48-v-battery-baseline-and-scenario-retirement) ·
[Replacement (F13)](batteries.md#f13-value-battery-shortlist-and-bundled-chargers).

<a id="s28"></a>

### S28: Greenboatsolutions 100 Ah metal pack

**Checked:** 2026-10-28. **Source / source type:** [Exact 100 Ah product
variant](https://greenboatsolutions.com/shop/battery/lithium/48v-100ah-metal-blue?v=a75f),
retailer listing and structured Product/Offer data.

**Price evidence:** Seller SKU S-EU-L131211800094-1, €1,199 including 19% VAT;
two €2,398 before shipping. A 10 A charger is separately €159. The pack's
21%-VAT planning equivalent is €1,219.15; this alternative is not in totals.

**Technical claims / gaps:** 51.2 V / 100 Ah / 5.12 kWh, 504 × 280 × 233 mm,
43 kg, BMS, Bluetooth, IP65, no heater and a three-year warranty. The table
states 200 A maximum discharge but only 5.12 kW maximum power, an unresolved
conflict; maximum charge is 50 A. The seller requires dry/protected mounting
without direct rain/water and warns about inverter connection. OEM identity,
continuous/peak duty, cold-charge inhibition and regen remain unverified.
Listed available/immediate dispatch is not a two-unit Romania delivery quote.

**Offer relationship:** The SKU stem matches the DC HOUSE family and product
image URLs contain “48V 100Ah DC House Metall”. This suggests related hardware,
not confirmed OEM/revision equivalence. Do not copy S30 ratings to this pack;
published dimensions, mass and warranty differ.

**Engineering detail:** [Retained retailer alternative](batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack).

<a id="s29"></a>

### S29: ACES AL48V100HFA-BT

**Status:** Historical, removed from the active shortlist; not a current
recommendation or cost input.

**Checked:** 2026-10-28. **Source / source type:** [Exact ACES product
variant](https://greenboatsolutions.com/shop/battery/lithium/ACES-48V-100Ah-lithium-battery?v=6796),
retailer listing and structured Product/Offer data.

**Price evidence:** €2,899 including 19% VAT per pack; two €5,798 before shipping.
The ACES 48 V / 10 A charger is separately €279, not bundled. The pack's
21%-VAT planning equivalent is €2,947.72; this alternative is not in totals.

**Technical claims / gaps:** 51.2 V / 100 Ah / 5.12 kWh, 522 × 267 × 218 mm,
39 kg, integrated BMS, Bluetooth, IP65, no heater, five-year warranty.
Maximum discharge/charge are listed as 200/100 A, without verified continuous,
peak-duration or regen definitions. The seller prohibits charging below 0°C;
automatic inhibition still needs evidence. Listed available but 3-4 weeks
dispatch, not immediate warehouse stock or a confirmed Romania quote.

**Decision history:** [Replacement shortlist (F13)](batteries.md#f13-value-battery-shortlist-and-bundled-chargers).

<a id="s30"></a>

### S30: DC HOUSE 100 Ah charger bundle

**Checked:** 2026-10-28. **Source / source type:** Manufacturer storefront,
public product HTML, linked option matrix and structured product data.
The [EU/non-DE bundle](https://de.dchousepower.com/products/5-tage-bearbeitungszeit48v-100ah-lifepo4-batterie-mit-metallgehause-bluetooth-und-niedertemperaturschutz-ladegerat-ausserhalb-de)
is SKU **S-DE-L131211800094-1-C-1**, **€849.99**, marked available, five-day
processing in the title. Includes one 18 A charger, LCD and 5 m cable;
battery and charger may ship separately. Two bundles are **€1,699.98** before
unconfirmed destination tax/freight, not a pair discount.

**Tax distinction:** The [initial €879.99 listing](https://de.dchousepower.com/products/48v-100ah-lithium-batterie-mit-metallgehause-ladegerat)
defaults to the German 0%-VAT option; its public selector links the non-DE
offer above. The separate [German taxed bundle](https://de.dchousepower.com/products/5-tage-bearbeitungszeit-inkl-mwst-48v-100ah-lifepo4-batterie-mit-metallgehause-bluetooth-und-niedertemperaturschutz-ladegerat-inkl-mwst)
also shows €879.99 but has a different SKU, S-DE-L131211800130-1-C-1.
Do not infer identical revisions or Romanian taxation from those pages.
The non-DE offer is marked `taxable: true`, which does not establish net
versus gross price. BAT-001 uses `849.99 × 1.21 = €1,028.49` per bundle
as a **conditional tax-reserved provision**, not a confirmed net-price
conversion. Replace that reserve with actual destination treatment; never
add VAT again to an already tax-inclusive price. No solar tax exemption is assumed.

**Technical claims / conflicts:** 51.2 V / 100 Ah / 5.12 kWh, operating
40–58.4 V, charge 58.4 V, standard charge/discharge 50/50 A and claimed
maximum continuous 200/200 A. Table peaks 280 A / 30 s and 670 A / 0.5 s
conflict with marketing's 250 A / 30 s and 700 A / 1 s. The exact non-DE
table says 504 × 268 × 233 mm and 44.9 kg, versus 501 mm length on the
initial page; imperial equivalents also disagree. M8 terminals, metal case,
Bluetooth, cold-charge inhibition below 0°C and discharge inhibition below
−20°C are claimed. No battery IP rating or exact-model regen behavior was
established. Listed 3+2-year warranty is not confirmed mower-duty coverage.

**Manual and charger:** The linked
[battery user guide](https://cdn.shopify.com/s/files/1/0690/2621/8213/files/DC_HOUSE_Golf_Cart_Battery_User_Guide_1.pdf?v=1792575243)
is generic. It prohibits cold-cell charging and warns about SOC-estimate
drift/sudden zero indication; it does not resolve exact-model ratings, IP,
vibration or regen. The [18 A charger listing](https://de.dchousepower.com/products/48v-18a-ac-zu-dc-lifepo4-tragbares-batterieladegerat)
states 100–240 VAC, 58.4 V / 18 A, IP65 and 900 W maximum power; the output
product is 1,051.2 W, an unresolved inconsistency. Its IP claim is not the
battery's rating. BAT-005 is included in BAT-001, not a second purchase.

**Supply hold:** The [shipping policy](https://de.dchousepower.com/policies/shipping-policy)
says “only DE” but later lists DE/FR/ES/IT and other EU destinations with
extra charges. Product-page EU shipping claims do not resolve this conflict.
Two-unit availability, Romania delivery, freight, tax, supplied revision and
return/warranty arrangements require confirmation.

**Engineering detail:** [Conditional first choice and load screen](batteries.md#48-v--approximately-2-kw-per-drive) ·
[Fit hold](batteries.md#battery-to-pod-fit).

<a id="s31"></a>

### S31: Vatrer 105 Ah mobile packs

**Checked:** 2026-10-28. **Source / source type:** German manufacturer storefront
HTML and public structured product variants; not the US-store shipping policy.

| Exact offer | Displayed price / contents | Published body / current claims |
| --- | --- | --- |
| [UTV/ATV](https://www.vatrerpower.de/products/vatrer-48v-105ah-utv-atv-lithium-batterie), 51.2V-105AH-UTV-DE-1-KB | €1,519.99 each / €3,039.98 for two; 58.4 V / 20 A charger and monitor included; marked available | 493 × 318 × 232 mm, 45.5 kg, 300 A continuous discharge; 600 A peak is 35 s in prose but 3 s in table |
| [Standard golf-cart](https://www.vatrerpower.de/products/vatrer-48v-105ah-lifepo4-golfwagen-akku), D-51.2V-105AH-V-20A-EU | €1,499.99 single; explicit two-pack variant €2,989.99; 58.4 V / 20 A charger per pack; listed in stock | 509 × 334 × 230 mm, 46.5 kg, 200 A continuous discharge / 100 A continuous charge, 400 A / 35 s peak |
| [Mini golf-cart](https://www.vatrerpower.de/products/vatrer-48v-105ah-mini-lithium-batterie-200-a-bms), 51.2V-105AH-EB-DE-Z | €1,499.99 single; €2,999.98 for two; 58.4 V / 20 A charger included; title says **preorder**, despite structured availability | 335 × 310 × 255 mm, 41.08 kg, 200 A continuous discharge, 400 A / 35 s table peak |

All list 51.2 V / 105 Ah / 5.376 kWh, 58.4 V charge and 40 V discharge
cut-off, IP67 and low-temperature charge protection. UTV/mini tables label
300/200 A maximum charging and 55 A continuous charging; these require
exact-model clarification, not transfer to regen acceptance. Cold-charge
prose says cut-off below 0°C / recovery above 5°C; UTV/mini tables also give
a ±4°C cut-off tolerance. Establish safe cell-temperature control rather
than treating that tolerance as permission for subzero charging.
UL/IP, vibration and mower-use warranty claims remain unverified.

**Price/delivery limits:** Prices are EUR and product variants marked taxable,
but destination VAT inclusion/rate is not established by that flag. The
[German-store shipping policy](https://www.vatrerpower.de/policies/shipping-policy)
claims free shipping to Germany/EU, generally 2–9 working days plus 1–2
processing days. Confirm two-pack Romanian acceptance, stock, tax and
transport documents; no delivered quote or purchase was obtained.

**Engineering detail:** [Vatrer comparison and energy](batteries.md#vatrer-105-ah-alternatives).

[↑ Back to document overview](batteries.md#batteries-enclosures-and-charging)
