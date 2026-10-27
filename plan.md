# MowerBot — Concept, Business and Build Plan

**Revision:** 1.0 — 14 October 2026  
**Project area:** Băișoara / Făget, Romania  
**Status:** concept baseline for engineering validation and pilot-business planning

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
- Commercial rubber tracks nominally **200 × 72 × 36**.
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
- maximum loaded design case: approximately **450 kg**;
- mowing speed: approximately **4 km/h in normal conditions**; reduced speed
  on slopes is accepted where required by qualified machine limits;
- general travel speed: approximately **8 km/h**;
- desired transport maximum: approximately **15–20 km/h**, subject to gearing and safety;
- two motors, each approximately **2 kW continuous**, **3–4 kW short peak**;
- desired output: approximately **70–80 Nm continuous per track**, at least **120 Nm short peak**;
- working output speed: approximately **140–280 rpm**;
- preferred transport output speed: approximately **500–700 rpm** only if torque, thermal limits and safety permit;
- first battery system: likely **48 V nominal**, with capacity around **8 kWh** as a starting estimate;
- electrical autonomy: several hours of mowing, to be proven by logged field energy use.

The 140–280 rpm output-speed estimate predates the 350 mm roller study. A
temporary assumption that its 350 mm physical outside diameter is also the
effective rolling diameter gives about 60.6 rpm at 4 km/h. The track pitch-line
diameter is unknown, so reconcile these provisional speed targets against
confirmed track geometry and the selected travel envelope before choosing a
reduction.

The 2026-10-26 BOM feedback adds an aspirational **400 mm minimum / 1,600 mm
maximum outside-track width** and sites with inclines up to **40°**.
The owner confirms this site target includes both uphill/downhill and
cross-slope travel, and accepts speed reduction below 4 km/h on slopes.
**2026-10-27 load clarification:** the 450 kg maximum-loaded case is limited to
slopes of 15° or less; 40° is for the mower-only configuration. Use the
provisional 300 kg normal-mass estimate for mower-only screening until the
configuration mass is measured.
These are packaging/feasibility inputs, **not validated machine dimensions or
operating limits**. See the [width and slope screen](docs/engineering/width-and-slope-sizing.md)
for clearance, CG, traction, torque, and track-length limitations.

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

- commercial rubber track, nominally 200 × 72 × 36;
- drive sprocket and idlers;
- traction motor and reduction;
- motor controller;
- battery module and contactor/fuse;
- local current, temperature and speed sensing;
- mechanical mounting points to the central frame;
- service disconnect and protected cable routing.

This arrangement supports differential/skid steering, allows a failed pod to be serviced separately, and keeps high-current wiring short. It also creates important design work: track tension, side-load management, frame torsion, synchronised braking and safe behaviour if one pod loses communication.

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
[costed BOM](docs/engineering/bom/chassis-bom.md) records the prototype allowances
and qualification gaps.

The current width study targets are an aspirational 400 mm minimum and
1,600 mm maximum measured outside the tracks. The minimum must increase if
required by complete pod/spine/scissor packaging; overall body width may exceed
outside-track width. The suggested width/length ratio is not a stability rule.
The owner's expected 40° site inclines require separate lateral, longitudinal,
traction, braking, and adjustment-envelope assessment; no such slope is approved.

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

The important constraint is power:

> High torque and high speed cannot both be sustained from a 2 kW motor. For example, 80 Nm at 500 rpm is about 4.2 kW mechanical before losses.

Therefore the first machine should accept modest transport speed and select gearing for approximately 140–280 rpm at the track drive during work. High-speed operation is not a primary requirement.

**2026-10-26 slope clarification:** 4 km/h is a normal-condition target, not a
requirement at the owner's aspirational 40° site incline. Speed may be reduced,
but no safe slope/speed envelope has been established. The
[slope screen](docs/engineering/width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates)
shows that gravity alone can require more than the provisional 70–80 Nm per
track. Revisit output torque, reduction, and working rpm against actual
sprocket radius and load before selecting either BOM scenario. Lower speed
reduces climbing power, not the torque required to resist gravity; it does not
resolve sliding, tipping, parking hold, or loss-of-energy downhill braking.

