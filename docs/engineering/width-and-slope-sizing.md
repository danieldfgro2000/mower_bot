# Width and Slope Feasibility Screen

<a id="document-overview"></a>

**Date:** 2026-10-28 | **Status:** preliminary calculations, not operating limits,
fabrication dimensions, a structural analysis, or a machine safety assessment.

**Summary:** Preliminary packaging, stability, and drive-load calculations.
The [400 mm width target conflicts with the reference battery layout](width-and-slope-sizing.md#minimum-width-and-packaging).
The 40° mower-only and 450 kg combined bot-and-trailer / 15° cases are study
inputs, not approved limits; this screen establishes no safe width, slope, or speed.

## Results at a glance

| Part / question | Current screening result | Open the calculation | Return to the component |
| --- | --- | --- | --- |
| Will the budget battery fit the pod? | The new 420 × 320 × 260 mm pack consumes the old model's vertical margin; no complete fit is established and CAD still uses the former Elker envelope | [Minimum width](width-and-slope-sizing.md#minimum-width-and-packaging) · [Battery clearance](width-and-slope-sizing.md#provisional-battery-clearance) | [Pack price/data](modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive) · [Pod fit](modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) |
| Does the track fit the proposed drum layout? | The 2,592 mm pitch loop is an unverified code interpretation; 350 mm is a flexible physical-drum-OD study placeholder, not confirmed pitch diameter or a requirement | [Track loop and CAD assumptions](width-and-slope-sizing.md#track-length-check) | [Drum engagement](modules/01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Motor/drum mounting](modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| What torque does the slope screen require? | At assumed 175 mm radius: gravity-only **165.5 Nm/track** for 300 kg mower-only / 40° and **100.0 Nm/track** for the 450 kg bot-and-trailer combination / 15°; not design ratings | [Climb torque](width-and-slope-sizing.md#climb-torque) · [Reduced-speed power](width-and-slope-sizing.md#effect-of-accepting-reduced-speed) | [Motor choices and ratings](modules/02-drive-train/propulsion.md#parts-at-a-glance) · [Reduction study](modules/02-drive-train/propulsion.md#speed-and-ratio-screen) |
| Does wider mean safe on a cross-slope? | No approved angle; CG, effective support, traction and dynamic effects remain unresolved | [Tipping screen](width-and-slope-sizing.md#lateral-static-tipping-screen) · [Slip requirement](width-and-slope-sizing.md#slip-requirement) | [Width holding](modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping) · [Tilt/interlock requirements](modules/06-safety-controls-and-sensors/safety-controls.md#ps30-tilt-sensing-and-interlocks) |

**Further detail:** [Inputs](width-and-slope-sizing.md#inputs-and-unresolved-definitions) ·
[Packaging](width-and-slope-sizing.md#minimum-width-and-packaging) ·
[Track length and pod fit](width-and-slope-sizing.md#track-length-check) ·
[Tipping](width-and-slope-sizing.md#lateral-static-tipping-screen) ·
[Traction and holding](width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates) ·
[Design implications](width-and-slope-sizing.md#consequences-for-the-design-and-bom)

**Related documents:** [Pod-fit CAD](cad/module-01-track-pod-fit.scad) ·
[Cohidrex idler lead](bom/sources.md#s26-cohidrex-idler-wheel-family) ·
[Product authority](../../plan.md#42-variable-width-scissor-frame) ·
[BOM Cost Breakdown](cost-breakdown.md) ·
[Feedback decisions](bom/feedback.md#feedback-decisions) ·
[Width-adjustment scope](modules/03-width-adjustment/width-adjustment.md)

## Inputs and unresolved definitions

| Input | Value / evidence status |
| --- | --- |
| Track | [PowerTrack listing (S01)](bom/sources.md#s01-powertrack-rubber-tracks): `200×72×36` / `200X72X36`, a price/study reference, not a mandatory size. No notation definition or dimensional drawing/table; usual 200 mm width × 72 mm pitch × 36 links interpretation is unverified |
| Minimum outside-track width | [Original owner aspiration](bom/feedback.md#f06-packaging-and-site-targets): **400 mm**, subject to mechanical limitations, not a released width. [Current access requirement](../../plan.md#42-variable-width-scissor-frame): no fixed gate opening; minimize complete-machine width where practical |
| Maximum outside-track width | [Owner study target](bom/feedback.md#f06-packaging-and-site-targets): **1,600 mm**, not demonstrated stability |
| Transport packaging | [Assembled transport target](../../plan.md#42-variable-width-scissor-frame): usable platform 2 m long × 1 m wide; include the narrowed bot, fitted mower, guards and restraint clearances. Platform capacity and ramp/loading geometry remain unqualified |
| Suggested width/length ratio | Owner suggested about 2:1; **not a stability criterion** and does not establish an 800 mm finished machine length |
| Site inclination | Owner expects up to **40°** for the mower-only configuration, including uphill/downhill and cross-slope travel; the 450 kg bot-and-trailer combination is limited to **15°** in the study; neither is an approved operating limit |
| V1 maximum self-propelled travel | [Current speed target](../../plan.md#provisional-engineering-targets): **4 km/h**, prioritizing the low-speed drive; earlier higher-speed aspirations are withdrawn, not retained as gearing requirements |
| Slope duty | [Requested mower-only duty](../../plan.md#51-duty-requirement): 1 km/h minimum useful speed at the steepest target, up to 25 m per steep climb/descent, occasional sections separated by gentler mowing, wet grass on firm soil included, gradual moving turns without stationary pivots. These are sizing inputs, not safe operating limits |
| Mass/load configuration | [Plan's provisional mass and load cases](../../plan.md#provisional-engineering-targets): 300 kg mower-only proxy up to 40°; the 450 kg / 15° combination is 300 kg bot plus 150 kg loaded trailer, including payloads. Hitch reactions and actual masses remain unverified; 450 kg is not all carried on the tracks |
| CG height/offset | Unknown in every configuration; example values below are not measurements or design approval |
| Width actuation | [Reused 12 V worm-reduction motor and screw concept](modules/03-width-adjustment/width-adjustment.md#powered-rolling-width-adjustment), estimated 3–5 A with incremental turns-to-width proposal; load/holding/speed unqualified |

Angles are **degrees**, not percent grade: `tan(40°) × 100 ≈ 83.91%`.

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)


## Minimum width and packaging

For track width `t` and clear gap `g` between their inner edges,
`outside-track width B = 2t + g`. With `t = 200 mm`, `B = 400 mm`
requires **g = 0**. That is a geometric lower bound, not usable central
clearance for the spine, scissor links, guards, cable movement, or debris.

The **historical** [Elker LFP10048LCD battery reference](bom/sources.md#s16-elker-lfp10048lcd-battery)
is listed as **522 × 269 × 217 mm**, 36 kg. In its low-height orientation,
two 269 mm-wide pod interiors alone require 538 mm before walls and central
clearance. Even the smallest listed dimension exceeds the 200 mm track width.
At 269 mm across the pod, a centered pack is 69 mm wider than the track; guard
clearance and the outboard removal path remain unresolved.
Overhanging pods could make outside-track width smaller than overall body
width, but would not produce a genuinely 400 mm-wide finished machine.
Alternative cells/packs could change packaging and must be re-costed.

The current [DC HOUSE budget reference](modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive)
is **504 × 268 × 233 mm**, 44.9 kg per pack according to the non-DE EU offer;
the exact-revision drawing remains required. Side-by-side pack bodies alone
span 536 mm before enclosures or central clearance. The former 600–800 mm
study range is not a current sizing decision. Derive a complete narrowed
transport configuration within the owner's 1 m-wide deck constraint.
Determine the actual minimum from a layout of **both complete pods**, spine,
scissor/lock/screw swept envelopes, guards, and moving harness. Keep body width,
outside-track width, track centre spacing, and inner clearance as separate
dimensions. No width-specific safe slope is currently known.

**Continue with the part:** [Pack price and specifications](modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive) ·
[Enclosure and restraints](modules/04-battery-and-charging/batteries.md#ps19-battery-enclosures-and-restraints).

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)


## Track length check

**Detail:** [Pitch-loop geometry](width-and-slope-sizing.md#pitch-loop-geometry) ·
[Pod-fit CAD assumptions](width-and-slope-sizing.md#pod-fit-cad-assumptions) ·
[Tensioner and idler interfaces](width-and-slope-sizing.md#tensioner-and-idler-interfaces) ·
[Battery clearance](width-and-slope-sizing.md#provisional-battery-clearance).

### Pitch-loop geometry

If the listing code follows the usual convention, nominal pitch-loop length is
`72 × 36 = 2,592 mm`. The [PowerTrack page](bom/sources.md#s01-powertrack-rubber-tracks) does not confirm that interpretation or
publish the track's measured loop length. For an illustrative two-equal-wheel
oval path with radius `r` and wheel-centre separation `a`:

`2,592 = 2a + 2πr`; longitudinal pitch envelope `E = a + 2r`.

At **r = 100 mm**, `a ≈ 981.8 mm` and `E ≈ 1,181.8 mm`, before actual tread
thickness and structural overhangs. This is **not** the selected sprocket size
or layout. It shows why an 800 mm complete pod length must not be inferred
from the proposed 1,600 mm width or a width/length ratio. Actual roller/idler
geometry, track pitch line and wrap determine the envelope.

### Pod-fit CAD assumptions

The [editable pod-fit concept](cad/module-01-track-pod-fit.scad) still uses a
**350 mm physical roller outside-diameter placeholder**, not an owner-selected
dimension. It also retains the listing-code interpretation and former Elker
battery envelope, not the new budget pack.
With the illustrative 20 mm belt
thickness, its simplified model estimates a 370 mm track-path diameter by
placing the path at the belt mid-thickness. This offset is an assumption, not
the supplier's confirmed pitch-line position. The belt and carrier thicknesses
are also assumptions. The model is not a dimensional drawing or evidence that
the battery fits; obtain the supplier track drawing and confirm the complete
carrier, guard, and extraction clearances first.

### Tensioner and idler interfaces

The selected concept spring-loads the **upper-return support rollers**, pushing
them outward against the upper run to tension the track. Their number/spacing,
spring setting, travel, stops, loads, and motion envelope remain undefined and
are not represented in the model or clearance figures below. Check that motion
against the battery, carrier, guards, and outboard extraction path before
treating the packaging as viable.
See the [roller and spring-tensioner concept](modules/01-structure-and-running-gear/running-gear.md#ps02-sprockets-rollers-and-tensioners)
for the required mechanical definition.

The [Cohidrex idler-wheel family](bom/sources.md#s26-cohidrex-idler-wheel-family) is a review lead only: it
is described for Trabber tracks, with no dimensions or confirmed compatibility
for the [PowerTrack track](bom/sources.md#s01-powertrack-rubber-tracks). The concept sketch marks the idler as unresolved and does not imply
that this product fits.

### Provisional battery clearance

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

**Continue with the part:** [Battery-to-pod fit](modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) ·
[Spring tensioner](modules/01-structure-and-running-gear/running-gear.md#spring-tensioner-concept) ·
[Frame definition](modules/01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments).

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)


## Lateral static tipping screen

For a stationary rigid body on an ideal uniform cross-slope:

- `d`: downhill distance from projected CG centreline to the assumed support edge.
- `h`: CG height measured normal to the support plane.
- `y`: downhill CG offset relative to the machine centreline.
- Gravity reaches the edge when `h × tan(θ) = d - y`.
- Thus `θ_tip = atan((d - y) / h)`.

At outside-track width **B = 1.60 m**, ideal full-width outer contact edges
give `d = 0.80 m`. Using track centre-lines instead gives a deliberately
reduced `d = (B - t)/2 = 0.70 m`. This reduction is an illustration, **not
a validated allowance for rough ground**; actual support can be worse.

| Assumed centred CG height h | Ideal tip angle, d = 0.80 m | Reduced-span tip angle, d = 0.70 m | Reduced-span gravity-projection distance left at 40° |
| --- | ---: | ---: | ---: |
| 0.40 m | 63.4° | 60.3° | 0.364 m |
| 0.60 m | 53.1° | 49.4° | 0.197 m |
| 0.80 m | 45.0° | 41.2° | 0.029 m |

These are **zero-margin static tipping angles**, not safe operating angles.
At `d = 0.70 m`, a 0.10 m downhill CG offset reduces effective `d` to 0.60 m;
with `h = 0.60 m`, the ideal tip angle becomes 45°. Steering, impact, braking,
soft soil, a track dropping into a rut, or implement motion can invalidate
the static model. Width change itself changes the support polygon.

At the 400 mm geometric width bound, the same centre-line screen gives
`d = 0.10 m` and a **zero-margin critical h of only 0.119 m at 40°**.
This is not a usable design operating point. Do not allow an arbitrary
target width on a slope merely because the motor can reach it.

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)


## Traction, climbing, and holding are separate gates

**Detail:** [Slip requirement](width-and-slope-sizing.md#slip-requirement) ·
[Climb torque](width-and-slope-sizing.md#climb-torque) ·
[Reduced-speed power](width-and-slope-sizing.md#effect-of-accepting-reduced-speed) ·
[Downhill stopping and holding](width-and-slope-sizing.md#downhill-stopping-and-holding).

### Slip requirement

For an ideal isotropic friction model, avoiding gravitational slip requires
`μ ≥ tan(40°) ≈ 0.839`, before any reserve. This is a **required coefficient**,
not a claim about rubber tracks on grass; wet vegetation and soil shear can
cause sliding before a static rollover calculation predicts tipping.

### Climb torque

For **straight uphill** travel, ignoring rolling resistance and losses:

`F = m g sin(θ)`; equal per-track output torque `T = F r / 2`.

For this screening table only, `r = 0.175 m` is derived from the provisional
350 mm physical roller OD placeholder as if it were the effective rolling
diameter. The value is not a required drum size; the actual track pitch-line
radius is unknown and the calculation must be revisited with the selected
track/drum geometry.

| Study configuration | Assumed mass | Uphill angle | Gravity force, whole machine | Gravity-only torque per track |
| --- | ---: | ---: | ---: | ---: |
| Mower-only, normal-mass proxy | 300 kg | 40° | 1,891.7 N | 165.5 Nm |
| Bot plus loaded trailer | 450 kg combined | 15° | 1,143.0 N | 100.0 Nm |

For the combined row, both vehicles are assumed to be on the same grade and
the bot supplies the towing effort. The gravity-only total remains valid for
the 300 kg bot plus 150 kg loaded trailer allocation; it does not place 450 kg
on the tracks. Use actual bot mass, hitch forces and support reactions for
traction and stability, and include trailer rolling/braking behavior separately.

These are loss-free lower bounds, not design ratings. Both exceed the plan's
70–80 Nm continuous output target at the assumed 175 mm radius. A short peak
rating cannot satisfy a continuous climb or parking hold; braking/holding and
full-SOC downhill behavior require separate design evidence. Longitudinal
tipping depends on **ground-contact length and fore/aft CG**, not lateral width;
none is established here.

**Continue with the drive:** [Motor prices and specifications](modules/02-drive-train/propulsion.md#parts-at-a-glance) ·
[Reduction and output requirements](modules/02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware).

### Effect of accepting reduced speed

With `g = 9.81 m/s²`, gravity-only climbing power is `P = F × v` for the
**whole machine**. The following speeds are arithmetic examples, not approved
presets; torque in the preceding table is unchanged at either speed.

| Study configuration | Gravity-only track power at 4 km/h | Gravity-only track power at 2 km/h | Gravity-only track power at requested 1 km/h study point |
| --- | ---: | ---: | ---: |
| 300 kg / 40° mower-only proxy | 2.10 kW | 1.05 kW | 0.53 kW |
| 450 kg bot-and-trailer combination / 15° | 1.27 kW | 0.64 kW | 0.32 kW |

These exclude rolling/soil resistance, steering, acceleration, reduction and
motor/controller losses, and all implement loads. They do not prove either
motor package can climb continuously. Simply commanding a lower motor rpm
does **not** increase its continuous rated torque; lower-speed thermal behavior
also requires confirmation. A different reduction can trade output speed for
torque, subject to all component ratings.

The BOM's [illustrative 48 V 16:1 reduction](modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive)
yields about 86.6 Nm at assumed 85%
mechanical efficiency, below both gravity-only cases, before any margin or resistance.
The [HPM5000B speed-and-ratio study](modules/02-drive-train/propulsion.md#speed-and-ratio-screen) uses 66:1 to
approach 4 km/h at 4,000 motor rpm by temporarily treating the 350 mm physical
roller OD placeholder as the effective rolling diameter; the drum size is not
fixed and the track pitch-line diameter is unknown. This is a speed-driven
concept, not a gearbox rating or approved ratio. Revisit output speed, torque,
and duty together rather than selecting by nominal voltage or kW.

### Downhill stopping and holding

The [FDB 13 C motor-side static screen](modules/02-drive-train/propulsion.md#precima-fdb-13-c-holding-brake-candidate)
reflects 165.53 Nm per track to 2.51 Nm at ideal 66:1 versus a nominal
20 Nm brake. This is not a certified safety margin or dynamic-stop rating;
[shaft, mounting and axial fit](modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment)
also remain unresolved.

For descent, slowing reduces gravitational power to dissipate at a given
instant, but not the gravitational energy over the same vertical drop or the
static holding requirement. Braking must remain effective with a full battery,
BMS disconnection, or lost electrical power. Do not rely on regeneration alone.
Cross-slope slipping and rollover require their own assessment regardless of
speed reduction. See the [braking direction and limits](modules/02-drive-train/propulsion.md#owner-braking-direction-2026-10-27)
and [independent stopping requirements](modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)


## Consequences for the design and BOM

Retain 1,600 mm as a **study target**; do not approve 40° operation from it.
Keep batteries and heavy assemblies low where the complete layout permits,
then calculate/measure CG and support geometry for every intended width,
load, implement, and travel orientation. No new safe CG threshold is set here.

Width-adjustment limits must account for stability, lateral track loads,
traction, reference validity, actual adjustment rate, stopping/holding, and
fault recovery. The claim that rolling protects the tracks remains a validation
target, not a demonstrated behavior.
[Worm-only holding](modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping)
remains unresolved.
No automatic narrowing, homing, or restart after a fault is authorized.

The [BOM](bom/chassis-bom.md) retains provisional material quantities and prices:
these calculations alone do not establish screw length, frame sections,
drive ratio, braking ratings, sensor ranges, or a delivered parts list.
Next evidence: pod layout, contact geometry, actual motor data, linkage/screw
dimensions, and CG/load
model, followed by competent design review. Any physical tests need separate
explicit authorization and a reviewed progressive test plan; this note
does **not** authorize approaching 40° with the prototype.

[↑ Back to document overview](width-and-slope-sizing.md#width-and-slope-feasibility-screen)
