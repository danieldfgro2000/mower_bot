# MowerBot — Concept, Business and Build Plan

**Revision:** 1.0 — 14 October 2026  
**Project area:** Băișoara / Făget, Romania  
**Status:** concept baseline for engineering validation and pilot-business planning

**Operating-case update:** 28 October 2026

> This document is a working plan, not a certified machine design or a supplier purchase order. Values marked **validated** are decisions or constraints already established in the project context. Values marked **provisional** are engineering targets or market observations that must be confirmed by measurement, supplier documentation, or field trials.

## 1. Executive summary

MowerBot is a compact, remotely supervised, battery-electric tracked platform intended to provide mowing-as-a-service for rough grass, orchards, slopes and difficult-access plots around Băișoara and Făget.

The first machine should be built as two independent, self-contained tracked pods joined by a variable-width scissor frame. Each pod contains its own track, traction motor, reduction, controller, battery module and local safety/diagnostic wiring. A longitudinal implement spine carries the mower and other tools. This makes the machine easier to transport, repair and reconfigure than a monolithic chassis.

The initial commercial service is deliberately conservative:

- charge approximately **300–500 RON per 2,000–3,000 m²**;
- mow at approximately **4 km/h** with the DAC 9100 underbody mower;
- model utilization around realistic local demand, weather and transport constraints rather than assuming daily full-time operation;
- begin with supervised remote operation and repeat customers, then add RTK Teach & Repeat for repeatable routes;
- treat safety, serviceability and reliability as more important than maximum speed.

The machine is not designed around an obsolete four-column cage. That architecture is explicitly excluded from this plan.

## 2. Decision status and evidence convention

### Validated project decisions

These are the current project decisions to carry forward:

- Local business focus: mowing service around Băișoara / Făget.
- Two independent tracked pods, each self-contained.
- Variable-width scissor frame between the pods.
- Longitudinal implement spine for mower and attachments.
- Commercial rubber tracks; **200 × 72 × 36 is a provisional sourcing/study
  reference, not a mandatory size** (owner clarification, 2026-10-28).
- Underbody DAC 9100 mower as the first cutting implement.
- Washable conveyor as a planned attachment.
- Passive trailer as a planned attachment.
- Front fruit drum as a planned attachment.
- RTK Teach & Repeat as the autonomy direction.
- Independent safety system separate from normal motion control.
- Motor shortlist and pricing are supplier-market observations, not acceptance tests.

### Provisional engineering targets

The following numbers are useful for sizing but are not yet validated on the completed machine:

- normal operating mass: approximately **300 kg**;
- maximum loaded combination: approximately **450 kg**, budgeted as **300 kg
  bot with fitted equipment + 150 kg fully loaded trailer**, including all
  payloads; not 450 kg carried on the tracks;
- mowing speed: approximately **4 km/h in normal conditions**; reduced speed
  on slopes is accepted where required by qualified machine limits;
- V1 maximum self-propelled travel target: **4 km/h**, prioritizing the
  low-speed drive; this replaces the earlier 8 km/h general-travel and
  15–20 km/h transport aspirations (owner decision, 2026-10-28);
- two motors, each approximately **2 kW continuous**, **3–4 kW short peak**;
- earlier output estimate: approximately **70–80 Nm continuous per track**,
  at least **120 Nm short peak**; recalculate against the current slope,
  obstacle and turning cases rather than treating these as accepted ratings;
- track-output rpm: derive from confirmed pitch geometry and the requested
  ground speeds, not an independent working/transport rpm target;
- battery sizing direction: **two 48 V-class / 51.2 V, approximately 100 Ah
  LiFePO4 packs**, one per independent pod; modestly higher capacity such as
  105 Ah is acceptable. The 100 Ah baseline gives **10.24 kWh nominal / 8.192 kWh at the assumed
  80% usable fraction**, before additional reserves. Ah is capacity, not a
  required discharge-current rating;
