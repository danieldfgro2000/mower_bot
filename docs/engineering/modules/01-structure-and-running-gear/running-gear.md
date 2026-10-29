# Tracks and running gear

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Follow the track around the drive drum, support rollers, idler,
and tensioner. Nominal track size and layout choices are study inputs;
matched profiles, bearings, clearances, and load ratings remain unqualified.

## Prices found: tracks, rollers and idlers

**Public prices recorded 2026-10-29, not BOM allowances.** Product names below
open the supplier listings. These are unqualified sourcing candidates;
dimensions, including drum diameter, remain flexible.

| Part / supplier | Price per purchased piece | Pair / assembly price | Price basis |
| --- | ---: | ---: | --- |
| **Track: PowerTrack 180 x 72 x 37**, sourcing preference ([buy / price](https://www.powertrack.it/en/powertrack-rubber-tracks/2001-rubber-tracks-for-miniexcavators-180x72x37-0793596791918.html)) | **EUR91.35** | **EUR169.92 for two tracks**, after 7% pair discount | Includes 22% Italian VAT; pair is EUR139.28 net |
| Track alternative: PowerTrack 200 x 72 x 36 ([buy / price](https://www.powertrack.it/en/powertrack-rubber-tracks/2023-Rubber-tracks-for-miniexcavators-200x72x36-0793596792038.html)) | **EUR138.52** | **EUR257.64 for two tracks**, after 7% pair discount | Includes 22% Italian VAT; pair is EUR211.18 net |
| **Roller wheel: Interwheel 161.535**, 160 mm PU, 20 mm bore ([buy / price](https://www.interwheel.eu/en/stainless-steel-pu-wheel-160-mm-450-kg.html)) | **EUR22.88** | **EUR45.76 per two-wheel roller** | Excludes VAT, shaft, spacers and bracket |
| **Idler wheel: Interwheel 161.540**, 200 mm PU, 20 mm bore ([buy / price](https://www.interwheel.eu/en/stainless-steel-pu-wheel-200-mm-500-kg.html)) | **EUR26.55** | **EUR53.10 per two-wheel idler** | Excludes VAT, shaft, spacers and bracket |
| Light roller price reference: Interwheel 161.420, 125 mm PU, 10 mm bore ([buy / price](https://www.interwheel.eu/en/stainless-steel-pu-wheel-125-mm-200-kg.html)) | **EUR7.73** | **EUR15.46 per two-wheel roller** | Excludes VAT and mounting parts; shared-shaft suitability unresolved |
| Excavator roller alternative: genuine Kubota, Officine Fabbri ([buy / price](https://www.officinefabbri.it/it/k0083-cingoli-rulli/2700-rullo-inferiore-superiore-originale-kubota-classic-line-k008-3-e-u10-3.html)) | **EUR71.29 net** | One complete roller, not a wheel pair | EUR86.98 including 22% Italian VAT |
| Excavator idler alternative: Astrak ID072/293/00, BaggerteileShop24 ([buy / price](https://baggerteileshop24.de/products/kubota-k008-3-leitrad-mit-halter)) | **EUR186.00 net** | One idler with bracket, not a wheel pair | VAT excluded on the recorded retailer basis |

**Bearing-wheel route, required quantities:** 20 x 160 mm wheels for eight
lower and two upper roller assemblies = **EUR457.60 net**; four x 200 mm
wheels for two idlers = **EUR106.20 net**. With the discounted 180 mm track
pair, the component subtotal is **EUR703.08 net**. Listed Interwheel shipping
to Romania is approximately **EUR71.02**, giving **EUR774.10 before VAT,
track delivery and fabrication/mounting parts**. This is not a delivered
complete-undercarriage price.

**Roller sourcing selection (owner-selected, 2026-10-29): 3D-printed
120 mm roller wheels** with a PC core, TPU 95A tread and two bought 6004-2RS
bearings each. Recommendation, not an owner decision: idlers stay bought
until their tension load is known. 20 wheels cost about **EUR182.45 net** (3DJake sale filament,
free delivery) or EUR214.45 at regular prices, excluding print time and an
enclosure. The Interwheel 160 mm wheels above (EUR457.60 for 20) are the
fallback if print time becomes a bottleneck. Printed wheels have no load
rating; measure the track guide-lug height before printing the full set. See
[S38](../../bom/sources.md#s38-3d-printed-roller-wheels-owner-proposed).

**Evidence and limitations:** [Track prices and discount](../../bom/sources.md#powertrack-track-comparison) ·
[Bearing-wheel prices, shipping and fit](../../bom/sources.md#s37-bearing-wheel-roller-and-idler-candidates) ·
[All priced excavator alternatives](../../bom/sources.md#s36-priced-kubota-k008-3-undercarriage-candidates).
Romanian checkout VAT and PowerTrack delivery remain unconfirmed.
The [generated costs below](running-gear.md#detailed-module-costs) are the
unchanged baseline allowances, not these found prices.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Rubber track](running-gear.md#ps01-rubber-tracks) | PowerTrack `180×72×37` sourcing preference; `200×72×36` remains the unchanged baseline study reference | [Found prices](running-gear.md#prices-found-tracks-rollers-and-idlers) · [Baseline allowance](running-gear.md#0101-rubber-tracks) · [Track requirements](running-gear.md#ps01-rubber-tracks) | [Drive drum engagement](running-gear.md#drive-drum-study) |
| [Drive drum / sprocket](running-gear.md#drive-drum-study) | 350 mm physical OD is a flexible study placeholder; tooth/profile match open | [Baseline sprocket/hub allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) · [Drum study](running-gear.md#drive-drum-study) | [Motor-to-track mounting](../02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Lower support rollers](running-gear.md#lower-support-rollers) | Bearing-wheel route; printed 120 mm PC/TPU wheels owner-selected, Interwheel 160 mm fallback; four assemblies per track in the study; fit and capacity unqualified | [Found prices](running-gear.md#prices-found-tracks-rollers-and-idlers) · [Roller allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) · [Roller definition](running-gear.md#lower-support-rollers) | [Axles and bearings](running-gear.md#ps03-axles-bearings-and-track-guides) |
| [Upper rollers and spring tensioner](running-gear.md#spring-tensioner-concept) | Motorcycle-fork/spring concept; no qualified fork selected | [Roller/tensioner allowances](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) · [Travel/load requirements](running-gear.md#ps02-sprockets-rollers-and-tensioners) | [Battery and carrier clearance](../../width-and-slope-sizing.md#tensioner-and-idler-interfaces) |
| Front idler | Bearing-wheel route preferred; priced excavator alternative also recorded; neither fit qualified | [Found prices](running-gear.md#prices-found-tracks-rollers-and-idlers) · [Idler allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) · [Supplier limitations](../../bom/sources.md#s37-bearing-wheel-roller-and-idler-candidates) | [Track compatibility](running-gear.md#ps01-rubber-tracks) |
| [Axles, bearings and guides](running-gear.md#ps03-axles-bearings-and-track-guides) | Sizes, fits and retained assembly open | [Support costs](running-gear.md#0103-track-axles-bearings-guides-and-scrapers) · [Required data](running-gear.md#ps03-axles-bearings-and-track-guides) | [Pod frame](frame.md#ps04-frame-stock-and-weldments) |

**Further detail:** [Release requirements](running-gear.md#specification-and-inspection-requirements) ·
[Roller and drum concepts](running-gear.md#ps02-sprockets-rollers-and-tensioners) ·
[Sourcing](running-gear.md#sourcing) ·
[Interfaces](running-gear.md#interfaces-with-other-scopes) ·
[Itemized costs](running-gear.md#detailed-module-costs)

**Related documents:** [Pod-fit CAD](../../cad/module-01-track-pod-fit.scad) ·
[Chassis BOM](../../bom/chassis-bom.md) ·
[Module 01 overview](README.md)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS01: Rubber tracks

**Cost-ledger coverage:** RUN-001:RUN-001

**Part links:** [Track-pair cost](running-gear.md#0101-rubber-tracks) ·
[Supplier dimensions and limits](../../bom/sources.md#s01-powertrack-rubber-tracks) ·
[Drive drum engagement](running-gear.md#drive-drum-study) ·
[Track-loop length](../../width-and-slope-sizing.md#pitch-loop-geometry).

**2026-10-28 owner clarification:** `200×72×36` is not a mandatory size. It
remains the existing price/study reference while the actual track and matched
undercarriage are selected against the [operating cases](../../../../plan.md#provisional-engineering-targets)
and complete-pod packaging, including the separate
[obstacle-crossing request](../../../../plan.md#raised-mower-obstacle-crossing).
The current allowance does not quote a new size or qualify that requested mode.

**Required purchasing/manufacturing definition:** Matched track MPN with
confirmed width, pitch and link count; guide-lug profile, internal width,
sprocket engagement, load/speed/duty limits,
compound, tension specification and replacement availability;
[PowerTrack tracks (S01)](../../bom/sources.md#s01-powertrack-rubber-tracks) and
[TVH undercarriages (S02)](../../bom/sources.md#s02-tvh-undercarriage-parts) remain leads

**Receiving or first-article evidence:** Identity and dimensional match to supplier
drawings; condition and batch; compatibility with the selected complete undercarriage

### PS02: Sprockets, rollers and tensioners

**Cost-ledger coverage:** RUN-002:RUN-006

**Part links:** [Hardware costs](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) ·
[Motor-to-track mounting](../02-drive-train/propulsion.md#motor-to-track-mounting).

**Concept details:** [Lower support rollers](running-gear.md#lower-support-rollers) ·
[Drive drum](running-gear.md#drive-drum-study) ·
[Spring tensioner](running-gear.md#spring-tensioner-concept) ·
[Inspection evidence](running-gear.md#sprocket-roller-and-tensioner-inspection).

**Required purchasing/manufacturing definition:** Sprocket tooth count/profile, pitch
geometry, bore/key/hub; idler and roller diameters, flanges, axle interfaces and
capacities. Owner-selected concept: spring-load the upper-return support rollers
to push outward and tension the track. Define roller count/spacing, whether they
move together or independently, contact profile and usable stroke, spring
type/rate/preload, travel stops and retention, service method, track-tension
measurement, and allowable track/bearing/frame loads. Verify the moving envelope
against the battery, carrier, guards and battery-removal path.

#### Lower support rollers

Four support rollers per track, evenly spaced along
the lower run, as selected for this study. Diameter, width, material, axle/bearing
interfaces and load capacity remain unselected; the layout is not a load or clearance
validation. See the [pod-fit sketch](../../cad/module-01-track-pod-fit.scad).

**Continue:** [Roller allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) ·
[Axle/bearing mounting](running-gear.md#ps03-axles-bearings-and-track-guides) ·
[Frame definition](frame.md#ps04-frame-stock-and-weldments).

#### Drive drum study

The track-drive drum outside diameter is unselected; 350 mm is a starting
study value, not a fixed requirement. Choose its pitch/tooth geometry to match
the selected track and set its diameter with the required reduction, torque,
speed and pod packaging.
The [HPM5000B planetary-in-drum study](../02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study)
shows one possible reduction layout only;
[PowerTrack track engagement geometry](../../bom/sources.md#s01-powertrack-rubber-tracks) and the
drum's sprocket profile remain unverified.

**Part links:** [Motor price and specifications](../02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) ·
[Motor-to-drum attachment](../02-drive-train/propulsion.md#motor-to-track-mounting) ·
[Output shaft/bearings](../02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) ·
[Baseline sprocket/hub allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners).
That allowance is not a quote for a completed custom drum and in-drum gearbox.

#### Spring tensioner concept

Fabricate the spring take-up using motorcycle fork
and spring hardware; mount each roller at the fork's normal wheel axle position
and clamp the fork to the frame. This is a concept only, not a selected or
qualified fork. Confirm the fork's available travel, spring/preload behavior,
side-load capacity, sealing, stops, retention and service method against the
track loads. The [Cohidrex idler lead](../../bom/sources.md#s26-cohidrex-idler-wheel-family) is listed for Trabber
tracks and is not confirmed to fit S01.

**Continue:** [Tensioner allowance](running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) ·
[Spring/roller clearance to the battery](../../width-and-slope-sizing.md#tensioner-and-idler-interfaces) ·
[Frame attachment requirements](frame.md#ps04-frame-stock-and-weldments).

#### Sprocket, roller and tensioner inspection

**Receiving or first-article evidence:** Matched kit contents; drawing-based
dimensional/alignment report; approved tension/retention and rolling checks under a
separately authorized plan

### PS03: Axles, bearings and track guides

**Cost-ledger coverage:** RUN-007:RUN-009

**Part links:** [Axle, bearing and guide costs](running-gear.md#0103-track-axles-bearings-guides-and-scrapers) ·
[Roller layout](running-gear.md#lower-support-rollers) ·
[Separate drive-output bearings](../02-drive-train/propulsion.md#ps16-output-shafts-and-bearings).

**Required purchasing/manufacturing definition:** Axle grades, diameters/fits, bearing
IDs, seals/lubrication, spacers and axial retention; scraper/guide clearances through
track movement; remove kit overlap

**Receiving or first-article evidence:** Material/part identity, fits and retained
assembly; no binding or prohibited track contact against reviewed limits

[↑ Back to document overview](running-gear.md#tracks-and-running-gear)


## Sourcing

Use the [common sourcing weights](../../bom/sources.md#common-sourcing-weights)
for candidate comparisons. Dimensions are flexible; matched interfaces and
adequate load capacity remain prerequisites.

| Evidence needed | Supplier lead |
| --- | --- |
| Track dimensions and matched undercarriage | [PowerTrack 200 × 72 × 36 listing (S01)](../../bom/sources.md#s01-powertrack-rubber-tracks) · [TVH undercarriage catalog (S02)](../../bom/sources.md#s02-tvh-undercarriage-parts) |
| Bearings and fabrication stock | [DOLD bearing housings (S03)](../../bom/sources.md#s03-dold-bearing-housings) · [Dedeman local stock (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) |
| Idler geometry; compatibility unresolved | [Cohidrex idler family (S26)](../../bom/sources.md#s26-cohidrex-idler-wheel-family) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](running-gear.md#tracks-and-running-gear)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Track drive and supported output shaft | [Output shafts and bearings](../02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) |
| Pod load path and mounting datums | [Frame stock and weldments](frame.md#ps04-frame-stock-and-weldments) |
| Track path, battery carrier and extraction clearance | [Track-length and pod-fit screen](../../width-and-slope-sizing.md#track-length-check) |

[↑ Back to document overview](running-gear.md#tracks-and-running-gear)

## Detailed module costs

**Cost context:** [Module 01 totals](../../cost-breakdown.md#01--structure-and-running-gear) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-tracks"></a>

### 01.01 Rubber tracks

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [RUN-001 - Rubber track 200x72x36](running-gear.md#ps01-rubber-tracks) (2 each) | €280.00 / A |
| **Module subtotal** | €280.00 |

<a id="cost-track-hardware"></a>

### 01.02 Sprockets idlers rollers and tensioners

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [RUN-002 - Track drive sprocket and hub](running-gear.md#ps02-sprockets-rollers-and-tensioners) (2 each) | €180.00 / A |
| [RUN-003 - Front idler assembly](running-gear.md#ps02-sprockets-rollers-and-tensioners) (2 each) | €150.00 / A |
| [RUN-004 - Lower support roller](running-gear.md#ps02-sprockets-rollers-and-tensioners) (8 each) | €200.00 / A |
| [RUN-005 - Upper return guide roller](running-gear.md#ps02-sprockets-rollers-and-tensioners) (2 each) | €40.00 / A |
| [RUN-006 - Track tension adjuster](running-gear.md#ps02-sprockets-rollers-and-tensioners) (2 each) | €90.00 / A |
| **Module subtotal** | €660.00 |

<a id="cost-track-support"></a>

### 01.03 Track axles bearings guides and scrapers

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [RUN-007 - Undercarriage axle stock and spacers](running-gear.md#ps03-axles-bearings-and-track-guides) (2 pod set) | €90.00 / A |
| [RUN-008 - Undercarriage sealed bearings and seals](running-gear.md#ps03-axles-bearings-and-track-guides) (12 each) | €144.00 / A |
| [RUN-009 - Track retention guides and scrapers](running-gear.md#ps03-axles-bearings-and-track-guides) (2 pod set) | €50.00 / A |
| **Module subtotal** | €284.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €1,224.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](running-gear.md#tracks-and-running-gear)
