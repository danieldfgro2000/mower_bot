# Width and Slope Feasibility Screen

<a id="document-overview"></a>

**Date:** 2026-10-27 | **Status:** preliminary calculations, not operating limits,
fabrication dimensions, a structural analysis, or a machine safety assessment.

**Summary:** The S01 track listing is labelled `200×72×36`, but supplies no
dimension drawing; the usual width/pitch/link interpretation and 2,592 mm
pitch-line length remain unverified. At the 400 mm outside-track target, 200 mm
tracks leave no central gap; the referenced low-height battery layout needs
538 mm for two pod interiors. The user-selected 350 mm physical roller-OD study
still leaves fit unverified. The owner limits the 450 kg loaded case to 15° and
reserves 40° for mower-only use; the 300 kg normal-mass estimate is only a
screening proxy. CG, contact geometry, traction, braking, and continuous drive
capability remain unresolved. This screen establishes no safe width, slope, or
speed.

**Navigate:** [Inputs](width-and-slope-sizing.md#inputs-and-unresolved-definitions) ·
[Packaging](width-and-slope-sizing.md#minimum-width-and-packaging) ·
[Track length](width-and-slope-sizing.md#track-length-check) ·
[Pod-fit concept](cad/module-01-track-pod-fit.scad) ·
[Idler lead](bom/sources.md#s26) ·
[Tipping](width-and-slope-sizing.md#lateral-static-tipping-screen) ·
[Traction and holding](width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates) ·
[Design implications](width-and-slope-sizing.md#consequences-for-the-design-and-bom) |
[Product authority](../../plan.md#42-variable-width-scissor-frame) ·
[BOM Cost Breakdown](cost-breakdown.md) ·
[Feedback decisions](bom/feedback.md#feedback-decisions) ·
[Width-adjustment scope](bom/width-adjustment.md)

## Inputs and unresolved definitions

| Input | Value / evidence status |
| --- | --- |
| Track | S01 title/SKU: `200×72×36` / `200X72X36`; page does not define the notation or publish a dimensional drawing/table. Usual 200 mm width × 72 mm pitch × 36 links interpretation is unverified |
| Minimum outside-track width | Owner aspiration **400 mm**; explicitly subject to mechanical limitations, not a released width |
| Maximum outside-track width | Owner study target **1,600 mm**; not demonstrated stability |
| Suggested width/length ratio | Owner suggested about 2:1; **not a stability criterion** and does not establish an 800 mm finished machine length |
| Site inclination | Owner expects up to **40°** for the mower-only configuration, including uphill/downhill and cross-slope travel; the 450 kg loaded case is limited to **15°**; neither is an approved operating limit |
| Slope speed | Owner accepts reducing speed below the plan's normal-condition 4 km/h target; no numeric safe slope speed is established |
| Mass/load configuration | Plan's provisional 300 kg normal-mass proxy for mower-only screening up to 40°; 450 kg maximum-loaded case limited to 15°; masses not measured |
| CG height/offset | Unknown in every configuration; example values below are not measurements or design approval |
| Width actuation | Existing 12 V worm-reduction motor, estimated 3–5 A, screw mechanism and incremental turns-to-width proposal; load/holding/speed unqualified |

Angles are **degrees**, not percent grade: `tan(40°) × 100 ≈ 83.91%`.

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)


## Minimum width and packaging

For track width `t` and clear gap `g` between their inner edges,
`outside-track width B = 2t + g`. With `t = 200 mm`, `B = 400 mm`
requires **g = 0**. That is a geometric lower bound, not usable central
clearance for the spine, scissor links, guards, cable movement, or debris.

The [current 48 V battery reference](https://elkersolutions.com/product/lifepo4-lithium-battery-48v-100ah/)
is listed as **522 × 269 × 217 mm**, 36 kg. In its low-height orientation,
two 269 mm-wide pod interiors alone require 538 mm before walls and central
clearance. Even the smallest listed dimension exceeds the 200 mm track width.
At 269 mm across the pod, a centered pack is 69 mm wider than the track; guard
clearance and the outboard removal path remain unresolved.
Overhanging pods could make outside-track width smaller than overall body
width, but would not produce a genuinely 400 mm-wide finished machine.
Alternative cells/packs could change packaging and must be re-costed.

Study roughly **600–800 mm as a packaging range**, not an accepted minimum.
Determine the actual minimum from a layout of **both complete pods**, spine,
scissor/lock/screw swept envelopes, guards, and moving harness. Keep body width,
outside-track width, track centre spacing, and inner clearance as separate
dimensions. No width-specific safe slope is currently known.

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)


## Track length check

If the listing code follows the usual convention, nominal pitch-loop length is
`72 × 36 = 2,592 mm`. The S01 page does not confirm that interpretation or
publish the track's measured loop length. For an illustrative two-equal-wheel
oval path with radius `r` and wheel-centre separation `a`:

`2,592 = 2a + 2πr`; longitudinal pitch envelope `E = a + 2r`.

At **r = 100 mm**, `a ≈ 981.8 mm` and `E ≈ 1,181.8 mm`, before actual tread
thickness and structural overhangs. This is **not** the selected sprocket size
or layout. It shows why an 800 mm complete pod length must not be inferred
from the proposed 1,600 mm width or a width/length ratio. Actual roller/idler
geometry, track pitch line and wrap determine the envelope.

The [editable pod-fit concept](cad/module-01-track-pod-fit.scad) uses the
owner-selected **350 mm physical roller outside diameter**, the listing-code
interpretation, and the BOM battery envelope. With the illustrative 20 mm belt
thickness, its simplified model estimates a 370 mm track-path diameter by
placing the path at the belt mid-thickness. This offset is an assumption, not
the supplier's confirmed pitch-line position. The belt and carrier thicknesses
are also assumptions. The model is not a dimensional drawing or evidence that
the battery fits; obtain the supplier track drawing and confirm the complete
carrier, guard, and extraction clearances first.

The selected concept spring-loads the **upper-return support rollers**, pushing
them outward against the upper run to tension the track. Their number/spacing,
spring setting, travel, stops, loads, and motion envelope remain undefined and
are not represented in the model or clearance figures below. Check that motion
against the battery, carrier, guards, and outboard extraction path before
treating the packaging as viable.

The [Cohidrex idler-wheel family](bom/sources.md#s26) is a review lead only: it
is described for Trabber tracks, with no dimensions or confirmed compatibility
for S01. The concept sketch marks the idler as unresolved and does not imply
that this product fits.

With the model's assumed 20 mm belt, 80 mm frame gap, and 10 mm carrier, only
**43 mm** remains above the 217 mm pack before installation or service
clearance. The assumed 2,592 mm pitch loop leaves about **193 mm total** along
the straight run around a centered 522 mm pack. Both margins depend on the
unverified track-code interpretation and placeholder geometry; neither proves
fit.

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)


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

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)


## Traction, climbing, and holding are separate gates

For an ideal isotropic friction model, avoiding gravitational slip requires
`μ ≥ tan(40°) ≈ 0.839`, before any reserve. This is a **required coefficient**,
not a claim about rubber tracks on grass; wet vegetation and soil shear can
cause sliding before a static rollover calculation predicts tipping.

For **straight uphill** travel, ignoring rolling resistance and losses:

`F = m g sin(θ)`; equal per-track output torque `T = F r / 2`.

For this screening table only, `r = 0.175 m` is derived from the user-selected
350 mm physical roller OD as if it were the effective rolling diameter. The
actual track pitch-line radius is unknown.

| Study configuration | Assumed mass | Uphill angle | Gravity force, whole machine | Gravity-only torque per track |
| --- | ---: | ---: | ---: | ---: |
| Mower-only, normal-mass proxy | 300 kg | 40° | 1,891.7 N | 165.5 Nm |
| Maximum-loaded case | 450 kg | 15° | 1,143.0 N | 100.0 Nm |

These are loss-free lower bounds, not design ratings. Both exceed the plan's
70–80 Nm continuous output target at the assumed 175 mm radius. A short peak
rating cannot satisfy a continuous climb or parking hold; braking/holding and
full-SOC downhill behavior require separate design evidence. Longitudinal
tipping depends on **ground-contact length and fore/aft CG**, not lateral width;
none is established here.

### Effect of accepting reduced speed

With `g = 9.81 m/s²`, gravity-only climbing power is `P = F × v` for the
**whole machine**. The following speeds are arithmetic examples, not approved
presets; torque in the preceding table is unchanged at either speed.

| Study configuration | Gravity-only track power at 4 km/h | Gravity-only track power at 2 km/h |
| --- | ---: | ---: |
| 300 kg / 40° mower-only proxy | 2.10 kW | 1.05 kW |
| 450 kg / 15° maximum-loaded case | 1.27 kW | 0.64 kW |

These exclude rolling/soil resistance, steering, acceleration, reduction and
motor/controller losses, and all implement loads. They do not prove either
motor package can climb continuously. Simply commanding a lower motor rpm
does **not** increase its continuous rated torque; lower-speed thermal behavior
also requires confirmation. A different reduction can trade output speed for
torque, subject to all component ratings.

The BOM's illustrative 48 V 16:1 reduction yields about 86.6 Nm at assumed 85%
mechanical efficiency, below both gravity-only cases. Its 72 V 10:1 example
yields about 125.9 Nm, above the 450 kg / 15° case but below the 300 kg / 40°
case, before any margin or resistance. The HPM5000B CAD study uses 66:1 to
approach 4 km/h at 4,000 motor rpm by temporarily treating the 350 mm physical
roller OD as the effective rolling diameter; the track pitch-line diameter is
unknown. This is a speed-driven concept, not a gearbox rating or approved
ratio. Revisit output speed, torque, and duty together rather than selecting by
nominal voltage or kW.

For descent, slowing reduces gravitational power to dissipate at a given
instant, but not the gravitational energy over the same vertical drop or the
static holding requirement. Braking must remain effective with a full battery,
BMS disconnection, or lost electrical power. Do not rely on regeneration alone.
Cross-slope slipping and rollover require their own assessment regardless of
speed reduction.

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)


## Consequences for the design and BOM

Retain 1,600 mm as a **study target**; do not approve 40° operation from it.
Keep batteries and heavy assemblies low where the complete layout permits,
then calculate/measure CG and support geometry for every intended width,
load, implement, and travel orientation. No new safe CG threshold is set here.

Width-adjustment limits must account for stability, lateral track loads,
traction, reference validity, actual adjustment rate, stopping/holding, and
fault recovery. The claim that rolling protects the tracks remains a validation
target, not a demonstrated behavior. Worm-only holding remains unresolved.
No automatic narrowing, homing, or restart after a fault is authorized.

The [BOM](chassis-bom.md) retains provisional material quantities and prices:
these calculations alone do not establish screw length, frame sections,
drive ratio, braking ratings, sensor ranges, or a delivered parts list.
Next evidence: pod layout, contact geometry, actual motor data, linkage/screw
dimensions, and CG/load
model, followed by competent design review. Any physical tests need separate
explicit authorization and a reviewed progressive test plan; this note
does **not** authorize approaching 40° with the prototype.

[↑ Back to document overview](width-and-slope-sizing.md#document-overview)
