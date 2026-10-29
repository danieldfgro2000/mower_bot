# Engineering Modules

<a id="document-overview"></a>

**Summary:** Start with the physical part you want to inspect. Each scope page
is self-contained: choices, prices, specifications, sourcing, supplier
evidence, decision records, procurement packages and release holds for that
scope live on the same page. Study directions are not approved or installed
selections.

**On this page:** [Module directory](README.md#module-directory) ·
[Reading a module](README.md#reading-a-module)

**Related documents:** [Chassis BOM](../bom/chassis-bom.md) ·
[BOM Cost Breakdown](../cost-breakdown.md) ·
[Chassis BOM scope directory](../bom/chassis-bom.md#bom-by-scope) ·
[Engineering BOM agent index](../../agents/agent-index.md)

## Module directory

| Part family / module | Scan parts and current choices | Follow the connection |
| --- | --- | --- |
| Tracks and frame — Module 01: [running gear](01-structure-and-running-gear/running-gear.md) · [frame](01-structure-and-running-gear/frame.md) | [Track, drum and rollers](01-structure-and-running-gear/running-gear.md#parts-at-a-glance) · [Frame and holding parts](01-structure-and-running-gear/frame.md#parts-at-a-glance) | [Drive drum to motor](02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Motors and brakes — Module 02](02-drive-train/propulsion.md) | [Motor choices, prices and specifications](02-drive-train/propulsion.md#parts-at-a-glance) | [Motor-to-track mounting](02-drive-train/propulsion.md#motor-to-track-mounting) · [Frame-side plates](01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) |
| [Width mechanism — Module 03](03-width-adjustment/width-adjustment.md) | [Motor, screw, driver and feedback](03-width-adjustment/width-adjustment.md#parts-at-a-glance) | [Screw and supports](03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) → [scissor pivots](01-structure-and-running-gear/frame.md#ps05-scissor-pivots) |
| [Battery and charging — Module 04](04-battery-and-charging/batteries.md) | [Packs, BMS, enclosures and chargers](04-battery-and-charging/batteries.md#parts-at-a-glance) | [Battery-to-pod fit](04-battery-and-charging/batteries.md#battery-to-pod-fit) |
| Wiring and power — Module 05: [cables](05-power-cables-and-electronics/cables-connectors.md) · [distribution](05-power-cables-and-electronics/power-distribution.md) | [Cables/connectors](05-power-cables-and-electronics/cables-connectors.md#parts-at-a-glance) · [Protection, supplies and boxes](05-power-cables-and-electronics/power-distribution.md#parts-at-a-glance) | [Connector to crimp tool](07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) · [Controller interface](02-drive-train/propulsion.md#ps14-traction-motor-and-controller) |
| [Controls and sensors — Module 06](06-safety-controls-and-sensors/safety-controls.md) | [Stop hardware, boards, interlocks and logger](06-safety-controls-and-sensors/safety-controls.md#parts-at-a-glance) | [Stop path to brake](02-drive-train/propulsion.md#ps15-mechanical-brakes) · [Logger to bench observations](07-workshop-and-support/workshop.md#test-method-and-evidence) |
| [Workshop equipment — Module 07](07-workshop-and-support/workshop.md) | [Tools, fixture, supports and supplies](07-workshop-and-support/workshop.md#parts-at-a-glance) | [Fixture to drive interfaces](02-drive-train/propulsion.md#motor-to-track-mounting) · [Straps to frame points](01-structure-and-running-gear/frame.md#ps32-installed-lifting-and-recovery-points) |

## Reading a module

Every scope page follows the same top-down order, so data for one part family
is found without leaving the page:

1. **Summary** and **Parts at a glance**: current choices, prices and links.
2. Design studies, alternatives and module-specific sizing.
3. **Specification and inspection requirements** (PS IDs).
4. **Sourcing**, then **Procurement and release holds** (Q and H IDs owned by
   this scope).
5. **Interfaces with other scopes**.
6. **Detailed module costs** (generated; do not hand-edit).
7. **Decision records** (F and L IDs owned by this scope).
8. **Supplier evidence** (S and U entries used only by this scope).

Catalogs shared by several modules (S04, S06, S07), sourcing weights and the
full source-ID lookup stay in [Sources](../bom/sources.md). Cross-module
decisions stay in [Feedback](../bom/feedback.md), and hold points without a
single owning scope stay in the
[build requirements](../chassis-build-requirements.md#5-close-release-hold-points).

Once inside a detail, **Part links** or **Continue** leads to the adjoining
part without returning to this directory.

For example: [HPM5000B](02-drive-train/propulsion.md#hpm5000b-main-motor-candidate)
→ [price](02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price)
or [specifications](02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits)
→ [motor-to-track mounting](02-drive-train/propulsion.md#motor-to-track-mounting)
→ [frame-side plates](01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates).
The HPM5000B is the main cost/study candidate, not qualified hardware.

Requirement IDs remain secondary references. Generated cost-item links open
their requirement family, where the component links continue the same route.
Supplier links are evidence, not approved substitutions.

The [Chassis BOM](../bom/chassis-bom.md) owns the estimate. All scopes remain
subject to the [purchase/build holds](../chassis-build-requirements.md#5-close-release-hold-points).

[↑ Back to module overview](README.md#engineering-modules)
