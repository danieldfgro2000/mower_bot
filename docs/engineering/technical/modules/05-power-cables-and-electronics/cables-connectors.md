# Cables, connectors and harnesses

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Inspect a cable or connector, then follow the device at either
end and the tooling needed to assemble it. Sizes, pin maps, complete mating
parts, and routing remain unselected; quantities are not a harness cut list.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Connects to / assembly detail |
| --- | --- | --- | --- |
| [High-current cable](cables-connectors.md#ps23-high-current-harness) | Length allowance only; conductor section/derating open | [Cable cost](cables-connectors.md#0501-high-current-cable) · [Cable requirements](cables-connectors.md#ps23-high-current-harness) | [Battery terminals](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) · [Fuse and disconnect](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| [Lugs and power connectors](cables-connectors.md#ps23-high-current-harness) | No exact MPN, contact or seal set selected | [Connector/insulation costs](cables-connectors.md#0502-power-lugs-connectors-and-terminal-insulation) · [Mating/crimp requirements](cables-connectors.md#ps23-high-current-harness) | [Crimp tools and dies](../07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) · [Controller terminals](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) |
| [Signal cable and connectors](cables-connectors.md#ps26-signal-harness-and-communications) | Pin maps, shielding and moving-loop geometry open | [Cable costs](cables-connectors.md#0503-control-and-communications-cables) · [Connectors/routing costs](cables-connectors.md#0504-signal-connectors-conduit-clips-and-labels) · [Signal requirements](cables-connectors.md#ps26-signal-harness-and-communications) | [Control boards](../06-safety-controls-and-sensors/safety-controls.md#ps29-normal-control-and-diagnostics) · [Sensors/logger](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) |
| Charge and width-drive harnesses | Owned and budgeted in their respective scopes, not added here | [Charge harness](../04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) · [Width harness](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) | [Charge interlock](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) · [Moving scissor mechanism](../01-structure-and-running-gear/frame.md#ps05-scissor-pivots) |

**Further detail:** [Release requirements](cables-connectors.md#specification-and-inspection-requirements) ·
[Sourcing](cables-connectors.md#sourcing) ·
[Interfaces](cables-connectors.md#interfaces-with-other-scopes) ·
[Itemized costs](cables-connectors.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS23: High-current harness

**Cost-ledger coverage:** PWR-008:PWR-011

**Part links:** [Cable cost](cables-connectors.md#0501-high-current-cable) ·
[Connector/insulation costs](cables-connectors.md#0502-power-lugs-connectors-and-terminal-insulation) ·
[Fuse coordination](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) ·
[Crimp tool compatibility](../07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools).

**Required purchasing/manufacturing definition:** Cable
section/insulation/temperature/flex class, lengths and derating; lug/terminal/stud
compatibility, connector complete mating BOM and full-voltage DC rating; crimp tooling
and terminal insulation

**Receiving or first-article evidence:** Harness drawing/cut list, crimp process
evidence and specified pull checks, continuity/polarity, strain relief and tightening
records; no universal wire size or fuse rating inferred from motor kW

### PS26: Signal harness and communications

**Cost-ledger coverage:** PWR-017:PWR-020

**Part links:** [Signal-cable costs](cables-connectors.md#0503-control-and-communications-cables) ·
[Connector/routing costs](cables-connectors.md#0504-signal-connectors-conduit-clips-and-labels) ·
[Sensor connections](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) ·
[Moving width harness](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard).

**Required purchasing/manufacturing definition:** Signal wire size, shielding/bonding,
topology/termination, connector pin maps and unused-cavity seals; moving-loop bend
radius/flex life, clips/labels and protected service loops

**Receiving or first-article evidence:** Pin-to-pin record, shield/ground inspection,
full-travel routing check and defined communications fault evidence; separate safety and
normal control as designed

[↑ Back to document overview](cables-connectors.md#cables-connectors-and-harnesses)


## Sourcing

[RS Romania cables, connectors and tools (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](cables-connectors.md#cables-connectors-and-harnesses)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Cable protection and power switching | [Main fuses, disconnects and contactors](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| Stop circuits versus normal control wiring | [Independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Moving width-drive wiring | [Width harness and screw guard](../03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) |
| Charge connectors and motion inhibit | [Charging and charge interlocks](../04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) |

[↑ Back to document overview](cables-connectors.md#cables-connectors-and-harnesses)

## Detailed module costs

**Cost context:** [Module 05 totals](../../cost-breakdown.md#05--power-cables-and-electronics) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-power-cables"></a>

### 05.01 High-current cable

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-008 - High-current cable](cables-connectors.md#ps23-high-current-harness) (10 m) | €90.00 / A |
| **Module subtotal** | €90.00 |

<a id="cost-power-connectors"></a>

### 05.02 Power lugs connectors and terminal insulation

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-009 - Power cable lugs](cables-connectors.md#ps23-high-current-harness) (24 each) | €48.00 / A |
| [PWR-010 - High-current sealed connector](cables-connectors.md#ps23-high-current-harness) (4 pair) | €100.00 / A |
| [PWR-011 - Power insulation heat-shrink and terminal boots](cables-connectors.md#ps23-high-current-harness) (1 lot) | €20.00 / A |
| **Module subtotal** | €168.00 |

<a id="cost-signal-cables"></a>

### 05.03 Control and communications cables

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-017 - Low-voltage control wire](cables-connectors.md#ps26-signal-harness-and-communications) (50 m) | €40.00 / A |
| [PWR-018 - Shielded communications cable](cables-connectors.md#ps26-signal-harness-and-communications) (15 m) | €45.00 / A |
| **Module subtotal** | €85.00 |

<a id="cost-signal-connectors"></a>

### 05.04 Signal connectors conduit clips and labels

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-019 - Sealed signal connectors](cables-connectors.md#ps26-signal-harness-and-communications) (12 pair) | €60.00 / A |
| [PWR-020 - Conduit loom P-clips ties and wire labels](cables-connectors.md#ps26-signal-harness-and-communications) (1 lot) | €35.00 / A |
| **Module subtotal** | €95.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €438.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](cables-connectors.md#cables-connectors-and-harnesses)