### 5.2 Motor and gearbox target

| Parameter | Target | Status |
|---|---:|---|
| Motor count | 2 | Validated architecture |
| Continuous motor rating | ~2 kW each | Provisional target |
| Short peak rating | ~3–4 kW each | Provisional target |
| Continuous track output torque | 70–80 Nm each | Provisional target |
| Short peak track output torque | ≥120 Nm each | Provisional target |
| Work output speed | 140–280 rpm | Provisional target |
| Transport output speed | 500–700 rpm preferred, not mandatory | Provisional target |
| Control | Independent closed-loop speed/current control | Required design direction |
| Environmental protection | Sealed/guarded for dust and washdown | To verify by component selection |

**2026-10-27 fore-aft layout direction:** Place the traction motors at the rear
of the bot, with front-mounted implements ahead of them. The owner identifies
front tools up to 50 kg, roughly 1 m forward, that may push against the ground.
Treat this as an unresolved load case, not a validated counterbalance: the
distance datum, working forces, measured CG, and track support footprint still
need definition. This does not change the orientation-neutral CAD model.

### 5.3 Candidate market options

The following options came from an earlier market screen. Prices and seller specifications must be rechecked before purchase; retailer reviews are not independent durability validation.

| Candidate | Earlier observation | Main issue to verify |
|---|---|---|
| Unite BL2000ZX | About €487; 48 V; advertised geared output around 40 Nm; ~778 rpm | Whether 40 Nm is continuous output; controller compatibility; additional 2:1 chain reduction and speed trade-off |
| ATO D130BLD2000 | About $816; 2 kW; 2,000 rpm; advertised 10 Nm continuous / 30 Nm peak; IP65; retailer rating 4.9/5 from 13 reviews | Review independence, gearbox/controller cost, continuous thermal performance |
| BLDC.com D110BLD2000 planetary | About $958; 48 V; 3,000 rpm; configurable planetary reduction | Actual gearbox torque limit, duty cycle, shaft/bearing life and total landed cost |
| Motenergy ME0907 | About $399 in the earlier listing; Hall sensors and temperature sensor; external reduction | Mechanical torque/performance curve, controller match and environmental packaging |
| Golden Motor HPM5000B 48 V, bare | [2026-10-26 sourced alternative](docs/engineering/modules/02-drive-train/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals): US$446 at 1–9 pieces; €482.36 with existing FX/provisional VAT, excluding delivery/duty/brokerage | Advertised 5 kW is not a baseline power change; exact winding, continuous curve, cooling, controller and braking remain unqualified; the 2026-10-27 in-drum planetary concept is unpriced |

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

Start the electrical architecture around **48 V nominal** because it is a practical compromise between current, component availability and touch-safety management. A provisional usable capacity of approximately **8 kWh** is a sizing placeholder, not a final purchase specification.

The final capacity must come from logged energy consumption:

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

## 7. Implements and attachments

### 7.1 Underbody DAC 9100 mower

The DAC 9100 is the first implement and defines the initial mowing workflow. It should be mounted under the longitudinal spine with:

- guarded rotating components;
- adjustable or floating deck support;
- protected belt/blade service access;
- debris ejection control;
- lift or transport position;
- a positive attachment lock;
- a measured power draw under dry, wet and tall grass.

Before commercial use, validate the mower's actual cutting width, blade condition, mounting loads, power demand, balance and performance on the intended terrain. The 4 km/h mowing speed is a starting operating point, not a guarantee.

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

The passive trailer should carry material without adding a second powered axle. Define:

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
- safe motor disable/contactors;
- mower and attachment interlocks;
- tilt/rollover response;
- low battery safe return or stop;
- geofence and maximum-speed enforcement;
- restart inhibition after an emergency stop.

The safety layer should remove propulsion and implement energy through a defined safe-state sequence. It must be testable without trusting the autonomy stack.

## 9. Preliminary BOM structure

