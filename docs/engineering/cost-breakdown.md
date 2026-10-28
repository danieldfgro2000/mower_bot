# BOM Cost Breakdown

<a id="document-overview"></a>

**Status:** generated cost view; **not released for purchase, fabrication, or operation**.

**Summary:** Generated module estimates and installed/bench/support totals.
Open a cost item to inspect the part; its **Part links** lead to model data,
mounting, and connected components without returning to this table. The
[Chassis BOM](bom/chassis-bom.md) owns estimate scope and alternatives.

**On this page:** [Major estimates](cost-breakdown.md#major-module-estimates) ·
[Detailed costs](cost-breakdown.md#detailed-module-costs) ·
[Purchase totals](cost-breakdown.md#purchase-totals)

**Related documents:** [Chassis BOM](bom/chassis-bom.md) ·
[Module directory](modules/README.md) ·
[Cost ledger](bom/chassis-bom.csv) · [Module map](bom/cost-modules.csv) ·
[Update procedure](bom/updating-linked-costs.md)

Do not edit generated tables by hand.

## Major module estimates

The table contains the sole active 48 V baseline. Priced alternatives are
documented separately and are not additive purchases.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V |
| --- | ---: |
| **[01 — Structure](modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 |
| **[02 — Drive train](modules/02-drive-train/propulsion.md)** | €3,781.66 |
| **[03 — Width adjustment](modules/03-width-adjustment/width-adjustment.md)** | €407.00 |
| **[04 — Battery and charging](modules/04-battery-and-charging/batteries.md)** | €4,138.44 |
| **[05 — Power cables](modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](modules/05-power-cables-and-electronics/power-distribution.md)** | €1,679.00 |
| **[06 — Safety controls and sensors](modules/06-safety-controls-and-sensors/safety-controls.md)** | €1,045.00 |
| **[07 — Workshop and support](modules/07-workshop-and-support/workshop.md)** | €615.00 |
| **All listed materials/equipment** | €13,879.10 |
<!-- END GENERATED: overview -->

[↑ Back to document overview](cost-breakdown.md#bom-cost-breakdown)


## Detailed module costs

Each row opens an itemized scope table; item names there link to requirements
with local cost/specification/connection routes.
The [source register](bom/sources.md#source-id-lookup) owns supplier evidence,
and the [cost ledger](bom/chassis-bom.csv) owns line-specific assumptions.

For a part-first view instead of an accounting breakdown, open
[motor choices](modules/02-drive-train/propulsion.md#parts-at-a-glance),
[battery choices](modules/04-battery-and-charging/batteries.md#parts-at-a-glance), or
[workshop buy/reuse choices](modules/07-workshop-and-support/workshop.md#parts-at-a-glance).
The [HPM5000B price](modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price)
is a separate non-additive alternative, not the motor cost included below.

**Jump to costs:** [Structure and running gear](cost-breakdown.md#01--structure-and-running-gear) ·
[Drive train](cost-breakdown.md#02--drive-train) ·
[Width adjustment](cost-breakdown.md#03--width-adjustment) ·
[Battery and charging](cost-breakdown.md#04--battery-and-charging) ·
[Power cables and electronics](cost-breakdown.md#05--power-cables-and-electronics) ·
[Safety controls and sensors](cost-breakdown.md#06--safety-controls-and-sensors) ·
[Workshop and support](cost-breakdown.md#07--workshop-and-support).

<!-- BEGIN GENERATED: modules -->
### 01 — Structure and running gear

| Module / detailed BOM | 48 V |
| --- | ---: |
| [01.01 Rubber tracks](modules/01-structure-and-running-gear/running-gear.md#0101-rubber-tracks) | €280.00 |
| [01.02 Sprockets idlers rollers and tensioners](modules/01-structure-and-running-gear/running-gear.md#0102-sprockets-idlers-rollers-and-tensioners) | €660.00 |
| [01.03 Track axles bearings guides and scrapers](modules/01-structure-and-running-gear/running-gear.md#0103-track-axles-bearings-guides-and-scrapers) | €284.00 |
| [01.04 Frame stock and mounting plates](modules/01-structure-and-running-gear/frame.md#0104-frame-stock-and-mounting-plates) | €413.00 |
| [01.05 Scissor pivots locks and hard stops](modules/01-structure-and-running-gear/frame.md#0105-scissor-pivots-locks-and-hard-stops) | €196.00 |
| [01.06 Guards fasteners coatings and labels](modules/01-structure-and-running-gear/frame.md#0106-guards-fasteners-coatings-and-labels) | €280.00 |
| [01.07 Installed lifting and recovery points](modules/01-structure-and-running-gear/frame.md#0107-installed-lifting-and-recovery-points) | €100.00 |
| **01 — Structure and running gear subtotal** | €2,213.00 |

### 02 — Drive train

| Module / detailed BOM | 48 V |
| --- | ---: |
| [02.01 Traction motors and included planetary where applicable](modules/02-drive-train/propulsion.md#0201-traction-motors-and-included-planetary-where-applicable) | €2,071.88 |
| [02.02 Traction motor controllers](modules/02-drive-train/propulsion.md#0202-traction-motor-controllers) | €1,023.24 |
| [02.03 Mechanical holding brakes](modules/02-drive-train/propulsion.md#0203-mechanical-holding-brakes) | €446.54 |
| [02.04 Output hubs shafts and bearings](modules/02-drive-train/propulsion.md#0204-output-hubs-shafts-and-bearings) | €210.00 |
| [02.05 Reduction keys and fasteners](modules/02-drive-train/propulsion.md#0205-reduction-keys-and-fasteners) | €30.00 |
| **02 — Drive train subtotal** | €3,781.66 |

### 03 — Width adjustment

| Module / detailed BOM | 48 V |
| --- | ---: |
| [03.01 Width motor screw bearings mounts and guard](modules/03-width-adjustment/width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) | €155.00 |
| [03.02 Width converter driver and protected enable](modules/03-width-adjustment/width-adjustment.md#0302-width-converter-driver-and-protected-enable) | €155.00 |
| [03.03 Width encoder limits current and reference sensors](modules/03-width-adjustment/width-adjustment.md#0303-width-encoder-limits-current-and-reference-sensors) | €77.00 |
| [03.04 Width actuator harness and strain relief](modules/03-width-adjustment/width-adjustment.md#0304-width-actuator-harness-and-strain-relief) | €20.00 |
| **03 — Width adjustment subtotal** | €407.00 |

### 04 — Battery and charging

| Module / detailed BOM | 48 V |
| --- | ---: |
| [04.01 Battery packs with integrated BMS](modules/04-battery-and-charging/batteries.md#0401-battery-packs-with-integrated-bms) | €3,455.10 |
| [BMS: included in pack; not separately priced](modules/04-battery-and-charging/batteries.md#0401-battery-packs-with-integrated-bms) | N/A - included |
| [04.02 Battery enclosures restraints and insulation](modules/04-battery-and-charging/batteries.md#0402-battery-enclosures-restraints-and-insulation) | €270.00 |
| [04.03 Matched battery chargers](modules/04-battery-and-charging/batteries.md#0403-matched-battery-chargers) | €323.34 |
| [04.04 Charge connectors fuse holders and interlock harness](modules/04-battery-and-charging/batteries.md#0404-charge-connectors-fuse-holders-and-interlock-harness) | €90.00 |
| **04 — Battery and charging subtotal** | €4,138.44 |

### 05 — Power cables and electronics

| Module / detailed BOM | 48 V |
| --- | ---: |
| [05.01 High-current cable](modules/05-power-cables-and-electronics/cables-connectors.md#0501-high-current-cable) | €90.00 |
| [05.02 Power lugs connectors and terminal insulation](modules/05-power-cables-and-electronics/cables-connectors.md#0502-power-lugs-connectors-and-terminal-insulation) | €168.00 |
| [05.03 Control and communications cables](modules/05-power-cables-and-electronics/cables-connectors.md#0503-control-and-communications-cables) | €85.00 |
| [05.04 Signal connectors conduit clips and labels](modules/05-power-cables-and-electronics/cables-connectors.md#0504-signal-connectors-conduit-clips-and-labels) | €95.00 |
| [05.05 Main fuses disconnects contactors and feedback](modules/05-power-cables-and-electronics/power-distribution.md#0505-main-fuses-disconnects-contactors-and-feedback) | €710.00 |
| [05.06 Precharge discharge and voltage-test hardware](modules/05-power-cables-and-electronics/power-distribution.md#0506-precharge-discharge-and-voltage-test-hardware) | €90.00 |
| [05.07 Control DC/DC logic supplies and branch protection](modules/05-power-cables-and-electronics/power-distribution.md#0507-control-dcdc-logic-supplies-and-branch-protection) | €260.00 |
| [05.08 Electronics enclosures glands cooling and mounting](modules/05-power-cables-and-electronics/power-distribution.md#0508-electronics-enclosures-glands-cooling-and-mounting) | €181.00 |
| **05 — Power cables and electronics subtotal** | €1,679.00 |

### 06 — Safety controls and sensors

| Module / detailed BOM | 48 V |
| --- | ---: |
| [06.01 Independent safety relay E-stops and reset controls](modules/06-safety-controls-and-sensors/safety-controls.md#0601-independent-safety-relay-e-stops-and-reset-controls) | €380.00 |
| [06.03 Local control boards communications and service display](modules/06-safety-controls-and-sensors/safety-controls.md#0603-local-control-boards-communications-and-service-display) | €120.00 |
| [06.04 Status beacon and buzzer](modules/06-safety-controls-and-sensors/safety-controls.md#0604-status-beacon-and-buzzer) | €30.00 |
| [06.05 Tilt sensing and pod or guard interlocks](modules/06-safety-controls-and-sensors/safety-controls.md#0605-tilt-sensing-and-pod-or-guard-interlocks) | €200.00 |
| [06.06 Drive current voltage temperature and speed sensors](modules/06-safety-controls-and-sensors/safety-controls.md#0606-drive-current-voltage-temperature-and-speed-sensors) | €240.00 |
| [06.07 Data logger storage and reader](modules/06-safety-controls-and-sensors/safety-controls.md#0607-data-logger-storage-and-reader) | €75.00 |
| **06 — Safety controls and sensors subtotal** | €1,045.00 |

### 07 — Workshop and support

| Module / detailed BOM | 48 V |
| --- | ---: |
| [07.01 Loose transport straps and service supports](modules/07-workshop-and-support/workshop.md#0701-loose-transport-straps-and-service-supports) | N/A |
| [07.02 Bench fixture and guards](modules/07-workshop-and-support/workshop.md#0702-bench-fixture-and-guards) | €135.00 |
| [07.04 Meters instruments hand tools and crimp tooling](modules/07-workshop-and-support/workshop.md#0704-meters-instruments-hand-tools-and-crimp-tooling) | €150.00 |
| [07.05 Fabrication consumables and initial spares](modules/07-workshop-and-support/workshop.md#0705-fabrication-consumables-and-initial-spares) | €170.00 |
| [07.06 PPE deferred fire provision and cleaning supplies](modules/07-workshop-and-support/workshop.md#0706-ppe-deferred-fire-provision-and-cleaning-supplies) | €160.00 |
| **07 — Workshop and support subtotal** | €615.00 |

### Purchase totals

| Accounting scope | 48 V |
| --- | ---: |
| **Installed-machine materials** | €13,264.10 |
| **Reusable bench equipment** | €285.00 |
| **Loose handling / consumables / support** | €330.00 |
| **All listed materials/equipment** | €13,879.10 |
| Above €5,000 materials/equipment target | €8,879.10 |
<!-- END GENERATED: modules -->

[↑ Back to document overview](cost-breakdown.md#bom-cost-breakdown)
