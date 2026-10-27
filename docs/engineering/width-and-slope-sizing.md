# Width and Slope Feasibility Screen

<a id="document-overview"></a>

**Date:** 2026-10-26 | **Status:** preliminary calculations, not operating limits,
fabrication dimensions, a structural analysis, or a machine safety assessment.

**Summary:** At the 400 mm outside-track target, 200 mm tracks leave no
central gap; the referenced low-height battery layout needs 538 mm for two pod
interiors. An illustrative 36-link track loop needs about 1,182 mm pitch length
at a 100 mm turn radius, so an 800 mm complete pod length is unsupported. The
40° site expectation remains unapproved because CG, contact geometry, traction,
braking, and continuous drive capability are unresolved. This screen establishes
no safe width, slope, or speed.

**Navigate:** [Inputs](width-and-slope-sizing.md#inputs-and-unresolved-definitions) ·
[Packaging](width-and-slope-sizing.md#minimum-width-and-packaging) ·
[Track length](width-and-slope-sizing.md#track-length-check) ·
[Tipping](width-and-slope-sizing.md#lateral-static-tipping-screen) ·
[Traction and holding](width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates) ·
[Design implications](width-and-slope-sizing.md#consequences-for-the-design-and-bom) |
[Product authority](../../plan.md#42-variable-width-scissor-frame) ·
[Cost breakdown](cost-breakdown.md) ·
[Feedback decisions](bom/feedback.md#feedback-decisions) ·
[Width-adjustment scope](bom/width-adjustment.md)

## Inputs and unresolved definitions

| Input | Value / evidence status |
| --- | --- |
| Track | Plan target 200 mm wide × 72 mm pitch × 36 links; exact track/undercarriage not qualified |
| Minimum outside-track width | Owner aspiration **400 mm**; explicitly subject to mechanical limitations, not a released width |
| Maximum outside-track width | Owner study target **1,600 mm**; not demonstrated stability |
| Suggested width/length ratio | Owner suggested about 2:1; **not a stability criterion** and does not establish an 800 mm finished machine length |
| Site inclination | Owner expects up to **40°**, both uphill/downhill and cross-slope travel; operating envelope unresolved, not an approved slope |
| Slope speed | Owner accepts reducing speed below the plan's normal-condition 4 km/h target; no numeric safe slope speed is established |
| Mass | Plan's provisional 300 kg normal / 450 kg loaded cases, not measured |
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

The target pitch-loop length is `72 × 36 = 2,592 mm`. For an illustrative
two-equal-wheel oval pitch path with radius `r` and wheel-centre separation `a`:

`2,592 = 2a + 2πr`; longitudinal pitch envelope `E = a + 2r`.

At **r = 100 mm**, `a ≈ 981.8 mm` and `E ≈ 1,181.8 mm`, before actual tread
thickness and structural overhangs. This is **not** the selected sprocket size
or layout. It shows why an 800 mm complete pod length must not be inferred
from the proposed 1,600 mm width or a width/length ratio. Actual roller/idler
geometry and wrap determine the envelope.

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

| Assumed mass | Uphill gravity force at 40° | Torque per track at illustrative r = 0.10 m |
| --- | ---: | ---: |
| 300 kg | 1,891.7 N | 94.6 Nm |
| 450 kg | 2,837.6 N | 141.9 Nm |

The radius is **not selected**. Even this loss-free example exceeds the plan's
70–80 Nm continuous target. A short peak rating cannot satisfy a continuous
climb or parking hold; braking/holding and full-SOC downhill behavior require
separate design evidence. Longitudinal tipping depends on **ground-contact
length and fore/aft CG**, not lateral width; none is established here.

### Effect of accepting reduced speed

With `g = 9.81 m/s²`, gravity-only climbing power is `P = F × v` for the
**whole machine**. The following speeds are arithmetic examples, not approved
presets; torque in the preceding table is unchanged at either speed.

| Assumed mass | Gravity-only track power at 4 km/h | Gravity-only track power at 2 km/h |
| --- | ---: | ---: |
| 300 kg | 2.10 kW | 1.05 kW |
| 450 kg | 3.15 kW | 1.58 kW |

These exclude rolling/soil resistance, steering, acceleration, reduction and
motor/controller losses, and all implement loads. They do not prove either
motor package can climb continuously. Simply commanding a lower motor rpm
does **not** increase its continuous rated torque; lower-speed thermal behavior
also requires confirmation. A different reduction can trade output speed for
torque, subject to all component ratings.

The BOM's illustrative 48 V 16:1 reduction yields about 86.6 Nm at assumed 85%
mechanical efficiency, below even the 300 kg gravity-only example. Its 72 V
10:1 example yields about 125.9 Nm, below the 450 kg case. **Neither example
ratio is established for the 40° target.** Revisit the provisional output-rpm
and torque targets together rather than selecting by nominal voltage or kW.

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