This is a planning BOM, not a purchasing BOM. Quantities and prices require supplier quotations and drawings.

### Chassis and running gear

- 2 commercial 200 × 72 × 36 rubber tracks;
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
- 48 V battery modules, provisional ~8 kWh total;
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

Build one pod or a rigid bench fixture. Verify:

- motor/controller compatibility;
- reduction ratio;
- output torque and speed;
- current draw;
- thermal rise;
- braking and fault behaviour;
- shaft, bearing and sprocket alignment.

Exit condition: one drive can run at the intended duty without overheating or unsafe fault behaviour.

### Stage 2 — rolling two-pod chassis

Build both pods, the scissor frame and spine without commercial mowing. Test:

- width adjustment and mechanical locks;
- straight-line tracking and skid steering;
- turning loads and track retention;
- braking on representative slopes;
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
| Braking | Flat and slope stopping tests | Stopping distance and hold behaviour documented |
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
| Skid steering overloads tracks and frame | Track wear, high energy use, structural damage | Use replaceable wear parts; test turns and reinforce load paths |
| Wet grass raises mower load | Battery depletion and thermal faults | Wet-grass test; limit speed; monitor current and temperature |
| Battery water or impact damage | Unsafe failure and downtime | Protected enclosure, isolation, drainage and inspection procedure |
| RTK loss under trees | Route deviation | Stop on poor fix; supervised operation; route qualification |
| Remote link loss | Uncontrolled machine | Independent heartbeat and safe stop |
| Customer plots are more difficult than assumed | Low margin and delays | Survey plots; surcharge or refuse unsuitable jobs |
| Low utilization | Poor return on capital | Pre-sell repeat routes; keep pilot build modular and repairable |
| Washdown damages electronics | Reliability loss | Connector/enclosure test and controlled cleaning procedure |
| Trailer changes stability | Rollover or braking problems | Separate payload/slope limits and dedicated tests |
| Legal/insurance uncertainty | Cannot operate commercially | Obtain local advice before public customer work |

## 13. Open decisions

1. Exact battery chemistry, voltage and modular capacity.
2. Final motor/gearbox choice after bench comparison.
3. Reduction ratio and sprocket sizes.
4. Track supplier, compound and verified load rating.
5. Feasible minimum/maximum body and outside-track widths from the 400/1,600 mm study targets, and a qualified slope/configuration envelope for expected sites up to 40°.
6. Total mass and target centre of gravity.
7. DAC 9100 mounting, cutting width and measured power demand.
8. Qualification of powered rolling width adjustment: exact motor/screw/feedback, reference recovery, validated rolling-speed envelope, and resolution of worm-only holding versus positive locking.
9. RTK correction source and operation under local tree cover.
10. Remote-control frequency, range and fail-safe architecture.
11. Trailer payload, braking and maximum permitted slope.
12. Commercial legal classification, insurance and operator requirements.
13. Whether the first service is operator-on-site only or supports remote supervision from a nearby base.
14. Pilot customer list, service radius and travel surcharge.
15. Spare-parts strategy for tracks, sprockets, blades, belts and batteries.

## 14. Immediate next actions

### Engineering

- Measure the DAC 9100 and produce a mounting envelope.
- Request full datasheets and quotations from the shortlisted motor suppliers.
- Build a one-drive test stand with current, speed and temperature logging.
- Confirm compatible 200 × 72 × 36 track and sprocket dimensions.
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

Proceed with a **two-pod, variable-width tracked prototype** centered on the DAC 9100 mower, using 48 V-class electrical architecture and two approximately 2 kW continuous traction drives. Treat 70–80 Nm continuous output per track and approximately 140–280 rpm working speed as engineering targets. Use a guarded chain reduction when it provides a better serviceable cost than an integrated planetary unit, but prefer planetary reduction when the documented price premium is within approximately €300 and the torque rating is credible.

The next irreversible purchase should be the propulsion bench-test components, not a complete production chassis. The machine earns the right to become a service business only after the measured cost per job, field reliability and independent safety behaviour support the conservative local utilization model.