- electrical autonomy: **eight hours without battery swaps is a preferred
  target**, with shorter runtime acceptable to control battery mass and cost
  (owner decision, 2026-10-28); capability remains to be proven by logged field
  energy use. See the [runtime study](plan.md#eight-hour-runtime-and-charging-study).

The earlier 140–280 rpm working and 500–700 rpm transport figures are
historical study inputs, not V1 requirements. For a provisional screen only,
temporarily treating a 350 mm physical drum outside diameter as the effective
rolling diameter gives about **60.6 track rpm at 4 km/h** and **15.2 track rpm
at 1 km/h**. The 350 mm value is not a required drum size; actual track
pitch-line diameter is unknown. Select drum diameter and engagement geometry
with the track, then reconcile output torque, speed and duty before choosing a
reduction. These figures do not release a gearing or operating limit.

The 2026-10-26 BOM feedback adds an aspirational **400 mm minimum / 1,600 mm
maximum outside-track width** and sites with inclines up to **40°**.
The owner confirms this site target includes both uphill/downhill and
cross-slope travel, and accepts speed reduction below 4 km/h on slopes.
**2026-10-27 load clarification:** the 450 kg maximum-loaded case is limited to
slopes of 15° or less; 40° is for the mower-only configuration. Use the
provisional 300 kg normal-mass estimate for mower-only screening until the
configuration mass is measured.
**2026-10-28 mass clarification:** The 450 kg case is the combined bot, trailer
and their payloads, with a study allocation of 300 kg bot plus 150 kg loaded
trailer. See the [trailer load case](plan.md#73-passive-trailer). Hitch load
redistributes support between the bot and trailer; it is not additional mass.
These are packaging/feasibility inputs, **not validated machine dimensions or
operating limits**. See the [width and slope screen](docs/engineering/technical/width-and-slope-sizing.md)
for clearance, CG, traction, torque, and track-length limitations.

### Operating environment and cleaning

**2026-10-28 owner requirements for the first mowing configuration:**

| Condition | Requested operating case |
| --- | --- |
| Ambient temperature while working | **+5°C to +35°C**; component internal-temperature limits still require qualification |
| Rain | Continue working in **light rain**, but stop work in **heavy rain**; no numeric rainfall threshold or ingress rating is established |
| Cleaning | **Restricted pressure-washer cleaning** of suitable mechanical surfaces, with electrical equipment, seals and bearings protected from direct jets |

These are design requirements, not demonstrated environmental capabilities.
Define permitted cleaning surfaces, pressure/nozzle/standoff/water-temperature
limits and a safe isolation procedure from the selected components' ratings.
Neither light-rain tolerance nor a generic washdown claim establishes
pressure-washer resistance. The [charging environment](plan.md#charging-environment)
is a separate case.

### Not yet validated

- Exact mass, centre of gravity and width range.
- Track load rating, track life and sprocket compatibility.
- DAC 9100 power demand, cutting width, mounting loads and performance in wet/rough grass.
- Motor continuous torque claims and thermal performance.
- Gearbox service factor and output shaft/bearing life.
- Battery chemistry, usable capacity, enclosure rating and winter performance.
- RTK availability under local tree cover and terrain.
- Legal classification, insurance, road transport requirements and operating permissions.
- Actual customer willingness to pay at the proposed rates.

## 3. Service business around Băișoara / Făget

### Customer problem

The target customer has grass, orchard, pasture-edge or uneven land that is expensive, slow or unsafe to mow with a conventional tractor. The machine should be valuable where access is narrow, slopes are uncomfortable, terrain is rough, or the owner would rather buy a finished result than own and maintain equipment.

Likely early customers include:

- small farms and hay/orchard owners;
- guesthouses, rural properties and tourism businesses;
- municipalities or village-level maintenance contracts;
- landowners with overgrown plots;
- orchards where a low, narrow machine is useful between rows;
- customers needing repeated seasonal maintenance rather than one-off clearing.

### Initial pricing hypothesis

| Service unit | Working price hypothesis | Meaning |
|---|---:|---|
| 2,000 m² job | 300–500 RON | Small minimum charge; protects travel/setup time |
| 3,000 m² job | 300–500 RON | Target package for a normal local visit |
| Larger or difficult plot | Quote separately | Add slope, obstacles, distance, wet grass and cleanup factors |
| Repeat route/season contract | Discounted per-visit rate | Improves utilization and reduces selling cost |

These are **commercial assumptions**, not validated market prices. Before committing to the machine, interview or pre-sell to local customers and record:

1. plot area and terrain;
2. current mowing method and cost;
3. acceptable visit window;
4. grass height/wetness and obstacle density;
5. distance from the transport base;
6. willingness to pay for a finished, supervised service.

### Conservative utilization model

The financial model should not assume that the mower works eight billable hours every day. A useful first model separates:

- **available days:** weather, grass growth and customer demand;
- **productive hours:** actual cutting time;
- **non-productive time:** loading, travel, setup, charging, cleaning, repairs and customer coordination;
- **effective area/hour:** reduced by turning, obstacles, overlaps, slopes and interruptions;
- **billable revenue:** price collected after discounts and cancellations.

Use at least three cases:

| Case | Productive utilization | Planning purpose |
|---|---:|---|
| Conservative | 1–2 billable jobs/week | Tests whether ownership costs are survivable |
| Base | 3–5 billable jobs/week in season | Main pilot case |
| Upside | Route contracts and repeat customers | Expansion case only after reliability is proven |

Operating costs to include:

- electricity and charging losses;
- transport vehicle, trailer and fuel;
- operator time and travel time;
- blades, belts, bearings, track and sprocket wear;
- cleaning and corrosion prevention;
- battery reserve/replacement allowance;
- insurance, permits and accounting;
- repairs and downtime;
- customer acquisition and quoting time.

The go/no-go threshold is not simply revenue per mowing hour. It is positive contribution after transport, operator time, consumables and a realistic maintenance reserve.

## 4. Machine architecture

### 4.1 Two independent tracked pods

Each pod is a complete drive module:

- commercial rubber track with size and matched running gear to be selected;
- drive sprocket and idlers;
- traction motor and reduction;
- motor controller;
- battery module and contactor/fuse;
- local current, temperature and speed sensing;
- mechanical mounting points to the central frame;
- service disconnect and protected cable routing.

This arrangement supports differential/skid steering, allows a failed pod to be serviced separately, and keeps high-current wiring short. It also creates important design work: track tension, side-load management, frame torsion, synchronised braking and safe behaviour if one pod loses communication.

**2026-10-29 pod-fit direction:** use a spring-loaded sliding front idler and
fixed upper return roller, superseding the spring-upper concept. The
[running-gear study](docs/engineering/technical/modules/01-structure-and-running-gear/running-gear.md#tensioner-and-idler-interfaces)
and [connected tray frame](docs/engineering/technical/modules/01-structure-and-running-gear/frame.md#connected-pod-frame-proposal)
represent U supports, motor reaction plate and spring/carriage geometry.
Their loads, spring specification, joints and complete-machine fit remain
unqualified; no purchasing or fabrication decision follows from the model.

### 4.2 Variable-width scissor frame

The scissor frame should allow the pod spacing to change for:

- narrow orchard or gate access;
- wider stability on open ground;
- transport and loading;
- alignment with crop rows or the implement width.

The mechanism needs positive mechanical locking at each operating width. Hydraulic or electric adjustment is optional; a manually set and pinned first prototype is acceptable if it is quick and safe to configure.

**2026-10-26 design direction:** the operator will enter a target width and
adjustment is intended to occur while the chassis rolls at a calculated,
validated speed to reduce track scrubbing. The available actuator is an
owner-identified 12 V windshield motor with worm-and-wheel reduction and an
estimated 3–5 A running current, driving a screw/nut mechanism. Screw turns are
intended to be counted with Hall/optical feedback and converted to width from
the linkage geometry. Motor output speed/torque, stall current, duty, screw
lead/load rating, reference recovery, and the motion envelope remain unverified.
Rolling is not evidence that lateral track loads are acceptable.

The proposed reliance on worm reduction alone for holding is **not yet an
accepted replacement for the positive-locking requirement** above. Gear type
identification does not establish non-backdrivability under the machine's loads,
wear, vibration, lubrication, or loss of power. Resolve holding/stopping and
fault behavior through engineering review before releasing this mechanism.
Hard travel stops, travel limits, guarding, independent stopping, and explicit
restart/reference recovery remain required. No adjustment speed or hardware
operation is approved by this design direction. The
[costed BOM](docs/engineering/technical/bom/chassis-bom.md) records the prototype allowances
and qualification gaps.

The current width study targets are an aspirational 400 mm minimum and
1,600 mm maximum measured outside the tracks. The minimum must increase if
required by complete pod/spine/scissor packaging; overall body width may exceed
outside-track width. The suggested width/length ratio is not a stability rule.
The owner's expected 40° site inclines require separate lateral, longitudinal,
traction, braking, and adjustment-envelope assessment; no such slope is approved.

**2026-10-28 access requirement:** There is no fixed gate or passage width to
meet. Minimize complete-machine width where practical, subject to packaging,
service access and qualified stability. The 400 mm outside-track aspiration
is not a mandatory real-world opening or a released body dimension.
There is **no fixed overall height limit**; prioritize low height and a low
centre of gravity without assuming an approved CG threshold.
Transport between sites is intended **assembled on a trailer or suitable
vehicle platform**, with a usable deck **2 m long × 1 m wide**. Define the
narrowed transport configuration against that envelope, including the fitted
mower, guards and restraint clearances. Platform payload rating, ramp geometry
and tie-down arrangements remain unqualified; this transport platform is
separate from the bot's 150 kg loaded work-trailer case.

Design requirements:

- no pinch access during normal adjustment;
- hard stops for minimum and maximum width;
- positive locks that do not rely on motor holding torque;
- torsional stiffness sufficient to keep the mower deck stable;
- guards around moving scissor links;
- clear width markings and a pre-start lock check.

### 4.3 Longitudinal implement spine

The spine is the main load path for tools. It should provide:

- a repeatable datum for attachment alignment;
- front, centre and rear mounting zones;
- quick but secure attachment pins;
- protected power and signal connectors;
- lift/float provisions for the mower;
- a tow point for the passive trailer;
- a washdown-friendly surface with drain paths.

The four-column cage concept is **not part of the design**. It should not appear in fabrication drawings, BOMs or future procurement requests.

## 5. Propulsion system

### 5.1 Duty requirement

The machine prioritizes low-speed continuous torque over high road speed. A preliminary sizing model used approximately 300 kg normal mass, 450 kg loaded mass, rough-terrain rolling resistance, 85% drivetrain efficiency and a margin. It indicates that two 2 kW-class motors are a reasonable starting point for normal mowing and moderate slopes, provided the reduction is correctly selected.
The [2026-10-28 combined-load definition](plan.md#73-passive-trailer) now
separates the 300 kg bot from its 150 kg loaded trailer. Do not treat the
earlier 450 kg loaded-mass figure as weight entirely supported by the tracks.

The important constraint is power:

> High torque and high speed cannot both be sustained from a 2 kW motor. For example, 80 Nm at 500 rpm is about 4.2 kW mechanical before losses.

The owner now prioritizes the low-speed drive with a **4 km/h maximum V1
self-propelled travel target**. Select gearing from the requested ground-speed
and load cases, including the 1 km/h steep-section studies below, rather than
retaining the earlier independent output-rpm targets. These are desired
performance points, not qualified operating speeds.

**2026-10-26 slope clarification:** 4 km/h is a normal-condition target, not a
requirement at the owner's aspirational 40° site incline. Speed may be reduced,
but no safe slope/speed envelope has been established. The
[slope screen](docs/engineering/technical/width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates)
shows that gravity alone can require more than the provisional 70–80 Nm per
track. Revisit output torque, reduction, and working rpm against actual
sprocket radius and load before selecting either BOM scenario. Lower speed
reduces climbing power, not the torque required to resist gravity; it does not
resolve sliding, tipping, parking hold, or loss-of-energy downhill braking.

**2026-10-28 requested slope duty:** For the steepest mower-only terrain
(the 40° site target), the owner's minimum useful travel speed is **1 km/h**.
This is a performance target for sizing, not a qualified safe slope or speed.
The longest expected uninterrupted uphill stretch near that slope is **up to
25 m along the ground**, approximately **90 seconds at 1 km/h**, not 25 m of
vertical rise. These steep sections are **occasional, separated by gentler
mowing**, rather than repeated back-to-back steep passes. The recovery interval
and gentler-work load are unquantified; do not assume full cooling between
climbs. The requested steep-slope case must also cover **wet grass on firm
soil**, not dry conditions alone. This is a feasibility requirement, not proof
of wet-grass traction or an approved operating envelope; slipping may prevent
the requested duty even when torque and static stability calculations pass.
Required slope maneuvering is **gradual moving turns, without stationary pivot
turns**. Minimum turning radius and lateral track loads still need engineering
definition. Use the same **up to 25 m at 1 km/h** case for the continuous
steep-descent braking study, again approximately **90 seconds**. This does not
establish stopping or energy-handling capability. The
[combined bot-and-trailer case](plan.md#73-passive-trailer) has its own towing
duty; the 40° mower-only target does not apply to it.

### 5.2 Motor and gearbox target

| Parameter | Target | Status |
|---|---:|---|
| Motor count | 2 | Validated architecture |
| Continuous motor rating | ~2 kW each | Provisional target |
| Short peak rating | ~3–4 kW each | Provisional target |
| Continuous track output torque | Earlier 70–80 Nm each estimate | Recalculate against current load cases |
| Short peak track output torque | Earlier ≥120 Nm each estimate | Recalculate against required torque and duration |
| Track output speed | Derive rpm from confirmed geometry: 4 km/h maximum target and 1 km/h steep-case studies | Unqualified performance targets |
| Control | Independent closed-loop speed/current control | Required design direction |
| Environmental protection | Sealed/guarded for dust and washdown | To verify by component selection |

**2026-10-27 braking direction:** Use a controller-supported motor-braking
mode for dynamic deceleration (regeneration or another documented
reverse-current mode) and a mechanical brake on each pod for stationary
holding, applied by default when release power is absent. Motor, controller,
and gearbox selection must account for braking torque/speed at the track,
downhill back-driven speed, current and thermal limits, and battery/BMS energy
handling at high state of charge or cutoff. Field evidence is intended to
determine whether an additional mechanical dynamic brake is needed. Compare
integrated and separate stationary-brake options; if an integrated option
materially raises the motor/gearbox price, use a separate brake. No numeric
price threshold is set. This direction does not qualify stopping or define the
E-stop/fault safe state; the mechanical hold brake is not credited for dynamic
stopping unless rated for it.

**2026-10-27 fore-aft layout direction:** Place the traction motors at the rear
of the bot, with front-mounted implements ahead of them. The owner identifies
front tools up to 50 kg, roughly 1 m forward, that may push against the ground.
Treat this as an unresolved load case, not a validated counterbalance: the
distance datum, working forces, measured CG, and track support footprint still
need definition. This does not change the orientation-neutral CAD model.
**2026-10-28 clarification:** The roughly 1 m forward distance is **not a fixed
requirement**. Choose the front-tool position through packaging and stability
analysis, then define its actual CG location and force application points.
Retain the up-to-50 kg tool case for assessment; it does not establish a
counterbalance or authorize adding that mass outside the configuration budget.

### 5.3 Candidate market options

**2026-10-28 estimating direction:** Use HPM5000B bare motors, EZ-A48500
controllers and Precima FDB 13 C 48 V / 20 Nm holding brakes as the main
[cost references](docs/engineering/technical/modules/02-drive-train/propulsion.md#parts-at-a-glance),
not approved hardware or a power increase. The
[brake offer](https://shop.bj-gear.com/en_eur/precima-spring-applied-brake-fdb-adjustable-13-48vdc-19h7o)
is €159 excluding taxes/delivery (€192.39 planning unit, €384.78 pair).
Its 19H7 hub does not fit the published Ø22.3 mm HPM shaft directly;
[mounting/axial integration](docs/engineering/technical/modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment)
and the custom reduction remain unpriced. The ideal 66:1 static holding screen
is favorable, but does not qualify stopping, transmission strength or slope
safety. Existing power, operating-case and independent-stopping requirements remain.

The following options came from an earlier market screen. Prices and seller specifications must be rechecked before purchase; retailer reviews are not independent durability validation.

| Candidate | Earlier observation | Main issue to verify |
|---|---|---|
| Unite BL2000ZX | About €487; 48 V; advertised geared output around 40 Nm; ~778 rpm | Whether 40 Nm is continuous output; controller compatibility; additional 2:1 chain reduction and speed trade-off |
| ATO D130BLD2000 | About $816; 2 kW; 2,000 rpm; advertised 10 Nm continuous / 30 Nm peak; IP65; retailer rating 4.9/5 from 13 reviews | Review independence, gearbox/controller cost, continuous thermal performance |
| BLDC.com D110BLD2000 planetary | About $958; 48 V; 3,000 rpm; configurable planetary reduction | Actual gearbox torque limit, duty cycle, shaft/bearing life and total landed cost |
| Motenergy ME0907 | About $399 in the earlier listing; Hall sensors and temperature sensor; external reduction | Mechanical torque/performance curve, controller match and environmental packaging |
| Golden Motor HPM5000B 48 V, bare | [Main cost candidate](docs/engineering/technical/modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate): recorded 2026-10-26 US$446 at 1–9 pieces; €482.36 with existing FX/provisional VAT, excluding delivery/duty/brokerage | Advertised 5 kW is not a baseline power change; exact winding, continuous curve, cooling, controller and braking remain unqualified; the 2026-10-27 in-drum planetary concept is unpriced |

Potential reduction strategies:

1. integrated planetary gearbox if the price premium is justified and the rated output torque is real;
2. motor plus two-stage chain reduction using guarded sprockets;
3. motor plus a simple industrial gearbox where serviceability is better than compactness.

The purchasing rule is: prefer integrated planetary reduction when the price difference is no more than approximately **€300** over a comparable motor-plus-reduction solution and the torque rating is documented. Otherwise, a chain drive with replaceable sprockets is an acceptable V1 option.

### 5.4 Motor acceptance test

No candidate is accepted from a web listing alone. Require:

- manufacturer datasheet with continuous and peak definitions;
- output torque versus speed and duty cycle;
- controller voltage/current limits;
- thermal sensor and shutdown behaviour;
- shaft, bearing and mounting dimensions;
- water/dust protection information;
- a bench test at the intended voltage and reduction;
- a loaded track test with temperature logging;
- a supplier return/warranty path.

## 6. Battery and electrical system

### Provisional battery baseline

**Owner-confirmed direction:** two ready-made **51.2 V / approximately 100 Ah
LiFePO4 packs**, one per independent pod in the 48 V-class architecture.
Small capacity variations are accepted, preferably upward; 105 Ah is within
scope. Do not series-connect them into a higher-voltage bank. Assess discharge,
peak-duration and charge current separately from Ah capacity.

The [priced options and budget recommendation](docs/engineering/technical/modules/04-battery-and-charging/batteries.md#battery-alternatives)
use the **DC HOUSE 100 Ah / 18 A charger bundle** as conditional first choice
and estimating reference, not a released purchase or proven fit. Its published
pair mass is 89.8 kg, versus 72 kg for the former Elker pair; the mass/CG and
pod layout need revision. The candidate CAD now represents the listing body
and clears it using a raised return and revised tray; terminals, restraints,
complete-machine packaging and mass/CG remain unqualified. See the
[CAD fit limits](docs/engineering/technical/cad/README.md#modeled-dimensions-and-limits).
The higher-voltage comparison remains retired from the active BOM.

For the 100 Ah baseline, nominal energy is 10.24 kWh; the retained 80%
usable-energy assumption gives 8.192 kWh before operational reserve, cold and
aging margins. Two 105 Ah alternatives give 10.752 kWh nominal / 8.6016 kWh
at the same usable fraction, not a proven runtime increase. Verify the
usable-energy budget and expected runtime from logged job consumption:

`usable battery energy ≥ measured job energy × reserve factor + cold/aging margin`

The reserve factor should cover return-to-safe-state, weather variation and battery aging. Do not size only from the motor nameplate: actual mowing, conveyor operation, skid steering and slope work determine energy use.

Required electrical blocks:

- two traction motor controllers;
- battery management system;
- main fuse and contactor;
- pre-charge circuit;
- service disconnect;
- emergency power isolation;
- DC/DC converter for controls, RTK, radios and sensors;
- charger and charge interlock;
- current, voltage and temperature logging;
- protected low-voltage wiring and sealed connectors.

Battery enclosure requirements:

- low centre of gravity and protection from track debris;
- removable modules for service;
- mechanical restraint under shock and rollover loads;
- water drainage and washdown strategy;
- thermal monitoring;
- clear isolation procedure;
- no exposed high-current terminals.

### Charging environment

**2026-10-28 owner requirement:** Charging will take place in an **unheated,
sheltered space that may fall below 0°C**. This describes the ambient
environment, not permission to charge cold cells outside the battery
manufacturer's limits.

The pack/BMS and charger must enforce the selected chemistry's permitted
cell-temperature range and fault response. For the LiFePO4 reference, do not
assume subzero-cell charging is supported. The owner accepts **waiting for
warming or moving the bot to a warmer place**; built-in battery preheating is
not a mandatory requirement. Charging must remain inhibited outside the
qualified cell-temperature range. No numeric cold-charge threshold or
charging procedure is selected. The charging-time study below excludes any
necessary warm-up delay.

### Eight-hour runtime and charging study

**2026-10-28 owner decision:** Eight hours of operation without battery swapping
is a **preferred target, not a firm minimum**; shorter runtime is acceptable to
control battery mass and cost. The reported 220 V supply has a **25 A household
main breaker shared with other loads**, not a dedicated 25 A charging outlet.
The target and budget references are not measured endurance or approved
hardware. The two-100-Ah sizing decision does not prove the preferred runtime.
Charging-outlet and branch-circuit ratings and available power remain unverified; mower fuel
endurance is separate.

The owner scopes this first runtime budget to the **mowing configuration:
propulsion, controls and mower peripherals**. Size conveyor and front-drum
configurations separately later; their electrical loads are not included in
the first mowing-runtime claim.

Size from average **DC power drawn from the batteries**, including traction,
conversion losses and every simultaneously battery-powered implement and
auxiliary. Motor nameplate output is not average battery consumption.
Using the existing 80% usable-energy planning assumption:

`nominal battery energy >= average battery power x 8 hours / 0.80`

| Assumed combined average battery draw | Energy used in eight hours | Illustrative pack per pod | Combined nominal energy |
| --- | ---: | --- | ---: |
| 1 kW | 8 kWh | 51.2 V / 100 Ah | 10.24 kWh |
| 2 kW | 16 kWh | 51.2 V / 200 Ah | 20.48 kWh |
| 3 kW | 24 kWh | 51.2 V / 300 Ah | 30.72 kWh |
| 4 kW | 32 kWh | 51.2 V / 400 Ah | 40.96 kWh |

The 100 Ah row is the current sizing direction; larger rows remain sensitivity
examples, not active purchasing alternatives. These are energy-only examples,
before additional return-to-safe-state, cold and aging margins, not measured
duty or supplier offers. They assume
equal use of the two packs; qualify each independent pod's energy budget
against unequal loading. The owner confirms that the
[DAC 9100 retains its combustion engine](plan.md#71-underbody-dac-9100-mower);
cutting power is therefore excluded from traction-battery energy. Include
traction, controls and any battery-powered mower peripherals; their average
demand remains unmeasured, so none of these rows establishes eight-hour mowing
capability.
If both traction motors continuously deliver 2 kW mechanical output, their
eight-hour output energy alone is 32 kWh: nominal battery capacity must exceed
40 kWh at 80% usable once electrical losses and auxiliary loads are included.

The [former Elker study reference](docs/engineering/technical/modules/04-battery-and-charging/batteries.md#historical-elker-study-reference)
weighed 36 kg per pack. At that historical energy-to-mass ratio, two 200 Ah packs would
weigh approximately 144 kg rather than the reference pair's 72 kg. This is
linear screening, not an actual 200 Ah product specification. Revisit total
mass, CG, traction demand and pod packaging rather than retaining the 300 kg
machine estimate unchanged. This former stationary-oriented reference is no
longer the active budget pack and was not vehicle-qualified.

The [DC HOUSE charger bundle budget](docs/engineering/technical/modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive)
includes one 18 A charger per 100 Ah pack. Returning an assumed 80 Ah per
pack takes approximately **4.44 hours**, with both chargers working concurrently,
before taper/balancing or warm-up delays; near-empty to full is approximately
5.56 hours before those effects. This is arithmetic, not measured charging.
At 58.4 V / 18 A and an assumed 90% efficiency, combined AC demand would be
about **2.34 kW**. The linked charger also claims only 900 W output,
inconsistent with 58.4 V × 18 A = 1,051.2 W. Confirm the supplied model,
actual output curve, efficiency, power factor and mains rating rather than
treating this screen as its specifications.

At 220 V / 25 A the **whole-house** apparent-power ceiling is 5.5 kVA, or
approximately 5.5 kW at unity power factor. Other household loads reduce
what is available for charging, and the outlet/branch circuit may impose a
lower limit; 5.5 kW is **not established as available charger power**. Lower
power factor also increases input current. Confirm the actual outlet, circuit,
wiring and available continuous supply with a qualified electrician. The 25 A
main breaker does not establish a 25 A wall-socket rating. The supplier-listed
charger current supports budget arithmetic, not verified pack/charger/mains
compatibility; the battery scope owns the current pricing update.

### Flat-terrain mowing draw at 4 km/h

**2026-10-28 screening calculation:** Use the provisional 300 kg mower-only
mass and steady straight-line speed of 4 km/h (1.111 m/s) on level ground.
The DAC 9100 engine supplies cutting power independently. No terrain
resistance or electrical consumption has been measured.

**Owner operating-case decision:** Normal flat mowing must cover dry or wet
grass on firm soil, but not soft mud. **Turning in place is required on flat
ground**; the job energy budget must include these maneuvers rather than only
straight-line mowing at 4 km/h. Localized grass scuffing during pivot turns is
acceptable, but deep soil ruts are to be avoided; a quantitative rutting
acceptance limit is not yet defined. This does not assign a measured rolling
coefficient or establish wet-grass traction on slopes.
The [raised-mower obstacle-crossing request](plan.md#raised-mower-obstacle-crossing)
is a separate case, not included in the steady flat-mowing calculation.

For the rolling-load component only:

`F_roll = m x g x Crr`

`P_battery,roll = F_roll x v / (eta_mechanical x eta_motor/controller)`

Use the earlier model's 85% mechanical-efficiency assumption and an additional
**assumed 80% motor/controller efficiency** for this example, giving 68%
combined load-dependent efficiency. These are not supplier-qualified
efficiencies, particularly at light load. The coefficients below are
sensitivity inputs, not verified values assigned to particular grass or soil.

| Assumed Crr | Rolling resistance, whole bot | Mechanical rolling power | Battery rolling-load component, both pods |
| --- | ---: | ---: | ---: |
| 0.05 | 147 N | 164 W | 240 W |
| 0.10 | 294 N | 327 W | 481 W |
| 0.15 | 441 N | 491 W | 721 W |

This omits unmodeled track flex/tension/idler drag, fixed drive losses,
battery-powered controls/peripherals, implement drag, acceleration and
skid-steering. Actual average battery draw cannot be determined from mass
and speed alone. Recalculate for a different installed mass or surface.

For initial energy comparison, a **proposed 1 kW combined flat-mowing budget**
allows some overhead above these rolling-load examples; it is not a measured
average, demonstrated upper bound, or motor-rating requirement. At 51.2 V
and equal sharing, 1 kW total is approximately 9.8 A per pod. Eight hours
would use 8 kWh. The two 100 Ah sizing-reference packs provide 8.192 kWh at
the assumed 80% usable fraction, leaving only 0.192 kWh before additional
return, cold and aging margins. They remain a capacity-study reference, not
proof of eight-hour endurance or an approved vehicle battery. This flat-case
screen does not establish slope/turning capability or justify downsizing the
drive's continuous, peak or braking ratings.

## 7. Implements and attachments

### 7.1 Underbody DAC 9100 mower

The DAC 9100 is the first implement and defines the initial mowing workflow.
**2026-10-28 owner decision:** Retain the mower's own combustion engine.
The traction batteries do not supply blade-driving power; account separately
for any battery-powered starting, control or lift equipment. Fuel endurance
and refueling interruptions remain to be defined independently of battery
runtime.

It should be mounted under the longitudinal spine with:

- guarded rotating components;
- adjustable or floating deck support;
- protected belt/blade service access;
- debris ejection control;
- lift or transport position;
- a positive attachment lock;
- a measured power draw under dry, wet and tall grass.

Before commercial use, validate the mower's actual cutting width, blade condition, mounting loads, power demand, balance and performance on the intended terrain. The 4 km/h mowing speed is a starting operating point, not a guarantee.

#### Raised-mower obstacle crossing

**2026-10-28 owner request:** On flat, firm ground, design for traversing roots,
rocks or steps up to **150 mm high** by raising the mower while **keeping the
cutting blades running**. Obstacle shape, lift travel and crossing speed remain
undefined; this is not the normal 4 km/h mowing case or a demonstrated climbing
capability.

**HOLD:** Blade-running traversal in a raised position is an unqualified
requested mode, not approved operation. Assess blade/obstacle clearance,
guarding and debris containment throughout the lift and crossing, together
with lift retention, interlocks and independent mower stopping. Existing
guards, interlocks and stopping requirements must not be bypassed or weakened.
The mode remains unreleased unless its hazards are resolved; qualification
may require changing the requested mode.

### 7.2 Washable conveyor

The conveyor is intended for moving cut material, fruit or debris. It should be designed for hose-down cleaning, with:

- open/drainable surfaces;
- guarded pinch points;
- quick removal of belt or slats;
- corrosion-resistant fasteners where practical;
- separate motor isolation;
- overload detection;
- a washdown procedure that protects bearings and electronics.

### 7.3 Passive trailer

The passive trailer should carry material without adding a second powered axle.
**2026-10-28 owner decision:** The 450 kg maximum-loaded study case is the
**combined bot, trailer and all payloads**, allocated as **300 kg bot with
fitted equipment + 150 kg fully loaded trailer**. The 150 kg includes trailer
tare and cargo, not 150 kg cargo in addition to trailer mass. This combination
retains the provisional 15° slope ceiling; neither mass nor slope capability
is validated.

The requested minimum useful **uphill speed at the 15° target is 1 km/h**.
For the towing study, use **up to 25 m at 1 km/h** for both uphill and downhill
stretches, approximately **90 seconds** each. These are occasional sections
separated by gentler travel, not a continuously repeated hill duty; do not
assume a quantified cooling interval. These are performance inputs, not
qualified safe speeds or braking capability.
The towing case must cover **dry or wet grass on firm soil, excluding soft
mud**, as in the mowing cases. Trailer traction/braking and turning behavior
still need separate qualification; the mowing case's flat-ground pivot
requirement does not establish a safe trailer maneuver.

Do not use 450 kg as the track-supported mass for ground pressure, traction or
stability. Determine track and trailer-axle reactions from the actual mass
distribution and hitch forces, including tongue-load transfer without
double-counting it as additional combination mass. For a gravity-only climb
with both vehicles on the same grade, the total 450 kg still contributes to
the towing demand. Trailer rolling resistance, hitch geometry, braking and
turning effects require separate definition.

Define:

- payload and tongue-load limits;
- track/machine braking behaviour with trailer attached;
- a secure hitch and safety chain;
- wheel/ground clearance;
- tipping or unloading method;
- maximum safe slope and speed.

The trailer is an attachment, not a reason to oversize the entire traction system without testing.

### 7.4 Front fruit drum

The front drum is a later attachment for orchard work. Validate whether it is intended to collect, roll, brush, crush or transport fruit before freezing the mechanism. Keep its drive and guarding independent so it cannot interfere with the mower safety circuit.

## 8. Control, autonomy and safety

### 8.1 Operating modes

The first prototype should support:

1. wired or local manual commissioning;
2. supervised remote driving;
3. slow autonomous test mode inside a controlled area;
4. RTK Teach & Repeat on validated routes;
5. attachment-specific operating profiles.

Autonomy must be disabled by default after power-up until the operator confirms the machine state, attachment state, communications and geofence.

### 8.2 RTK Teach & Repeat

Teach & Repeat is preferred to unconstrained navigation for the first service product:

- operator teaches a route at low speed;
- route is stored with RTK quality and boundary metadata;
- repeat pass follows the recorded path with speed limits;
- operator remains able to pause or abort immediately;
- route is not reused automatically if the field, attachment or machine configuration changed;
- poor RTK fix, unexpected obstacle or communication loss causes a controlled stop.

The system should log route, time, RTK quality, speed, current, battery state, motor temperatures, emergency events and operator interventions.

### 8.3 Independent safety layer

Safety must not depend solely on the navigation computer or normal motor software. Provide an independent path for:

- physical emergency stop on the machine;
- operator remote emergency stop;
- remote heartbeat/communications timeout;
- a defined braking/energy-isolation sequence and safe motor disable/contactors;
- mower and attachment interlocks;
- tilt/rollover response;
- low battery safe return or stop;
- geofence and maximum-speed enforcement;
- restart inhibition after an emergency stop.

**2026-10-28 owner decision:** No fixed stopping-distance target is selected
here, including at the requested 4 km/h maximum. The braking/traction safety
assessment must establish and verify stopping and holding acceptance criteria
for the applicable configurations, surfaces, slopes and fault cases before
operation. The absence of a numeric target is not a waiver of this release gate.

The safety layer should remove propulsion and implement energy through a defined safe-state sequence. It must be testable without trusting the autonomy stack.
With the DAC 9100 retaining its combustion engine, this requires a defined
mower/engine-stop interface and blade-stop acceptance criteria; opening the
traction battery contactors alone cannot stop the engine-powered cutter.
Motor braking may contribute to dynamic deceleration while its controller and
energy path remain available. The safety design must separately define the
response to controller, battery-path, and power faults; the default-applied
stationary brake is not assumed to be a dynamic stop.

## 9. Preliminary BOM structure

This is a planning BOM, not a purchasing BOM. Quantities and prices require supplier quotations and drawings.

### Chassis and running gear

- 2 commercial rubber tracks; size unselected, with 200 × 72 × 36 retained
  only as the existing price/study reference;
- 2 drive sprockets and compatible hubs;
- idlers, rollers and track tensioners;
- 2 pod side frames;
- variable-width scissor frame;
- longitudinal implement spine;
- mechanical width locks and guards;
- towing point and attachment pins;
- fasteners, bushings, bearings and corrosion protection.

### Propulsion and electrical

- 2 motor/gearbox assemblies;
- 2 motor controllers;
- two 48 V-class battery modules, 10.24 kWh nominal / 8.192 kWh at the
  assumed 80% usable fraction for the current 100 Ah baseline, before reserves;
- BMS, fuses, contactors and pre-charge;
- service disconnects;
- charger;
- DC/DC converter;
- low-voltage distribution and sealed connectors;
- current, voltage, temperature and speed sensors;
- shielded or protected communications wiring.

### Implements

- DAC 9100 underbody mower and mount;
- washable conveyor and drive module;
- passive trailer and hitch;
- front fruit drum and mount;
- guards, skirts, debris shields and washdown drain features.

### Control and safety

- remote control link and operator handset;
- independent safety controller/relay path;
- machine and remote emergency stops;
- RTK receiver, antenna and correction service/interface;
- compute unit for route storage and logging;
- tilt/rollover sensing;
- status lights, buzzer and service display;
- data logging and diagnostic interface.

### Workshop and support

- lifting and transport fixtures;
- battery-safe charging area;
- spare track/sprocket or repair plan;
- electrical test equipment;
- torque and temperature measurement;
- cleaning and inspection kit;
- operator PPE and field signage.

## 10. Build stages

### Stage 0 — customer and site validation

Deliverables:

- 10–20 customer interviews or letters of intent;
- at least three representative plots surveyed;
- pricing and travel-time model;
- slope, gate-width and access constraints;
- safety and legal review questions recorded.

Exit condition: a plausible paid pilot route exists and the minimum operating envelope is documented.

### Stage 1 — bench propulsion prototype

Build one pod or a rigid, restrained bench fixture. Pre-calculate expected
torque from the selected motor and reduction data before testing; this is a
sizing estimate, not measured torque capability. Bench checks are planned
before field checks. Record:

- motor/controller compatibility;
- reduction ratio and calculated torque/speed;
- controlled motor-braking mode, energy path, and stationary-brake behavior;
- measured output speed, current, voltage, and temperature;
- braking and fault behaviour;
- shaft, bearing and sprocket alignment.

Exit condition: one drive can run at the intended duty without overheating or
unsafe fault behaviour in separately authorized checks. Torque remains
unmeasured; calculation alone cannot pass a torque-capability gate or establish
that the drive meets its output target.

### Stage 2 — rolling two-pod chassis

Build both pods, the scissor frame and spine without commercial mowing. The
owner's initial field-check configuration is a bare rolling chassis on flat,
controlled ground, without a mower or attachment. The intended evidence is
onboard logs plus observer notes for braking and track-retention behavior; this
does not define acceptance criteria or authorize a test. Test:

- width adjustment and mechanical locks;
- straight-line tracking and skid steering;
- turning loads and track retention;
- characterize motor braking and stationary holding, then decide from controlled
  evidence whether an additional mechanical dynamic brake is needed;
- braking on representative slopes after the applicable safety and test gates;
- centre of gravity and static stability;
- transport tie-down points;
- washdown and debris protection.

Exit condition: the empty platform can be controlled safely and repeatedly.

### Stage 3 — mower integration

Install the DAC 9100 and measure:

- cutting quality;
- area per battery charge;
- energy per 1,000 m²;
- motor and controller temperature;
- deck vibration;
- grass/debris accumulation;
- stopping distance with mower running;
- service and cleaning time.

Exit condition: supervised mowing is repeatable on dry and moderately difficult plots.

### Stage 4 — safety and supervised remote operations

Test every emergency path independently, then perform supervised field jobs. Record operator interventions, faults and near misses. Do not enable route replay until manual operation is predictable.

Exit condition: the safety case is documented and the operator can bring the machine to a safe state from every expected fault.

### Stage 5 — RTK Teach & Repeat

Add RTK and route recording after the machine and mower are mechanically stable. Start on a fenced or controlled test plot, then move to low-consequence customer plots with an operator present.

Exit condition: repeated routes meet the required boundary, overlap and stop behaviour without hiding failures.

### Stage 6 — pilot service

Run paid or discounted pilot jobs with a written checklist and post-job report. Track:

- revenue per visit;
- actual productive minutes;
- energy used;
- transport and setup time;
- unplanned maintenance;
- customer satisfaction;
- area completed and rework;
- safety events.

Exit condition: reliability and contribution margin support a deliberate second machine or a revised design.

## 11. Verification and test matrix

| Area | Test | Pass evidence |
|---|---|---|
| Structure | Static load and torsion check | No permanent deformation; attachments remain aligned |
| Track system | Repeated turns, slopes and debris | Track retention and acceptable wear |
| Drive | Rated torque/speed duty cycle | Temperature stays within component limits |
| Battery | Full charge/discharge logging | Capacity, reserve and cutoff are understood |
| Water/debris | Controlled washdown and grass/debris exposure | No unsafe leakage or connector faults |
| Braking | Controlled motor-braking, stationary-hold, and approved fault tests on flat ground and representative slopes | Stopping distance and hold behaviour documented; evidence-based decision on separate mechanical dynamic brake |
| Remote control | Range and link-loss tests | Predictable stop on timeout |
| Emergency stop | Machine and remote E-stop | Propulsion and implement enter safe state |
| Mower | Dry, wet and tall grass tests | Cut quality and energy/area recorded |
| RTK | Tree cover and open-field repeat tests | Loss-of-fix response is safe and logged |
| Trailer | Payload and slope tests | Hitch, braking and stability remain within limits |
| Serviceability | Cleaning, track tension and component swap | Target service times achieved |

## 12. Principal risks and mitigations

| Risk | Consequence | Mitigation |
|---|---|---|
| Motor listing overstates continuous torque | Overheating or stalled machine | Bench test; require continuous-duty data and thermal logs |
| Reduction too fast or too slow | Poor slope performance or unusable transport | Select gearing from measured wheel speed/torque; accept lower top speed |
| Motor braking is unavailable or limited by full battery/BMS cutoff | Reduced downhill or fault stopping | Verify controller braking mode and energy path across the operating envelope; retain the default-applied mechanical hold and decide dynamic-brake need from controlled tests plus fault analysis |
| Skid steering overloads tracks and frame | Track wear, high energy use, structural damage | Use replaceable wear parts; test turns and reinforce load paths |
| Wet grass changes grip, traction resistance and cutter load | Sliding, traction-energy overrun or cutter-engine overload | Qualify wet-grass behavior; measure traction electricity and combustion-mower performance separately |
| Blades running with the mower raised | Blade exposure or thrown-debris hazards | Keep the requested mode on HOLD until clearance, guarding, containment, lift and stopping behavior are qualified |
| Charging cells below their approved temperature | Battery damage or unsafe failure | Enforce pack/BMS and charger temperature limits; wait for warming or move to a warmer place |
| Battery water or impact damage | Unsafe failure and downtime | Protected enclosure, isolation, drainage and inspection procedure |
| RTK loss under trees | Route deviation | Stop on poor fix; supervised operation; route qualification |
| Remote link loss | Uncontrolled machine | Independent heartbeat and safe stop |
| Customer plots are more difficult than assumed | Low margin and delays | Survey plots; surcharge or refuse unsuitable jobs |
| Low utilization | Poor return on capital | Pre-sell repeat routes; keep pilot build modular and repairable |
| Washdown damages electronics | Reliability loss | Connector/enclosure test and controlled cleaning procedure |
| Trailer changes stability | Rollover or braking problems | Separate payload/slope limits and dedicated tests |
| Legal/insurance uncertainty | Cannot operate commercially | Obtain local advice before public customer work |

## 13. Open decisions

1. Final pack/charger qualification, current and regen limits, usable energy
   and packaging around the confirmed two-100-Ah LiFePO4 direction.
2. Final motor/controller/gearbox choice after bench comparison, including the
   documented dynamic-braking mode, energy path, and integrated-versus-separate
   stationary-brake price comparison.
3. Reduction ratio and sprocket sizes.
4. Track size, matched running gear, supplier, compound and verified load rating.
5. Feasible body/outside-track width range and assembled fit on the 2 m × 1 m
   transport deck, retaining the 1,600 mm maximum outside-track study target;
   no fixed gate opening or overall height limit. Qualify the slope/configuration
   envelope rather than treating the 400 mm minimum aspiration or 40° site
   target as accepted dimensions/capabilities.
6. Total mass and target centre of gravity.
7. DAC 9100 mounting, cutting width, engine inclination/fuel-endurance limits,
   actual operating loads and qualification of the raised, blade-running request.
8. Qualification of powered rolling width adjustment: exact motor/screw/feedback, reference recovery, validated rolling-speed envelope, and resolution of worm-only holding versus positive locking.
9. RTK correction source and operation under local tree cover.
10. Remote-control frequency, range and fail-safe architecture.
11. Trailer tare/cargo split within the 150 kg loaded budget, hitch reactions,
    braking, turning and the qualified envelope for the 15° target case.
12. Commercial legal classification, insurance and operator requirements.
13. Whether the first service is operator-on-site only or supports remote supervision from a nearby base.
14. Pilot customer list, service radius and travel surcharge.
15. Spare-parts strategy for tracks, sprockets, blades, belts and batteries.

## 14. Immediate next actions

### Engineering

- Measure the DAC 9100 and produce a mounting envelope.
- Request full datasheets and quotations from the shortlisted motor suppliers.
- Build a one-drive test stand with current, speed and temperature logging.
- Select track size and confirm matched sprocket dimensions, profile and ratings.
- Sketch the scissor frame in minimum, nominal and maximum widths.
- Define the independent safety-state diagram before selecting the autonomy computer.

### Business

- Interview local property owners and service providers in the Băișoara/Făget area.
- Record plot size, slope, access, grass conditions and current price.
- Test the 300–500 RON package against real travel/setup time.
- Build conservative, base and upside cash-flow cases.
- Seek two or three pilot customers before committing to a full chassis build.

### Governance

- Maintain a decision log separating supplier claims, measurements and assumptions.
- Do not describe the machine as autonomous or commercially ready before the safety and field gates pass.
- Recalculate the business case whenever battery, motor, transport or operator costs change.

## 15. Baseline decision

Proceed with a **two-pod, variable-width tracked prototype** centered on the
DAC 9100 mower, retaining its own combustion engine. Use the confirmed two
51.2 V / approximately 100 Ah LiFePO4 sizing direction (105 Ah also acceptable)
and keep two approximately 2 kW
continuous traction drives as provisional inputs. The V1 maximum self-propelled travel target is
4 km/h, with 1 km/h steep-section study points. Derive required output torque,
rpm and duration from the current operating cases and confirmed track
geometry; the earlier 70–80 Nm and 140–280 rpm figures are not acceptance
specifications. Use a guarded chain reduction when it provides a better
serviceable cost than an integrated planetary unit, but prefer planetary
reduction when the documented price premium is within approximately €300
and the torque rating is credible.

The next irreversible purchase should be the propulsion bench-test components, not a complete production chassis. The machine earns the right to become a service business only after the measured cost per job, field reliability and independent safety behaviour support the conservative local utilization model.
