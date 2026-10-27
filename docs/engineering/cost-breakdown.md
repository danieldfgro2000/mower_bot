# BOM Cost Breakdown

<a id="document-overview"></a>

**Status:** generated cost view; **not released for purchase, fabrication, or operation**.

**Summary:** Generated module estimates and installed/bench/support totals.
The [Chassis BOM](bom/chassis-bom.md) owns scope and alternatives; cost rows link to
the technical scopes. Tables come from the
[cost ledger](bom/chassis-bom.csv) and [module map](bom/cost-modules.csv).

**Navigate:** [Major estimates](cost-breakdown.md#major-module-estimates) ·
[Detailed costs](cost-breakdown.md#detailed-module-costs) ·
[Purchase totals](cost-breakdown.md#purchase-totals) |
[Chassis BOM](bom/chassis-bom.md) · [Cost ledger](bom/chassis-bom.csv) ·
[Update procedure](bom/updating-linked-costs.md)

Do not edit generated tables by hand.

## Major module estimates

The 48 V and 72 V columns are alternative chassis configurations, not amounts
to add together.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **[01 — Structure](modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 | Same as 48 V |
| **[02 — Drive train](modules/02-drive-train/propulsion.md)** | €3,781.66 | €3,520.00 |
| **[03 — Width adjustment](modules/03-width-adjustment/width-adjustment.md)** | €407.00 | Same as 48 V |
| **[04 — Battery and charging](modules/04-battery-and-charging/batteries.md)** | €3,148.16 | €5,698.48 |
| **[05 — Power cables](modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](modules/05-power-cables-and-electronics/power-distribution.md)** | €1,679.00 | Same as 48 V |
| **[06 — Safety controls and sensors](modules/06-safety-controls-and-sensors/safety-controls.md)** | €2,580.00 | Same as 48 V |
| **[07 — Workshop and support](modules/07-workshop-and-support/workshop.md)** | €4,514.00 | Same as 48 V |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: overview -->

[↑ Back to document overview](cost-breakdown.md#document-overview)


## Detailed module costs

Each row links to its itemized scope table and sourcing assumptions.

<!-- BEGIN GENERATED: modules -->
### 01 — Structure and running gear

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [01.01 Rubber tracks](modules/01-structure-and-running-gear/running-gear.md#cost-tracks) | €280.00 |
| [01.02 Sprockets idlers rollers and tensioners](modules/01-structure-and-running-gear/running-gear.md#cost-track-hardware) | €660.00 |
| [01.03 Track axles bearings guides and scrapers](modules/01-structure-and-running-gear/running-gear.md#cost-track-support) | €284.00 |
| [01.04 Frame stock and mounting plates](modules/01-structure-and-running-gear/frame.md#cost-frame-stock) | €413.00 |
| [01.05 Scissor pivots locks and hard stops](modules/01-structure-and-running-gear/frame.md#cost-frame-pivots) | €196.00 |
| [01.06 Guards fasteners coatings and labels](modules/01-structure-and-running-gear/frame.md#cost-frame-finish) | €280.00 |
| [01.07 Installed lifting and recovery points](modules/01-structure-and-running-gear/frame.md#cost-handling-points) | €100.00 |
| **01 — Structure and running gear subtotal** | €2,213.00 |

### 02 — Drive train

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [02.01 Traction motors and included planetary where applicable](modules/02-drive-train/propulsion.md#cost-motors) | €2,071.88 | €1,300.00 |
| [02.02 Traction motor controllers](modules/02-drive-train/propulsion.md#cost-motor-controllers) | €1,023.24 | €1,000.00 |
| [02.03 Mechanical holding brakes](modules/02-drive-train/propulsion.md#cost-brakes) | €446.54 | €500.00 |
| [02.04 Output hubs shafts and bearings](modules/02-drive-train/propulsion.md#cost-output-support) | €210.00 | Same as 48 V |
| [02.05 External chain reduction and keys](modules/02-drive-train/propulsion.md#cost-chain-reduction) | €30.00 | €510.00 |
| **02 — Drive train subtotal** | €3,781.66 | €3,520.00 |

### 03 — Width adjustment

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [03.01 Width motor screw bearings mounts and guard](modules/03-width-adjustment/width-adjustment.md#cost-width-mechanics) | €155.00 |
| [03.02 Width converter driver and protected enable](modules/03-width-adjustment/width-adjustment.md#cost-width-power) | €155.00 |
| [03.03 Width encoder limits current and reference sensors](modules/03-width-adjustment/width-adjustment.md#cost-width-sensors) | €77.00 |
| [03.04 Width actuator harness and strain relief](modules/03-width-adjustment/width-adjustment.md#cost-width-harness) | €20.00 |
| **03 — Width adjustment subtotal** | €407.00 |

### 04 — Battery and charging

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [04.01 Battery packs with integrated BMS](modules/04-battery-and-charging/batteries.md#cost-packs) | €2,468.16 | €4,898.48 |
| [BMS: included in pack; not separately priced](modules/04-battery-and-charging/batteries.md#cost-packs) | N/A - included | Same as 48 V |
| [04.02 Battery enclosures restraints and insulation](modules/04-battery-and-charging/batteries.md#cost-battery-housing) | €270.00 | Same as 48 V |
| [04.03 Matched battery chargers](modules/04-battery-and-charging/batteries.md#cost-chargers) | €320.00 | €440.00 |
| [04.04 Charge connectors fuse holders and interlock harness](modules/04-battery-and-charging/batteries.md#cost-charge-harness) | €90.00 | Same as 48 V |
| **04 — Battery and charging subtotal** | €3,148.16 | €5,698.48 |

### 05 — Power cables and electronics

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [05.01 High-current cable](modules/05-power-cables-and-electronics/cables-connectors.md#cost-power-cables) | €90.00 |
| [05.02 Power lugs connectors and terminal insulation](modules/05-power-cables-and-electronics/cables-connectors.md#cost-power-connectors) | €168.00 |
| [05.03 Control and communications cables](modules/05-power-cables-and-electronics/cables-connectors.md#cost-signal-cables) | €85.00 |
| [05.04 Signal connectors conduit clips and labels](modules/05-power-cables-and-electronics/cables-connectors.md#cost-signal-connectors) | €95.00 |
| [05.05 Main fuses disconnects contactors and feedback](modules/05-power-cables-and-electronics/power-distribution.md#cost-switchgear) | €710.00 |
| [05.06 Precharge discharge and voltage-test hardware](modules/05-power-cables-and-electronics/power-distribution.md#cost-precharge) | €90.00 |
| [05.07 Control DC/DC logic supplies and branch protection](modules/05-power-cables-and-electronics/power-distribution.md#cost-control-supplies) | €260.00 |
| [05.08 Electronics enclosures glands cooling and mounting](modules/05-power-cables-and-electronics/power-distribution.md#cost-enclosures) | €181.00 |
| **05 — Power cables and electronics subtotal** | €1,679.00 |

### 06 — Safety controls and sensors

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [06.01 Independent safety relay E-stops and reset controls](modules/06-safety-controls-and-sensors/safety-controls.md#cost-stop-controls) | €415.00 |
| [06.02 Industrial operator remote and stop provision](modules/06-safety-controls-and-sensors/safety-controls.md#cost-remote) | €1,500.00 |
| [06.03 Local control boards communications and service display](modules/06-safety-controls-and-sensors/safety-controls.md#cost-control-boards) | €120.00 |
| [06.04 Status beacon and buzzer](modules/06-safety-controls-and-sensors/safety-controls.md#cost-status) | €30.00 |
| [06.05 Tilt sensing and pod or guard interlocks](modules/06-safety-controls-and-sensors/safety-controls.md#cost-tilt-interlocks) | €200.00 |
| [06.06 Drive current voltage temperature and speed sensors](modules/06-safety-controls-and-sensors/safety-controls.md#cost-drive-sensors) | €240.00 |
| [06.07 Data logger storage and reader](modules/06-safety-controls-and-sensors/safety-controls.md#cost-logging) | €75.00 |
| **06 — Safety controls and sensors subtotal** | €2,580.00 |

### 07 — Workshop and support

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [07.01 Loose slings straps shackles and service supports](modules/07-workshop-and-support/workshop.md#cost-loose-handling) | €224.00 |
| [07.02 Bench fixture guards and pendant](modules/07-workshop-and-support/workshop.md#cost-bench-fixture) | €170.00 |
| [07.03 Dynamometer torque measurement and adapters](modules/07-workshop-and-support/workshop.md#cost-dynamometer) | €3,050.00 |
| [07.04 Meters instruments hand tools and crimp tooling](modules/07-workshop-and-support/workshop.md#cost-bench-tools) | €500.00 |
| [07.05 Fabrication consumables and initial spares](modules/07-workshop-and-support/workshop.md#cost-consumables) | €245.00 |
| [07.06 PPE barriers charging surface fire and cleaning supplies](modules/07-workshop-and-support/workshop.md#cost-ppe-support) | €325.00 |
| **07 — Workshop and support subtotal** | €4,514.00 |

### Purchase totals

| Accounting scope | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **Installed-machine materials** | €13,808.82 | €16,097.48 |
| **Reusable bench equipment** | €3,720.00 | Same as 48 V |
| **Loose handling / consumables / support** | €794.00 | Same as 48 V |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
| Above €5,000 materials/equipment target | €13,322.82 | €15,611.48 |
<!-- END GENERATED: modules -->

[↑ Back to document overview](cost-breakdown.md#document-overview)
