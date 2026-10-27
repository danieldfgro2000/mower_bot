# BOM supplier source register

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Shared evidence register for supplier listings, catalogs, and
price proxies cited by the BOM. Source IDs map to the
[descriptive lookup](sources.md#source-id-lookup); link access or a published
claim is not a quote, qualification, or approval.

**Navigate:** [Source ID lookup](sources.md#source-id-lookup) ·
[Source register](sources.md#source-register) ·
[Link verification](sources.md#link-verification) |
[BOM overview](../chassis-bom.md) ·
[Cost ledger](../chassis-bom.csv) ·
[Feedback decisions](feedback.md#feedback-decisions) ·
[Build checklist](../chassis-build-requirements.md)

## Source ID lookup

The IDs are stable cross-references used by the BOM. Use the description here
to identify the evidence before opening the detailed entry.

| ID | Supplier/reference |
| --- | --- |
| [S01](sources.md#s01) | PowerTrack 200 × 72 × 36 rubber-track listing |
| [S02](sources.md#s02) | TVH undercarriage-parts catalog |
| [S03](sources.md#s03) | DOLD bearing-housings catalog |
| [S04](sources.md#s04) | DOLD mechanical-parts catalog |
| [S05](sources.md#s05) | DOLD chain-drive catalog |
| [S06](sources.md#s06) | Dedeman Romania local-sourcing catalog |
| [S07](sources.md#s07) | RS Romania electrical and tools catalog |
| [S08](sources.md#s08) | Schneider XPSUAF13AP safety-relay example |
| [S09](sources.md#s09) | Tele Radio Tiger G2 remote-control family |
| [S10](sources.md#s10) | DOLD planetary-gearbox alternatives |
| [S11](sources.md#s11) | BLDC 2 kW planetary motor listing |
| [S12](sources.md#s12) | BLDC BD100/C100 motor-controller listing |
| [S13](sources.md#s13) | Volcano VOL-BL400C72 4 kW motor listing |
| [S14](sources.md#s14) | DOLD EZ-A72500 controller price proxy |
| [S15](sources.md#s15) | DOLD HPM5000A-72 motor price proxy |
| [S16](sources.md#s16) | Elker 48 V / 100 Ah battery listing |
| [S17](sources.md#s17) | TZI 72 V / 60 Ah battery price/capacity proxy |
| [S18](sources.md#s18) | DOLD DC-CON-72V400A contactor example |
| [S19](sources.md#s19) | ATO dynamic torque-sensor example |
| [S20](sources.md#s20) | ATO torque readout/interface example |
| [S21](sources.md#s21) | ATO clamp-meter catalog |
| [S22](sources.md#s22) | ATO digital-tachometer catalog |
| [S23](sources.md#s23) | Golden Motor HPM5000B marketplace listing |
| [S24](sources.md#s24) | Golden Motor HPM5000B family specification |
| [S25](sources.md#s25) | KellyControllers.eu HPM5000B EU retail fallback |

[↑ Back to document overview](sources.md#document-overview)


## Source register

Research checked 2026-10-26. Simplified page readers hid several prices and
specifications; those were checked in public HTML/structured product data.
No supplier was contacted and no availability, delivered quotation, or component
qualification was inferred. Links described as **catalog** are sourcing leads,
not evidence for the numeric allowances. All `A` rows require an exact quote.

### S01

**Source / source type:** [PowerTrack
200×72×36](https://www.powertrack.it/en/powertrack-rubber-tracks/2023-Rubber-tracks-for-miniexcavators-200x72x36-0793596792038.html),
product

**Evidence or limitation:** HTML displays €138.52 VAT included; structured data also has
a €128.82 quantity price. A price-validity field is already past its date. Budget €140
each pending live pair/delivery quote, not the old discount.

### S02

**Source / source type:** [TVH mini-excavator undercarriage-parts
catalog](https://www.tvh.com/parts/parts-for/small-earth-moving-equipment/mini-excavators/undercarriage-parts),
sourcing lead

**Evidence or limitation:** The catalog covers rollers, idlers, sprockets,
tensioning groups and rubber tracks, but no MowerBot-compatible set, price or
interface is verified. Ask a supplier for a matched complete undercarriage kit.

### S03

**Source / source type:** [DOLD bearing
housings](https://www.dold-mechatronik.de/Gehaeuselager), catalog

**Evidence or limitation:** Bearing/block supplier lead; no selected sizes, prices, or
shaft loads.

### S04

**Source / source type:** [DOLD mechanical catalog](https://www.dold-mechatronik.de/),
catalog

**Evidence or limitation:** Shafts, bushes, couplings, standard fasteners, and mounting
hardware; allowances are not DOLD quotations.

### S05

**Source / source type:** [DOLD chain
drives](https://www.dold-mechatronik.de/Kettenantriebe), catalog

**Evidence or limitation:** Chain/sprocket sourcing lead; pitch, service factor, tooth
counts, and material need engineering selection.

### S06

**Source / source type:** [Dedeman Romania](https://www.dedeman.ro/ro), catalog

**Evidence or limitation:** Local stock/tool/consumable sourcing lead, not a cut-steel
or fabrication quote. Raw steel and labor must be itemized separately by a local
fabricator.

### S07

**Source / source type:** [RS Romania](https://ro.rs-online.com/web/), catalog

**Evidence or limitation:** Electrical, connectors, sensors, electronics, and tools
sourcing lead; specific rated items/prices not selected.

### S08

**Source / source type:** [Schneider XPSUAF13AP at
RS](https://uk.rs-online.com/web/p/safety-relays/2006133/), product example

**Evidence or limitation:** 24 V AC/DC safety relay, IP20; public page exposes no usable
price. €300 is an allowance for a reviewed safety solution, not its quote or a machine
certification.

### S09

**Source / source type:** [Tele Radio Tiger
G2](https://www.tele-radio.com/products/tiger-g2/), manufacturer

**Evidence or limitation:** Manufacturer describes certified stop functions on specified
configurations. Exact transmitter/receiver, EU frequency, motion interface, and
delivered price unselected; €1,500 is a provisional complete-system allowance.

### S10

**Source / source type:** [DOLD planetary
gearboxes](https://www.dold-mechatronik.de/Planetengetriebe), alternative catalog

**Evidence or limitation:** Obtain output load/duty data and an alternative matched
reduction quote; not an extra purchase in either cost column.

### S11

**Source / source type:** [BLDC 2 kW planetary
motor](https://www.bldc.com/2000w-planetary-gear-motor), product/options

**Evidence or limitation:** US$957.86 base; controller +US$473.06; optional 24 V brake
+US$206.44. 16:1 appears in options without a displayed surcharge. Listing summary
contradicts its longer ratio list; obtain exact configuration and PLE090 gearhead
ratings.

### S12

**Source / source type:** [BLDC BD100/C100
controller](https://www.bldc.com/24v-60v-brushless-dc-motor-controller), product

**Evidence or limitation:** US$473.06, supplier-recommended on S11, 75 A listed,
closed-loop speed; input-range/model naming and environmental limits need clarification.
Direct outdoor/high-vibration use is cautioned against.

### S13

**Source / source type:** [Volcano
VOL-BL400C72](https://www.volcanomotors.com/product/251mm-72v-4kw-hall-sensor-bldc-motor-with-controller/),
product/RFQ

**Evidence or limitation:** Genuine 4 kW listing claims an S1 continuous-duty
rating; controller optional/customized, no public price, current conflict.
The rating conditions are not established. €650 motor and €500 controller
allowances do not qualify a matched pair.

### S14

**Source / source type:** [DOLD
EZ-A72500](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-72V-Motor-EZ-A72500),
price proxy

**Evidence or limitation:** €451.98 including 19% VAT in HTML; not a confirmed
controller for S13.

### S15

**Source / source type:** [DOLD
HPM5000A-72](https://www.dold-mechatronik.de/BLDC-Motor-Brushless-DC-Motor-5kW-72V-Luftgeguehlt-HPM5000A-72),
price proxy

**Evidence or limitation:** €630.48 including 19% VAT in HTML; this is a 5 kW model, not
the selected 4 kW target or the earlier HPM5000B marketplace model.

### S16

**Source / source type:** [Elker
LFP10048LCD](https://elkersolutions.com/product/lifepo4-lithium-battery-48v-100ah/),
product

**Evidence or limitation:** €1,019.90 displayed; 51.2 V / 100 Ah / 5,120 Wh; 56.8–58.4 V
charging, listed 100 A maximum discharge, integrated BMS, IP65 claim.
Vehicle/regenerative duty and tax basis unqualified.

### S17

**Source / source type:** [TZI 72 V / 60
Ah](https://www.tzipower.de/lifepo4-akkus/72v-60ah-lithium-lifepo4-akku-pedelec-e-bike-e-bike-akkupack-roller-scooter-pv_1916_9570/),
capacity/price proxy

**Evidence or limitation:** €1,735 at conditional 0% VAT; structured description says
100 A BMS, 200 A for 3 s and included charger. No 70 Ah quote; no confirmed stock. Do
not reuse the earlier 60 A or tax-inclusive assumptions.

### S18

**Source / source type:** [DOLD
DC-CON-72V400A](https://www.dold-mechatronik.de/DC-CONTACTOR-DC-CON-72V400A),
price-class example

**Evidence or limitation:** €62.23 displayed in HTML. “72V400A” alone does not establish
coil voltage, full-charge DC breaking ability, auxiliary feedback, or safety
suitability; not the selected contactor. CSV allows €110 each for a properly reviewed
alternative.

### S19

**Source / source type:** [ATO DYN-T40 dynamic torque
sensor](https://www.ato.com/dynamic-torque-sensor), instrument example

**Evidence or limitation:** Multiple ranges including 200 Nm; torque/speed interfaces
and overload selection need confirmation. €1,500 transducer and €1,200 load-device
provisions are estimates; this page is **not a quote for a dynamometer**.

### S20

**Source / source type:** [ATO torque
readout/interface](https://www.ato.com/display-controller-for-torque-sensor), instrument
example

**Evidence or limitation:** Matching depends on transducer/output version; €250
allowance, not a verified matched instrument package.

### S21

**Source / source type:** [ATO clamp meters](https://www.ato.com/clamp-meter), catalog

**Evidence or limitation:** Select DC-capable model and suitable ranges; €100 allowance,
no exact model quoted.

### S22

**Source / source type:** [ATO digital
tachometers](https://www.ato.com/digital-tachometer), catalog

**Evidence or limitation:** Independent speed cross-check; €50 allowance, no exact model
quoted.

### S23

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
Only ALT-DRV-001 in the non-additive alternatives ledger uses this price;
neither baseline scenario is re-costed or qualified by this listing.

### S24

**Source / source type:** [Golden Motor HPM5000B family
specification](https://www.goldenmotor.com/frame-bldcmotor.htm), manufacturer

**Evidence or limitation:** Checked 2026-10-26: 48/72/96/120 V family,
3–7.5 kW, configurable 2,000–6,000 rpm, 40 Nm peak, 11 kg air-cooled /
11.35 kg water-cooled, 206 mm diameter and 126 mm length.
Family claims differ from S23's 45 Nm peak and specific speed claim.
Obtain the exact winding/cooling/shaft drawing, rated operating curve, continuous
thermal duty and permissible shaft loads. No price or machine approval here.

### S25

**Source / source type:** [KellyControllers.eu HPM5000B 5 kW / 48 V air
cooling](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses), EU retail fallback

**Evidence or limitation:** Checked 2026-10-26 in public HTML: €994.33 and
availability "Out of stock, inquire!". Page shows €28.19 shipping, not verified
for Romania; VAT basis and delivered price remain unconfirmed. The motor is
explicitly HPM5000B, not HPM5000A. Not the basis for ALT-DRV-001's lower import
reference and not evidence of immediate availability.

### U01

**Source / source type:** Owner feedback, 2026-10-26; existing inventory, not an online
purchase source

**Evidence or limitation:** Available windshield motor; owner reports 12 V, estimates
3–5 A, and confirms worm-and-wheel type. Model, current measurement, torque, speed,
duty, and non-backdrive evidence not supplied. Purchase cost N/A (already owned); not free capability
validation.

[↑ Back to document overview](sources.md#document-overview)
## Link verification

**Checked 2026-10-26:** all 25 supplier URLs below and the
[ECB exchange-rate reference](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
and [VAT reference](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/index_en.htm)
were requested, following redirects. All 27 destinations passed the
repository-owned live link test.

- [S07](sources.md#s07): the reader retrieved the RS Romania catalog.
- [S08](sources.md#s08): the reader retrieved the RS XPSUAF13AP product page.
- [S02](sources.md#s02): the reader retrieved the TVH undercarriage-parts catalog.

Successful retrieval verifies link access, not current stock, prices, exact
configuration, delivered cost, or suitability for the machine. It does not
refresh or qualify the dated product evidence below.

[↑ Back to document overview](sources.md#document-overview)
