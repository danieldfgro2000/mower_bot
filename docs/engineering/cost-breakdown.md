# BOM Cost Breakdown

<a id="document-overview"></a>

**Status:** generated cost view; **not released for purchase, fabrication, or operation**.

**Summary:** Generated module estimates and installed/bench/support totals.
The [Chassis BOM](chassis-bom.md) owns scope and alternatives; cost rows link to
the technical scopes. Tables come from the
[cost ledger](chassis-bom.csv) and [module map](bom/cost-modules.csv).

**Navigate:** [Major estimates](cost-breakdown.md#major-module-estimates) ·
[Detailed costs](cost-breakdown.md#detailed-module-costs) ·
[Purchase totals](cost-breakdown.md#purchase-totals) |
[Chassis BOM](chassis-bom.md) · [Cost ledger](chassis-bom.csv) ·
[Update procedure](bom/updating-linked-costs.md)

Do not edit generated tables by hand.

## Major module estimates

The 48 V and 72 V columns are alternative chassis configurations, not amounts
to add together.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **[01 — Structure](bom/frame.md) and [01 — Running gear](bom/running-gear.md)** | €2,213.00 | Same as 48 V |
| **[02 — Drive train](bom/propulsion.md)** | €3,781.66 | €3,520.00 |
| **[03 — Width adjustment](bom/width-adjustment.md)** | €407.00 | Same as 48 V |
| **[04 — Battery and charging](bom/batteries.md)** | €3,148.16 | €5,698.48 |
| **[05 — Power cables](bom/cables-connectors.md) and [05 — Electronics](bom/electronics.md)** | €1,679.00 | Same as 48 V |
| **[06 — Safety controls and sensors](bom/electronics.md)** | €2,580.00 | Same as 48 V |
| **[07 — Workshop and support](bom/workshop.md)** | €4,514.00 | Same as 48 V |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: overview -->

[↑ Back to document overview](cost-breakdown.md#document-overview)


## Detailed module costs

Each row links to its itemized scope table and sourcing assumptions.

<!-- BEGIN GENERATED: modules -->
### 01 — Structure and running gear

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [01.01 Rubber tracks](bom/running-gear.md#cost-tracks) | €280.00 |
| [01.02 Sprockets idlers rollers and tensioners](bom/running-gear.md#cost-track-hardware) | €660.00 |
| [01.03 Track axles bearings guides and scrapers](bom/running-gear.md#cost-track-support) | €284.00 |
| [01.04 Frame stock and mounting plates](bom/frame.md#cost-frame-stock) | €413.00 |
| [01.05 Scissor pivots locks and hard stops](bom/frame.md#cost-frame-pivots) | €196.00 |
| [01.06 Guards fasteners coatings and labels](bom/frame.md#cost-frame-finish) | €280.00 |
| [01.07 Installed lifting and recovery points](bom/frame.md#cost-handling-points) | €100.00 |
| **01 — Structure and running gear subtotal** | €2,213.00 |

### 02 — Drive train

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [02.01 Traction motors and included planetary where applicable](bom/propulsion.md#cost-motors) | €2,071.88 | €1,300.00 |
| [02.02 Traction motor controllers](bom/propulsion.md#cost-motor-controllers) | €1,023.24 | €1,000.00 |
| [02.03 Mechanical holding brakes](bom/propulsion.md#cost-brakes) | €446.54 | €500.00 |
| [02.04 Output hubs shafts and bearings](bom/propulsion.md#cost-output-support) | €210.00 | Same as 48 V |
| [02.05 External chain reduction and keys](bom/propulsion.md#cost-chain-reduction) | €30.00 | €510.00 |
| **02 — Drive train subtotal** | €3,781.66 | €3,520.00 |

### 03 — Width adjustment

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [03.01 Width motor screw bearings mounts and guard](bom/width-adjustment.md#cost-width-mechanics) | €155.00 |
| [03.02 Width converter driver and protected enable](bom/width-adjustment.md#cost-width-power) | €155.00 |
| [03.03 Width encoder limits current and reference sensors](bom/width-adjustment.md#cost-width-sensors) | €77.00 |
| [03.04 Width actuator harness and strain relief](bom/width-adjustment.md#cost-width-harness) | €20.00 |
| **03 — Width adjustment subtotal** | €407.00 |

### 04 — Battery and charging

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [04.01 Battery packs with integrated BMS](bom/batteries.md#cost-packs) | €2,468.16 | €4,898.48 |
| [BMS: included in pack; not separately priced](bom/batteries.md#cost-packs) | N/A - included | Same as 48 V |
| [04.02 Battery enclosures restraints and insulation](bom/batteries.md#cost-battery-housing) | €270.00 | Same as 48 V |
| [04.03 Matched battery chargers](bom/batteries.md#cost-chargers) | €320.00 | €440.00 |
| [04.04 Charge connectors fuse holders and interlock harness](bom/batteries.md#cost-charge-harness) | €90.00 | Same as 48 V |
| **04 — Battery and charging subtotal** | €3,148.16 | €5,698.48 |

### 05 — Power cables and electronics

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [05.01 High-current cable](bom/cables-connectors.md#cost-power-cables) | €90.00 |
| [05.02 Power lugs connectors and terminal insulation](bom/cables-connectors.md#cost-power-connectors) | €168.00 |
| [05.03 Control and communications cables](bom/cables-connectors.md#cost-signal-cables) | €85.00 |
| [05.04 Signal connectors conduit clips and labels](bom/cables-connectors.md#cost-signal-connectors) | €95.00 |
| [05.05 Main fuses disconnects contactors and feedback](bom/electronics.md#cost-switchgear) | €710.00 |
| [05.06 Precharge discharge and voltage-test hardware](bom/electronics.md#cost-precharge) | €90.00 |
| [05.07 Control DC/DC logic supplies and branch protection](bom/electronics.md#cost-control-supplies) | €260.00 |
| [05.08 Electronics enclosures glands cooling and mounting](bom/electronics.md#cost-enclosures) | €181.00 |
| **05 — Power cables and electronics subtotal** | €1,679.00 |

### 06 — Safety controls and sensors

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [06.01 Independent safety relay E-stops and reset controls](bom/electronics.md#cost-stop-controls) | €415.00 |
| [06.02 Industrial operator remote and stop provision](bom/electronics.md#cost-remote) | €1,500.00 |
| [06.03 Local control boards communications and service display](bom/electronics.md#cost-control-boards) | €120.00 |
| [06.04 Status beacon and buzzer](bom/electronics.md#cost-status) | €30.00 |
| [06.05 Tilt sensing and pod or guard interlocks](bom/electronics.md#cost-tilt-interlocks) | €200.00 |
| [06.06 Drive current voltage temperature and speed sensors](bom/electronics.md#cost-drive-sensors) | €240.00 |
| [06.07 Data logger storage and reader](bom/electronics.md#cost-logging) | €75.00 |
| **06 — Safety controls and sensors subtotal** | €2,580.00 |

### 07 — Workshop and support

| Module / detailed BOM | Total (both variants) |
| --- | ---: |
| [07.01 Loose slings straps shackles and service supports](bom/workshop.md#cost-loose-handling) | €224.00 |
| [07.02 Bench fixture guards and pendant](bom/workshop.md#cost-bench-fixture) | €170.00 |
| [07.03 Dynamometer torque measurement and adapters](bom/workshop.md#cost-dynamometer) | €3,050.00 |
| [07.04 Meters instruments hand tools and crimp tooling](bom/workshop.md#cost-bench-tools) | €500.00 |
| [07.05 Fabrication consumables and initial spares](bom/workshop.md#cost-consumables) | €245.00 |
| [07.06 PPE barriers charging surface fire and cleaning supplies](bom/workshop.md#cost-ppe-support) | €325.00 |
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
