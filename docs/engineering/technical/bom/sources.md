# Supplier register

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Project-wide sourcing policy and an index of every source ID.
Single-module supplier evidence lives at the end of its
[module page](../modules/README.md#module-directory), next to that part's
prices, specifications and fit. Only multi-module catalogs (S04, S06, S07)
remain here. Catalog leads, stock claims and owner-reported inventory are
not approvals.

**On this page:** [Common sourcing weights](sources.md#common-sourcing-weights) ·
[Where each source ID lives](sources.md#source-id-lookup) ·
[Shared catalog sources](sources.md#supplier-evidence) ·
[Link verification history](sources.md#link-verification)

**Related documents:**
[Chassis BOM](chassis-bom.md) ·
[Cost ledger](chassis-bom.csv) ·
[Feedback decisions](feedback.md#feedback-decisions) ·
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md)

## Common sourcing weights

**Owner-approved policy, 2026-10-29:** Apply these weights to sourcing
comparisons for all project parts, not just running gear. The weights total
2.1; normalization preserves their relative importance.

| Criterion | Weight | Normalized share | Higher scores mean |
| --- | ---: | ---: | --- |
| Low price | 0.6 | 28.57% | Lower delivered cost for the required quantity, including VAT, shipping, import charges and required extras |
| Quality | 0.5 | 23.81% | Better documented durability, suitable materials/seals/bearings where applicable, warranty and credible manufacturer evidence |
| Availability | 0.7 | 33.33% | Verified stock, shorter delivery time and dependable replacement supply |
| Parts in Europe | 0.3 | 14.29% | Verified European dispatch stock, accessible regional support and spares |

Score each criterion from 0 to 10, higher being better:

`overall = (0.6 * price + 0.5 * quality + 0.7 * availability + 0.3 * Europe) / 2.1`

Availability therefore ranks ahead of price, quality and European stock.
Record dated evidence and the reason for each score; agree concrete scoring
thresholds before assigning numerical rankings. Unknown evidence remains
**unverified**, not an assumed positive score or a complete overall ranking.
Compare equivalent quantities and included contents. Confirm delivery
destination before claiming comparable delivered prices.

European stock means dispatch location, not merely a European website or
manufacturer origin. Distinguish EU from non-EU dispatch; account for import
charges in delivered price rather than assuming Europe is customs-free.

**Eligibility, owner decision 2026-10-29:** Only offers with a publicly
listed numeric price are scored. `Quote required`, `Enquiry`, zero-price or
contact-for-price listings are excluded; the project will not request quotes
from multiple suppliers. Excluded leads stay documented as context only.

Compatibility and adequate load capacity are prerequisites, not weighted
trade-offs. Candidates with missing interface or capacity evidence may remain
research leads but are not qualified selections. Dimensions are flexible
sourcing references, including the existing `200 x 72 x 36` track and 350 mm
drive-drum studies; neither is a hard choice. Select drum diameter and
engagement geometry against the chosen track pitch, reduction and packaging.
Confirm the complete track/sprocket/idler/roller match rather than rejecting
alternatives solely for differing nominal dimensions. See
[running-gear requirements](../modules/01-structure-and-running-gear/running-gear.md#specification-and-inspection-requirements).
This policy changes no baseline quantities, prices, configuration or release holds.


## Source ID lookup

References are grouped by the part being investigated, not by the order in
which sources were recorded. IDs remain stable for the ledgers; each entry
link opens the owning module page.

| Component | Evidence entries | Return to the part |
| --- | --- | --- |
| HPM5000B motor | [Marketplace price (S23)](../modules/02-drive-train/propulsion.md#s23-golden-motor-hpm5000b-marketplace-price) · [Family specification (S24)](../modules/02-drive-train/propulsion.md#s24-golden-motor-hpm5000b-family-specification) · [EU fallback (S25)](../modules/02-drive-train/propulsion.md#s25-kellycontrollerseu-hpm5000b-fallback) | [Price/specifications](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) · [Track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| Selected controller and brake references | [EZ-A48500 (S32)](../modules/02-drive-train/propulsion.md#s32-golden-motor-ez-a48500-controller) · [FDB 13 C (S33)](../modules/02-drive-train/propulsion.md#s33-precima-fdb-13-c-holding-brake) | [Controller comparison](../modules/02-drive-train/propulsion.md#ez-a48500-controller-candidate) · [Brake fitment](../modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment) |
| Former 48 V planetary motor/controller | [BLDC motor (S11)](../modules/02-drive-train/propulsion.md#s11-bldc-2-kw-planetary-motor) · [BD100/C100 (S12)](../modules/02-drive-train/propulsion.md#s12-bldc-bd100c100-controller) | [Non-additive package comparison](../modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive) |
| Retired higher-voltage study, excluded | [Volcano (S13)](../modules/02-drive-train/propulsion.md#s13-volcano-vol-bl400c72-motor) · [Controller proxy (S14)](../modules/02-drive-train/propulsion.md#s14-ez-a72500-controller-price-proxy) · [Motor proxy (S15)](../modules/02-drive-train/propulsion.md#s15-hpm5000a-72-motor-price-proxy) · [Battery proxy (S17)](../modules/04-battery-and-charging/batteries.md#s17-tzi-72-v-battery-proxy) | [Retirement decision](../modules/04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement) |
| Reduction hardware | [DOLD chain drives (S05)](../modules/02-drive-train/propulsion.md#s05-dold-chain-drives) · [Planetary gearboxes (S10)](../modules/02-drive-train/propulsion.md#s10-dold-planetary-gearbox-alternatives) | [Reduction requirements and costs](../modules/02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware) |
| Tracks, rollers and idlers | [PowerTrack (S01)](../modules/01-structure-and-running-gear/running-gear.md#s01-powertrack-rubber-tracks) · [TVH (S02)](../modules/01-structure-and-running-gear/running-gear.md#s02-tvh-undercarriage-parts) · [Cohidrex idler lead (S26)](../modules/01-structure-and-running-gear/running-gear.md#s26-cohidrex-idler-wheel-family) · [Priced K008-3 candidates (S36)](../modules/01-structure-and-running-gear/running-gear.md#s36-priced-kubota-k008-3-undercarriage-candidates) · [Bearing-wheel candidates (S37)](../modules/01-structure-and-running-gear/running-gear.md#s37-bearing-wheel-roller-and-idler-candidates) · [3D-printed roller wheels (S38)](../modules/01-structure-and-running-gear/running-gear.md#s38-3d-printed-roller-wheels-owner-proposed) | [Running-gear parts and fit](../modules/01-structure-and-running-gear/running-gear.md#parts-at-a-glance) |
| Bearings, shafts and frame hardware | [DOLD bearings (S03)](../modules/01-structure-and-running-gear/running-gear.md#s03-dold-bearing-housings) · [Mechanical parts (S04)](sources.md#s04-dold-mechanical-parts) | [Drive output supports](../modules/02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) · [Frame/mounting parts](../modules/01-structure-and-running-gear/frame.md#parts-at-a-glance) |
| Battery and charger | [DC HOUSE bundle (S30)](../modules/04-battery-and-charging/batteries.md#s30-dc-house-100-ah-charger-bundle) · [GBS metal pack (S28)](../modules/04-battery-and-charging/batteries.md#s28-greenboatsolutions-100-ah-metal-pack) · [Vatrer (S31)](../modules/04-battery-and-charging/batteries.md#s31-vatrer-105-ah-mobile-packs) | [Priced options](../modules/04-battery-and-charging/batteries.md#battery-alternatives) · [Pod fit](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) |
| Electrical parts and contactors | [RS catalog (S07)](sources.md#s07-rs-electrical-parts-and-tools) · [DC-CON-72V400A example (S18)](../modules/05-power-cables-and-electronics/power-distribution.md#s18-dc-con-72v400a-contactor-example) | [Power parts](../modules/05-power-cables-and-electronics/power-distribution.md#parts-at-a-glance) · [Connectors](../modules/05-power-cables-and-electronics/cables-connectors.md#parts-at-a-glance) |
| Independent stopping | [Schneider relay example (S08)](../modules/06-safety-controls-and-sensors/safety-controls.md#s08-schneider-xpsuaf13ap-safety-relay-example) · [Retired industrial-remote option (S09)](../modules/06-safety-controls-and-sensors/safety-controls.md#s09-tele-radio-tiger-g2-remote-alternative) | [Current stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Workshop instruments | [Clamp-meter catalog (S21)](../modules/07-workshop-and-support/workshop.md#s21-ato-clamp-meter-catalog) | [Tools, prices and intended use](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) |
| Historical measurement options, excluded | [Torque sensor (S19)](../modules/07-workshop-and-support/workshop.md#s19-ato-dynamic-torque-sensor-excluded-option) · [Torque readout (S20)](../modules/07-workshop-and-support/workshop.md#s20-ato-torque-readout-excluded-option) · [Tachometer (S22)](../modules/07-workshop-and-support/workshop.md#s22-ato-handheld-tachometer-excluded-option) | [Current calculation/logging method](../modules/07-workshop-and-support/workshop.md#test-method-and-evidence) |
| Fabrication supplies and reused inventory | [Dedeman supplies (S06)](sources.md#s06-dedeman-fabrication-supplies) · [Wiper motor (U01)](../modules/03-width-adjustment/width-adjustment.md#u01-owner-reported-windshield-motor) · [Workshop inventory (U02)](../modules/07-workshop-and-support/workshop.md#u02-owner-reported-workshop-inventory) | [Width-drive motor](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor) · [Workshop buy/reuse choices](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance) |

[↑ Back to document overview](sources.md#supplier-register)


<a id="source-register"></a>

## Supplier evidence

These catalogs serve several modules, so they stay here instead of being
copied into each module page. Research checked 2026-10-26. Simplified page readers hid several prices and
specifications; those were checked in public HTML/structured product data.
No supplier was contacted and no availability, delivered quotation, or component
qualification was inferred. Links described as **catalog** are sourcing leads,
not evidence for the numeric allowances. All `A` rows require an exact quote.


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


[↑ Back to document overview](sources.md#supplier-register)

## Link verification

**Historical check, 2026-10-26:** the 25 supplier URLs then recorded, the
[ECB exchange-rate reference](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
and [VAT reference](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/index_en.htm)
were requested, following redirects. All 27 destinations passed the
repository-owned live link test.

- [RS Romania (S07)](sources.md#s07-rs-electrical-parts-and-tools): the reader retrieved the catalog.
- [Schneider XPSUAF13AP (S08)](../modules/06-safety-controls-and-sensors/safety-controls.md#s08-schneider-xpsuaf13ap-safety-relay-example): the reader retrieved the RS product page.
- [TVH undercarriage parts (S02)](../modules/01-structure-and-running-gear/running-gear.md#s02-tvh-undercarriage-parts): the reader retrieved the catalog.

Successful retrieval verifies link access, not current stock, prices, exact
configuration, delivered cost, or suitability for the machine. It does not
refresh or qualify the dated product evidence above. The later
[Cohidrex idler entry](../modules/01-structure-and-running-gear/running-gear.md#s26-cohidrex-idler-wheel-family) records its own research date.

[↑ Back to document overview](sources.md#supplier-register)
