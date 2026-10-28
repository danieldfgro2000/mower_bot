# Supplier register

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Look up evidence by component, then return directly to its price,
specifications, or fit. The entries retain dated claims and source IDs;
catalog leads, stock claims, and owner-reported inventory are not approvals.

**On this page:** [Named reference lookup](sources.md#source-id-lookup) ·
[Supplier evidence](sources.md#supplier-evidence) ·
[Owner inventory](sources.md#u01-owner-reported-windshield-motor) ·
[Link verification history](sources.md#link-verification)

**Related documents:**
[Chassis BOM](chassis-bom.md) ·
[Cost ledger](chassis-bom.csv) ·
[Feedback decisions](feedback.md#feedback-decisions) ·
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md)

## Source ID lookup

References are grouped by the part being investigated, not by the order in
which sources were recorded. IDs remain stable for the ledgers.

| Component | Evidence entries | Return to the part |
| --- | --- | --- |
| HPM5000B motor | [Marketplace price (S23)](sources.md#s23-golden-motor-hpm5000b-marketplace-price) · [Family specification (S24)](sources.md#s24-golden-motor-hpm5000b-family-specification) · [EU fallback (S25)](sources.md#s25-kellycontrollerseu-hpm5000b-fallback) | [Price/specifications](../modules/02-drive-train/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals) · [Track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| 48 V planetary motor/controller | [BLDC motor (S11)](sources.md#s11-bldc-2-kw-planetary-motor) · [BD100/C100 (S12)](sources.md#s12-bldc-bd100c100-controller) | [Costed package](../modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive) |
| Retired higher-voltage study, excluded | [Volcano (S13)](sources.md#s13-volcano-vol-bl400c72-motor) · [Controller proxy (S14)](sources.md#s14-ez-a72500-controller-price-proxy) · [Motor proxy (S15)](sources.md#s15-hpm5000a-72-motor-price-proxy) · [Battery proxy (S17)](sources.md#s17-tzi-72-v-battery-proxy) | [Retirement decision](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement) |
| Reduction hardware | [DOLD chain drives (S05)](sources.md#s05-dold-chain-drives) · [Planetary gearboxes (S10)](sources.md#s10-dold-planetary-gearbox-alternatives) | [Reduction requirements and costs](../modules/02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware) |
| Tracks, rollers and idlers | [PowerTrack (S01)](sources.md#s01-powertrack-rubber-tracks) · [TVH (S02)](sources.md#s02-tvh-undercarriage-parts) · [Cohidrex idler lead (S26)](sources.md#s26-cohidrex-idler-wheel-family) | [Running-gear parts and fit](../modules/01-structure-and-running-gear/running-gear.md#parts-at-a-glance) |
| Bearings, shafts and frame hardware | [DOLD bearings (S03)](sources.md#s03-dold-bearing-housings) · [Mechanical parts (S04)](sources.md#s04-dold-mechanical-parts) | [Drive output supports](../modules/02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) · [Frame/mounting parts](../modules/01-structure-and-running-gear/frame.md#parts-at-a-glance) |
| Battery and charger | [DC HOUSE bundle (S30)](sources.md#s30-dc-house-100-ah-charger-bundle) · [GBS metal pack (S28)](sources.md#s28-greenboatsolutions-100-ah-metal-pack) · [Vatrer (S31)](sources.md#s31-vatrer-105-ah-mobile-packs) | [Priced options](../modules/04-battery-and-charging/batteries.md#battery-alternatives) · [Pod fit](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) |
| Electrical parts and contactors | [RS catalog (S07)](sources.md#s07-rs-electrical-parts-and-tools) · [DC-CON-72V400A example (S18)](sources.md#s18-dc-con-72v400a-contactor-example) | [Power parts](../modules/05-power-cables-and-electronics/power-distribution.md#parts-at-a-glance) · [Connectors](../modules/05-power-cables-and-electronics/cables-connectors.md#parts-at-a-glance) |
| Independent stopping | [Schneider relay example (S08)](sources.md#s08-schneider-xpsuaf13ap-safety-relay-example) · [Retired industrial-remote option (S09)](sources.md#s09-tele-radio-tiger-g2-remote-alternative) | [Current stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Workshop instruments | [Clamp-meter catalog (S21)](sources.md#s21-ato-clamp-meter-catalog) | [Tools, prices and intended use](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) |
| Historical measurement options, excluded | [Torque sensor (S19)](sources.md#s19-ato-dynamic-torque-sensor-excluded-option) · [Torque readout (S20)](sources.md#s20-ato-torque-readout-excluded-option) · [Tachometer (S22)](sources.md#s22-ato-handheld-tachometer-excluded-option) | [Current calculation/logging method](../modules/07-workshop-and-support/workshop.md#test-method-and-evidence) |
| Fabrication supplies and reused inventory | [Dedeman supplies (S06)](sources.md#s06-dedeman-fabrication-supplies) · [Wiper motor (U01)](sources.md#u01-owner-reported-windshield-motor) · [Workshop inventory (U02)](sources.md#u02-owner-reported-workshop-inventory) | [Width-drive motor](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor) · [Workshop buy/reuse choices](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance) |

[↑ Back to document overview](sources.md#supplier-register)


<a id="source-register"></a>

## Supplier evidence

Research checked 2026-10-26. Simplified page readers hid several prices and
specifications; those were checked in public HTML/structured product data.
No supplier was contacted and no availability, delivered quotation, or component
qualification was inferred. Links described as **catalog** are sourcing leads,
not evidence for the numeric allowances. All `A` rows require an exact quote.

<a id="s01"></a>

### S01: PowerTrack rubber tracks

**Source / source type:** [PowerTrack
200×72×36](https://www.powertrack.it/en/powertrack-rubber-tracks/2023-Rubber-tracks-for-miniexcavators-200x72x36-0793596792038.html),
product

**Evidence or limitation:** The product title and structured data identify the
listing as `200×72×36` / SKU `200X72X36`, but the page does not define those
dimensions or provide a dimensional drawing/table. Interpreting this as
200 mm width × 72 mm pitch × 36 links gives a **calculated nominal pitch-line
length of 2,592 mm**; this is not a verified physical loop length or track
profile. Rechecked 2026-10-27 in the public HTML/structured data. The page
displays €138.52 VAT included; structured data also has a €128.82 quantity
price. A price-validity field is already past its date. Budget €140 each
pending a live pair/delivery quote, not the old discount.

**Engineering detail:** [Rubber-track requirements](../modules/01-structure-and-running-gear/running-gear.md#ps01-rubber-tracks) ·
[Track-length screen](../width-and-slope-sizing.md#track-length-check).

<a id="s02"></a>

### S02: TVH undercarriage parts

**Source / source type:** [TVH mini-excavator undercarriage-parts
catalog](https://www.tvh.com/parts/parts-for/small-earth-moving-equipment/mini-excavators/undercarriage-parts),
sourcing lead

**Evidence or limitation:** The catalog covers rollers, idlers, sprockets,
tensioning groups and rubber tracks, but no MowerBot-compatible set, price or
interface is verified. Ask a supplier for a matched undercarriage component.

**Engineering detail:** [Sprockets, rollers and tensioners](../modules/01-structure-and-running-gear/running-gear.md#ps02-sprockets-rollers-and-tensioners).

<a id="s03"></a>

### S03: DOLD bearing housings

**Source / source type:** [DOLD bearing
housings](https://www.dold-mechatronik.de/Gehaeuselager), catalog

**Evidence or limitation:** Bearing/block supplier lead; no selected sizes, prices, or
shaft loads.

**Engineering detail:** [Track axles and bearings](../modules/01-structure-and-running-gear/running-gear.md#ps03-axles-bearings-and-track-guides) ·
[Drive output bearings](../modules/02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) ·
[Width screw supports](../modules/03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports).

<a id="s04"></a>

### S04: DOLD mechanical parts

**Source / source type:** [DOLD mechanical catalog](https://www.dold-mechatronik.de/),
catalog

**Evidence or limitation:** Shafts, bushes, couplings, standard fasteners, and mounting
hardware; allowances are not DOLD quotations.

**Engineering detail:** [Frame and pivots](../modules/01-structure-and-running-gear/frame.md#specification-and-inspection-requirements) ·
[Width screw and supports](../modules/03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) ·
[Battery restraints](../modules/04-battery-and-charging/batteries.md#ps19-battery-enclosures-and-restraints) ·
[Bench fixture](../modules/07-workshop-and-support/workshop.md#ps34-bench-fixture-and-controls).

<a id="s05"></a>

### S05: DOLD chain drives

**Source / source type:** [DOLD chain
drives](https://www.dold-mechatronik.de/Kettenantriebe), catalog

**Evidence or limitation:** Chain/sprocket sourcing lead; pitch, service factor, tooth
counts, and material need engineering selection.

**Engineering detail:** [Reduction and transmission hardware](../modules/02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware).

<a id="s06"></a>

### S06: Dedeman fabrication supplies

**Source / source type:** [Dedeman Romania](https://www.dedeman.ro/ro), catalog

**Evidence or limitation:** Local stock/tool/consumable sourcing lead, not a cut-steel
or fabrication quote. Raw steel and labor must be itemized separately by a local
fabricator.

**Engineering detail:** [Frame stock and weldments](../modules/01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) ·
[Fabrication consumables](../modules/07-workshop-and-support/workshop.md#ps37-fabrication-consumables).

<a id="s07"></a>

### S07: RS electrical parts and tools

**Source / source type:** [RS Romania](https://ro.rs-online.com/web/), catalog

**Evidence or limitation:** Electrical, connectors, sensors, electronics, and tools
sourcing lead; specific rated items/prices not selected.

**Engineering detail:** [Harnesses](../modules/05-power-cables-and-electronics/cables-connectors.md) ·
[Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md) ·
[Safety controls and sensors](../modules/06-safety-controls-and-sensors/safety-controls.md) ·
[Workshop tools](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools).

<a id="s08"></a>

### S08: Schneider XPSUAF13AP safety-relay example

**Source / source type:** [Schneider XPSUAF13AP at
RS](https://uk.rs-online.com/web/p/safety-relays/2006133/), product example

**Evidence or limitation:** 24 V AC/DC safety relay, IP20; public page exposes no usable
price. €300 is an allowance for a reviewed safety solution, not its quote or a machine
certification.

**Engineering detail:** [Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

<a id="s09"></a>

### S09: Tele Radio Tiger G2 remote alternative

**Source / source type:** [Tele Radio Tiger
G2](https://www.tele-radio.com/products/tiger-g2/), manufacturer

**Evidence or limitation:** Manufacturer describes certified stop functions on specified
configurations. Exact transmitter/receiver, EU frequency, motion interface, and
delivered price were unselected. The owner has since specified a mobile app for normal
control and removed this industrial-remote allowance from the current baseline. This
family remains a considered alternative, not a selected or qualified safety system.

**Current scope:** [Mobile-app control decision](feedback.md#f10-workshop-equipment-test-method-and-mobile-app-control) ·
[Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

<a id="s10"></a>

### S10: DOLD planetary-gearbox alternatives

**Source / source type:** [DOLD planetary
gearboxes](https://www.dold-mechatronik.de/Planetengetriebe), alternative catalog

**Evidence or limitation:** Obtain output load/duty data and an alternative matched
reduction quote; not an extra purchase in either cost column.

**Engineering detail:** [Reduction qualification](../modules/02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware).

<a id="s11"></a>

### S11: BLDC 2 kW planetary motor

**Source / source type:** [BLDC 2 kW planetary
motor](https://www.bldc.com/2000w-planetary-gear-motor), product/options

**Evidence or limitation:** US$957.86 base; controller +US$473.06; optional 24 V brake
+US$206.44. 16:1 appears in options without a displayed surcharge. Listing summary
contradicts its longer ratio list; obtain exact configuration and PLE090 gearhead
ratings.

**Engineering detail:** [48 V package price and specifications](../modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive) ·
[Motor-to-track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting).

<a id="s12"></a>

### S12: BLDC BD100/C100 controller

**Source / source type:** [BLDC BD100/C100
controller](https://www.bldc.com/24v-60v-brushless-dc-motor-controller), product

**Evidence or limitation:** US$473.06, supplier-recommended for the
[BLDC planetary motor](sources.md#s11-bldc-2-kw-planetary-motor), 75 A listed,
closed-loop speed; input-range/model naming and environmental limits need clarification.
Direct outdoor/high-vibration use is cautioned against.

**Engineering detail:** [Drive compatibility and duty limitations](../modules/02-drive-train/propulsion.md#compatibility-and-duty-limitations).

<a id="s13"></a>

### S13: Volcano VOL-BL400C72 motor

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [Volcano
VOL-BL400C72](https://www.volcanomotors.com/product/251mm-72v-4kw-hall-sensor-bldc-motor-with-controller/),
product/RFQ

**Evidence or limitation:** Genuine 4 kW listing claims an S1 continuous-duty
rating; controller optional/customized, no public price, current conflict.
The rating conditions are not established. €650 motor and €500 controller
allowances do not qualify a matched pair.

**Decision history:** [Scenario retirement](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s14"></a>

### S14: EZ-A72500 controller price proxy

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [DOLD
EZ-A72500](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-72V-Motor-EZ-A72500),
price proxy

**Evidence or limitation:** €451.98 including 19% VAT in HTML; not a confirmed
controller for the [Volcano VOL-BL400C72](sources.md#s13-volcano-vol-bl400c72-motor).

**Decision history:** [Scenario retirement](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s15"></a>

### S15: HPM5000A-72 motor price proxy

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [DOLD
HPM5000A-72](https://www.dold-mechatronik.de/BLDC-Motor-Brushless-DC-Motor-5kW-72V-Luftgeguehlt-HPM5000A-72),
price proxy

**Evidence or limitation:** €630.48 including 19% VAT in HTML; this is a 5 kW model, not
the 4 kW estimating scenario or the HPM5000B marketplace model.

**Decision history:** [Scenario retirement](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement) ·
[Distinct HPM5000B alternative](../modules/02-drive-train/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals).

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

**Engineering detail:** [Historical Elker study](../modules/04-battery-and-charging/batteries.md#historical-elker-study-reference) ·
[Battery-to-pod fit](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit).

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

**Decision history:** [Scenario retirement](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s18"></a>

### S18: DC-CON-72V400A contactor example

**Source / source type:** [DOLD
DC-CON-72V400A](https://www.dold-mechatronik.de/DC-CONTACTOR-DC-CON-72V400A),
price-class example

**Evidence or limitation:** €62.23 displayed in HTML. “72V400A” alone does not establish
coil voltage, full-charge DC breaking ability, auxiliary feedback, or safety
suitability; not the selected contactor. CSV allows €110 each for a properly reviewed
alternative.

**Engineering detail:** [Main fuses, disconnects and contactors](../modules/05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors).

<a id="s19"></a>

### S19: ATO dynamic torque sensor, excluded option

**Source / source type:** [ATO DYN-T40 dynamic torque
sensor](https://www.ato.com/dynamic-torque-sensor), instrument example

**Evidence or limitation:** Multiple ranges including 200 Nm; torque/speed interfaces
and overload selection need confirmation. The owner has excluded the dynamometer
package from the current baseline; this page remains historical research and is **not a
quote for a dynamometer**.

**Current scope:** [Calculated torque, not measured capability](../modules/07-workshop-and-support/workshop.md#ps35-calculated-torque-and-test-evidence).

<a id="s20"></a>

### S20: ATO torque readout, excluded option

**Source / source type:** [ATO torque
readout/interface](https://www.ato.com/display-controller-for-torque-sensor), instrument
example

**Evidence or limitation:** Matching depends on transducer/output version. The
readout/interface is not in the current baseline because direct torque measurement was
not selected.

**Current scope:** [Calculation and logged-observation method](../modules/07-workshop-and-support/workshop.md#test-method-and-evidence).

<a id="s21"></a>

### S21: ATO clamp-meter catalog

**Source / source type:** [ATO clamp meters](https://www.ato.com/clamp-meter), catalog

**Evidence or limitation:** Select DC-capable model and suitable ranges; €100 allowance,
no exact model quoted.

**Engineering detail:** [Workshop tools and instrument requirements](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools).

<a id="s22"></a>

### S22: ATO handheld tachometer, excluded option

**Source / source type:** [ATO digital
tachometers](https://www.ato.com/digital-tachometer), catalog

**Evidence or limitation:** Previously considered as an independent speed cross-check;
the owner selected installed speed sensing and logging instead. No handheld tachometer
is in the current baseline.

**Current scope:** [Installed speed sensing and logging](../modules/06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging).

<a id="s23"></a>

### S23: Golden Motor HPM5000B marketplace price

**Source / source type:** [Golden Motor Technology HPM5000B 48 V / 4,000 rpm
marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html),
manufacturer storefront / public price reference

**Evidence or limitation:** Checked 2026-10-26 in public HTML: US$446 per piece
at 1–9 pieces, US$340 at 10–49 and US$310 at 50+. The chassis needs two, so
use US$446. Title identifies HPM5000B 48 V / 4,000 rpm; table claims 5 kW rated,
7.5 kW peak, 13 Nm rated, 45 Nm peak and VEC300 controller. Winding/cooling/shaft
options and included scope need an exact quote; controller is not presumed
included. Existing FX and provisional 21% VAT yield €482.36 per bare motor,
excluding delivery, duty, brokerage and taxes on those charges.
Only [HPM5000B alternative ALT-DRV-001](propulsion-alternatives.csv) uses this price;
neither baseline scenario is re-costed or qualified by this listing.

**Continue with HPM5000B:** [Planning price](../modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications and conflicts](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor-to-track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting).

<a id="s24"></a>

### S24: Golden Motor HPM5000B family specification

**Source / source type:** [Golden Motor HPM5000B family
specification](https://www.goldenmotor.com/frame-bldcmotor.htm), manufacturer

**Evidence or limitation:** Rechecked 2026-10-27: 48/72/96/120 V family,
3–7.5 kW, configurable 2,000–6,000 rpm, 40 Nm peak, 11 kg air-cooled /
11.35 kg water-cooled, 206 mm diameter and 126 mm length.
Family claims differ from the
[marketplace's 45 Nm peak and speed claim](sources.md#s23-golden-motor-hpm5000b-marketplace-price).
Obtain the exact winding/cooling/shaft drawing, rated operating curve, continuous
thermal duty and permissible shaft loads. The dimensions are the published
motor envelope only; this source does not specify a planetary reducer. No price
or machine approval here.

**Continue with HPM5000B:** [Specification comparison](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor/drum mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) ·
[Gearbox study](../modules/02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study).

<a id="s25"></a>

### S25: KellyControllers.eu HPM5000B fallback

**Source / source type:** [KellyControllers.eu HPM5000B 5 kW / 48 V air
cooling](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses), EU retail fallback

**Evidence or limitation:** Checked 2026-10-26 in public HTML: €994.33 and
availability "Out of stock, inquire!". Page shows €28.19 shipping, not verified
for Romania; VAT basis and delivered price remain unconfirmed. The motor is
explicitly HPM5000B, not HPM5000A. Not the basis for ALT-DRV-001's lower import
reference and not evidence of immediate availability.

**Continue with HPM5000B:** [Ratings and sourcing limits](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor/drum mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting).

<a id="s26"></a>

### S26: Cohidrex idler-wheel family

**Source / source type:** [Cohidrex Trasteel Track idler wheels for mini
excavators](https://cohidrex.com/en/idler-wheel-for-mini-excavator), product family

**Evidence or limitation:** The supplier describes application-specific idlers
for its Trabber rubber tracks and major compact-machine brands. The public page
does not identify a model, dimensions, bearing/axle interface, price, or fit for
the PowerTrack `200×72×36` listing. This is an idler design/supplier lead only;
checked 2026-10-27. Request a dimensioned drawing and compatibility confirmation
before selection.

**Engineering detail:** [Roller and tensioner concept](../modules/01-structure-and-running-gear/running-gear.md#ps02-sprockets-rollers-and-tensioners) ·
[Pod-fit limits](../width-and-slope-sizing.md#track-length-check).

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

**Decision history:** [Original selection (F12)](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement) ·
[Replacement (F13)](feedback.md#f13-value-battery-shortlist-and-bundled-chargers).

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

**Engineering detail:** [Retained retailer alternative](../modules/04-battery-and-charging/batteries.md#lower-cost-alternative-greenboatsolutions-metal-pack).

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

**Decision history:** [Replacement shortlist (F13)](feedback.md#f13-value-battery-shortlist-and-bundled-chargers).

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

**Engineering detail:** [Conditional first choice and load screen](../modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive) ·
[Fit hold](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit).

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

**Engineering detail:** [Vatrer comparison and energy](../modules/04-battery-and-charging/batteries.md#vatrer-105-ah-alternatives).

<a id="u01"></a>

### U01: Owner-reported windshield motor

**Source / source type:** Owner feedback, 2026-10-26; existing inventory, not an online
purchase source

**Evidence or limitation:** Available windshield motor; owner reports 12 V, estimates
3–5 A, and confirms worm-and-wheel type. Model, current measurement, torque, speed,
duty, and non-backdrive evidence not supplied. Purchase cost N/A (already owned); not free capability
validation.

**Engineering detail:** [Reused wiper-motor qualification](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor).

<a id="u02"></a>

### U02: Owner-reported workshop inventory

**Source / source type:** Owner feedback, 2026-10-27; existing inventory and
fabrication access, not an online purchase source

**Evidence or limitation:** Owner reports two transport straps described as 500 kg,
two machine service supports, a torque wrench, insulated hand tools, crimp tooling,
thread-locking/sealant/grease stock, cleaning/inspection supplies, welding PPE, safety
glasses, safety footwear, and general lathe/mill access. Ratings, capacities, condition,
calibration, exact products, die compatibility, and suitability for released work are
not verified. The owner reports a 20–160 A Daewoo MOSFET welding machine and
flux-coated electrodes; stick/MMA is a likely process identification, pending exact
model/manual confirmation. Welding is planned outdoors. Owner prefers standard
off-the-shelf gears where possible and retains the machining allowance for work that
cannot be made in-house. These statements support reused-cost treatment only; they do
not qualify equipment, fabrication, lifting, or testing.

**Engineering detail:** [Workshop requirement map](../modules/07-workshop-and-support/workshop.md#specification-and-inspection-requirements) ·
[Dated workshop decision](feedback.md#f10-workshop-equipment-test-method-and-mobile-app-control).

[↑ Back to document overview](sources.md#supplier-register)

## Link verification

**Historical check, 2026-10-26:** the 25 supplier URLs then recorded, the
[ECB exchange-rate reference](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
and [VAT reference](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/index_en.htm)
were requested, following redirects. All 27 destinations passed the
repository-owned live link test.

- [RS Romania (S07)](sources.md#s07-rs-electrical-parts-and-tools): the reader retrieved the catalog.
- [Schneider XPSUAF13AP (S08)](sources.md#s08-schneider-xpsuaf13ap-safety-relay-example): the reader retrieved the RS product page.
- [TVH undercarriage parts (S02)](sources.md#s02-tvh-undercarriage-parts): the reader retrieved the catalog.

Successful retrieval verifies link access, not current stock, prices, exact
configuration, delivered cost, or suitability for the machine. It does not
refresh or qualify the dated product evidence above. The later
[Cohidrex idler entry](sources.md#s26-cohidrex-idler-wheel-family) records its own research date.

[↑ Back to document overview](sources.md#supplier-register)
