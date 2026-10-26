# BOM Cost Breakdown

**Status:** generated cost view; **not released for purchase, fabrication, or operation**.

This document is generated from the [authoritative cost ledger](chassis-bom.csv)
and [module mapping](bom/cost-modules.csv). See the
[main chassis BOM](chassis-bom.md) for scope, estimate rules, alternatives,
readiness, acquisition stages, and broader budget assumptions.

Do not edit the generated tables by hand. Follow the
[cost update procedure](chassis-bom.md#updating-linked-costs).

## Major module estimates

The 48 V and 72 V columns are alternative chassis configurations, not amounts
to add together.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **Structure and running gear** | €2,213.00 | €2,213.00 |
| **Drive train** | €3,781.66 | €3,520.00 |
| **Width adjustment** | €407.00 | €407.00 |
| **Battery and charging** | €3,148.16 | €5,698.48 |
| **Power cables and electronics** | €1,679.00 | €1,679.00 |
| **Safety controls and sensors** | €2,580.00 | €2,580.00 |
| **Workshop and support** | €4,514.00 | €4,514.00 |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: overview -->

## Detailed module costs

Each row links to its itemized scope table and sourcing assumptions.

<!-- BEGIN GENERATED: modules -->
### Structure and running gear

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Rubber tracks](bom/running-gear.md#cost-tracks) | €280.00 | €280.00 |
| [Sprockets idlers rollers and tensioners](bom/running-gear.md#cost-track-hardware) | €660.00 | €660.00 |
| [Track axles bearings guides and scrapers](bom/running-gear.md#cost-track-support) | €284.00 | €284.00 |
| [Frame stock and mounting plates](bom/frame.md#cost-frame-stock) | €413.00 | €413.00 |
| [Scissor pivots locks and hard stops](bom/frame.md#cost-frame-pivots) | €196.00 | €196.00 |
| [Guards fasteners coatings and labels](bom/frame.md#cost-frame-finish) | €280.00 | €280.00 |
| [Installed lifting and recovery points](bom/frame.md#cost-handling-points) | €100.00 | €100.00 |
| **Structure and running gear subtotal** | €2,213.00 | €2,213.00 |

### Drive train

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Traction motors and included planetary where applicable](bom/propulsion.md#cost-motors) | €2,071.88 | €1,300.00 |
| [Traction motor controllers](bom/propulsion.md#cost-motor-controllers) | €1,023.24 | €1,000.00 |
| [Mechanical holding brakes](bom/propulsion.md#cost-brakes) | €446.54 | €500.00 |
| [Output hubs shafts and bearings](bom/propulsion.md#cost-output-support) | €210.00 | €210.00 |
| [External chain reduction and keys](bom/propulsion.md#cost-chain-reduction) | €30.00 | €510.00 |
| **Drive train subtotal** | €3,781.66 | €3,520.00 |

### Width adjustment

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Width motor screw bearings mounts and guard](bom/width-adjustment.md#cost-width-mechanics) | €155.00 | €155.00 |
| [Width converter driver and protected enable](bom/width-adjustment.md#cost-width-power) | €155.00 | €155.00 |
| [Width encoder limits current and reference sensors](bom/width-adjustment.md#cost-width-sensors) | €77.00 | €77.00 |
| [Width actuator harness and strain relief](bom/width-adjustment.md#cost-width-harness) | €20.00 | €20.00 |
| **Width adjustment subtotal** | €407.00 | €407.00 |

### Battery and charging

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Battery packs with integrated BMS](bom/batteries.md#cost-packs) | €2,468.16 | €4,898.48 |
| [BMS: included in pack; not separately priced](bom/batteries.md#cost-packs) | N/A - included | N/A - included |
| [Battery enclosures restraints and insulation](bom/batteries.md#cost-battery-housing) | €270.00 | €270.00 |
| [Matched battery chargers](bom/batteries.md#cost-chargers) | €320.00 | €440.00 |
| [Charge connectors fuse holders and interlock harness](bom/batteries.md#cost-charge-harness) | €90.00 | €90.00 |
| **Battery and charging subtotal** | €3,148.16 | €5,698.48 |

### Power cables and electronics

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [High-current cable](bom/cables-connectors.md#cost-power-cables) | €90.00 | €90.00 |
| [Power lugs connectors and terminal insulation](bom/cables-connectors.md#cost-power-connectors) | €168.00 | €168.00 |
| [Control and communications cables](bom/cables-connectors.md#cost-signal-cables) | €85.00 | €85.00 |
| [Signal connectors conduit clips and labels](bom/cables-connectors.md#cost-signal-connectors) | €95.00 | €95.00 |
| [Main fuses disconnects contactors and feedback](bom/electronics.md#cost-switchgear) | €710.00 | €710.00 |
| [Precharge discharge and voltage-test hardware](bom/electronics.md#cost-precharge) | €90.00 | €90.00 |
| [Control DC/DC logic supplies and branch protection](bom/electronics.md#cost-control-supplies) | €260.00 | €260.00 |
| [Electronics enclosures glands cooling and mounting](bom/electronics.md#cost-enclosures) | €181.00 | €181.00 |
| **Power cables and electronics subtotal** | €1,679.00 | €1,679.00 |

### Safety controls and sensors

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Independent safety relay E-stops and reset controls](bom/electronics.md#cost-stop-controls) | €415.00 | €415.00 |
| [Industrial operator remote and stop provision](bom/electronics.md#cost-remote) | €1,500.00 | €1,500.00 |
| [Local control boards communications and service display](bom/electronics.md#cost-control-boards) | €120.00 | €120.00 |
| [Status beacon and buzzer](bom/electronics.md#cost-status) | €30.00 | €30.00 |
| [Tilt sensing and pod or guard interlocks](bom/electronics.md#cost-tilt-interlocks) | €200.00 | €200.00 |
| [Drive current voltage temperature and speed sensors](bom/electronics.md#cost-drive-sensors) | €240.00 | €240.00 |
| [Data logger storage and reader](bom/electronics.md#cost-logging) | €75.00 | €75.00 |
| **Safety controls and sensors subtotal** | €2,580.00 | €2,580.00 |

### Workshop and support

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Loose slings straps shackles and service supports](bom/workshop.md#cost-loose-handling) | €224.00 | €224.00 |
| [Bench fixture guards and pendant](bom/workshop.md#cost-bench-fixture) | €170.00 | €170.00 |
| [Dynamometer torque measurement and adapters](bom/workshop.md#cost-dynamometer) | €3,050.00 | €3,050.00 |
| [Meters instruments hand tools and crimp tooling](bom/workshop.md#cost-bench-tools) | €500.00 | €500.00 |
| [Fabrication consumables and initial spares](bom/workshop.md#cost-consumables) | €245.00 | €245.00 |
| [PPE barriers charging surface fire and cleaning supplies](bom/workshop.md#cost-ppe-support) | €325.00 | €325.00 |
| **Workshop and support subtotal** | €4,514.00 | €4,514.00 |

### Purchase totals

| Accounting scope | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **Installed-machine materials** | €13,808.82 | €16,097.48 |
| **Reusable bench equipment** | €3,720.00 | €3,720.00 |
| **Loose handling / consumables / support** | €794.00 | €794.00 |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
| Above €5,000 materials/equipment target | €13,322.82 | €15,611.48 |
<!-- END GENERATED: modules -->
