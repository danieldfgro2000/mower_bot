# Power distribution and enclosures

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Follow power from the battery through protection to the drive
and control supplies, then inspect enclosure and cooling interfaces. This is
a requirements map, not a released schematic; no rated device is selected.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Connects to / mounting detail |
| --- | --- | --- | --- |
| [Main fuse, disconnect and contactors](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) | Allowances; DC-CON-72V400A is only a price example | [Switchgear costs](power-distribution.md#0505-main-fuses-disconnects-contactors-and-feedback) · [Ratings/feedback requirements](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) | [Pack/BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) · [Independent stop](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Precharge and discharge hardware](power-distribution.md#ps22-precharge-and-discharge) | Resistance, energy, sequence and timing open | [Precharge/discharge costs](power-distribution.md#0506-precharge-discharge-and-voltage-test-hardware) · [Required data](power-distribution.md#ps22-precharge-and-discharge) | [Controller input](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) |
| [Control DC/DC and branch protection](power-distribution.md#ps24-control-supplies-and-branch-protection) | Control-rail loads and exact converters unselected | [Supply costs](power-distribution.md#0507-control-dcdc-logic-supplies-and-branch-protection) · [Supply requirements](power-distribution.md#ps24-control-supplies-and-branch-protection) | [Brake coils](../02-drive-train/propulsion.md#ps15-mechanical-brakes) · [Control boards](../06-safety-controls-and-sensors/safety-controls.md#ps29-normal-control-and-diagnostics) |
| [Printed covers and glands](power-distribution.md#ps25-printed-enclosures-and-cable-glands) | DIY electronics packaging, not approved battery containment | [Enclosure costs](power-distribution.md#0508-electronics-enclosures-glands-cooling-and-mounting) · [Material/ingress requirements](power-distribution.md#ps25-printed-enclosures-and-cable-glands) | [Cable entry and strain relief](cables-connectors.md#ps23-high-current-harness) · [Heat spreaders](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) |
| [Heat spreaders, backplates and seals](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) | Thermal interfaces and insert retention unqualified | [Thermal/mounting costs](power-distribution.md#0508-electronics-enclosures-glands-cooling-and-mounting) · [Thermal requirements](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) | [Controller losses and limits](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) · [Printed enclosure](power-distribution.md#ps25-printed-enclosures-and-cable-glands) |

**Further detail:** [Release requirements](power-distribution.md#specification-and-inspection-requirements) ·
[Sourcing](power-distribution.md#sourcing) · [Interfaces](power-distribution.md#interfaces-with-other-scopes) ·
[Itemized costs](power-distribution.md#detailed-module-costs) ·
[Procurement and holds](power-distribution.md#procurement-and-release-holds) ·
[Supplier evidence](power-distribution.md#supplier-evidence)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS21: Main fuses, disconnects and contactors

**Cost-ledger coverage:** PWR-001:PWR-005

**Part links:** [Switchgear costs](power-distribution.md#0505-main-fuses-disconnects-contactors-and-feedback) ·
[Pack fault-current/voltage limits](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) ·
[Cable/fuse coordination](cables-connectors.md#ps23-high-current-harness) ·
[Stop-chain feedback](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

**Battery cassette packaging:** the [pod fit study](../04-battery-and-charging/batteries.md#sliding-battery-cassette)
reserves a 45 x 70 x 70 mm placeholder for the high-current main contactor
on the fixed controller support, between pack B+ and controller B+. One E-stop
is intended to command the main contactor of each pack open. The E-stop and
contactors are not a substitute for a rated service disconnect and verified
isolation. The envelope is not a selected part;
ratings, precharge, coil supply and feedback remain HOLD.

**E-stop operator placement:** the fit study places the E-stop operator
outboard of the track, beside the controller, on an arm from the fixed
controller support. The red mushroom head is on top and is pressed downward,
parallel to the track side, so the pressing hand never moves toward the belt.
A vertical finger guard between the operator and the track rises above the
track top run. The operator stays inboard of the extracted battery lift path.
Its coil loop is intended to open both pack contactors; wiring, enclosure rating and the
operator part are HOLD.

**Required purchasing/manufacturing definition:** Fuse time-current curve, DC breaking
capacity and fault coordination; holder/disconnect DC ratings; contactor
make/break/duty/coil ratings at full bus voltage and current; feedback and suppression
compatible with stop timing

**Receiving or first-article evidence:** Exact MPN/certificates where required;
schematic/rating review against pack fault current; assembly polarity, tightening and
feedback records; welded-contact fault response evidence

### PS22: Precharge and discharge

**Cost-ledger coverage:** PWR-006:PWR-007

**Part links:** [Precharge/discharge costs](power-distribution.md#0506-precharge-discharge-and-voltage-test-hardware) ·
[Controller input requirements](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) ·
[Voltage sensing](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging).

**Required purchasing/manufacturing definition:** Controller input capacitance and
charging limits; precharge resistance/energy/duty and relay sequence; discharge energy,
component ratings, voltage-test points and isolation criteria

**Receiving or first-article evidence:** Calculation and schematic review; documented
voltage/time measurements and failure responses under authorized energizing; no assumed
safe discharge interval

### PS24: Control supplies and branch protection

**Cost-ledger coverage:** PWR-012:PWR-014

**Part links:** [Control-supply costs](power-distribution.md#0507-control-dcdc-logic-supplies-and-branch-protection) ·
[Brake-coil requirements](../02-drive-train/propulsion.md#ps15-mechanical-brakes) ·
[Control-board loads](../06-safety-controls-and-sensors/safety-controls.md#ps29-normal-control-and-diagnostics) ·
[Separately budgeted width-drive supply](../03-width-adjustment/width-adjustment.md#ps11-width-drive-power-and-protection).

**Required purchasing/manufacturing definition:** Actual control-rail/load budget
including brakes, safety coils and startup loads; DC/DC input range/isolation/thermal
derating and grounding; branch fuse/wire coordination and brownout behavior

**Receiving or first-article evidence:** Rail and isolation design review; supply
identity and authorized load/brownout evidence; control power loss cannot create an
automatic restart

### PS25: Printed enclosures and cable glands

**Cost-ledger coverage:** PWR-015:PWR-016

**Part links:** [Enclosure/gland costs](power-distribution.md#0508-electronics-enclosures-glands-cooling-and-mounting) ·
[Cable entry](cables-connectors.md#ps23-high-current-harness) ·
[Thermal backplates and inserts](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) ·
[Separate battery containment](../04-battery-and-charging/batteries.md#ps19-battery-enclosures-and-restraints).

**Required purchasing/manufacturing definition:** Enclosure CAD/revision, resin grade
and batch, print orientation/walls/infill/process, heat/UV/flame suitability, gland
cable diameter ranges, vent/drain and sealing strategy

**Receiving or first-article evidence:** First-article dimensions and print inspection;
material/process record, cable retention and approved temperature/ingress evidence; no
IP rating inferred from nominal filament type

### PS27: Thermal paths and enclosure hardware

**Cost-ledger coverage:** PWR-021:PWR-024

**Part links:** [Thermal/mounting costs](power-distribution.md#0508-electronics-enclosures-glands-cooling-and-mounting) ·
[Controller data](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) ·
[Printed-box material limits](power-distribution.md#ps25-printed-enclosures-and-cable-glands).

**Required purchasing/manufacturing definition:** Heat-flow/loss budget,
backplate/spreader material/thickness/contact area, thermal interface, gasket
compression, lid fastener spacing and insert retention at service temperature

**Receiving or first-article evidence:** Assembly flatness/interface and fastener
inspection; thermal and insert-retention evidence on actual printed configuration; no
enclosure thermal/ingress rating claimed before qualification

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)


## Sourcing

[Dedeman fabrication supplies (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) ·
[RS electrical components (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) ·
[DOLD DC-CON-72V400A contactor example (S18)](power-distribution.md#s18-dc-con-72v400a-contactor-example).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)


## Procurement and release holds

Prepared supplier requests and release holds owned by this scope. Sending a request needs separate user approval; every hold is **OPEN**. Shared document control, manufacturing packs and cross-cutting holds stay in the [Chassis Build and Procurement Checklist](../../chassis-build-requirements.md#chassis-build-and-procurement-checklist).

### Q05: electrical and safety

**Requirements:** [Width-drive power, feedback and harness](../03-width-adjustment/width-adjustment.md#specification-and-inspection-requirements),
[main power distribution](power-distribution.md),
[cables and connectors](cables-connectors.md), and
[independent stop/control/sensor requirements](../06-safety-controls-and-sensors/safety-controls.md#specification-and-inspection-requirements).
**Leads:** [RS electrical parts](../../bom/sources.md#s07-rs-electrical-parts-and-tools),
[Schneider relay example](../06-safety-controls-and-sensors/safety-controls.md#s08-schneider-xpsuaf13ap-safety-relay-example), and
[DOLD contactor example](power-distribution.md#s18-dc-con-72v400a-contactor-example). The
[industrial remote](../06-safety-controls-and-sensors/safety-controls.md#s09-tele-radio-tiger-g2-remote-alternative) is historical research, not a current purchase.

**Specific response needed:** Exact full-voltage-rated protective devices, complete
connector/harness children, independent stop configuration and evidence; no
automatic approval of catalog examples

### H04: bus and protection coordination

**Must close before:** Pack, controller, switchgear and harness release

**Closure evidence / responsible review role:** Full-charge/cutoff/regen and
fault-current compatibility, precharge/branch protection, DC/DC/coil loads and
schematics; electrical review

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Conductor, connector and crimp sizing | [High-current harness](cables-connectors.md#ps23-high-current-harness) |
| Isolation sequence, braking and restart prevention | [Independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Controller input range and regeneration | [Drive compatibility and duty](../02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| Full-charge voltage, fault current and BMS opening | [Battery packs and BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) |

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)

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

<a id="cost-switchgear"></a>

### 05.05 Main fuses disconnects contactors and feedback

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-001 - DC main fuse](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) (2 each) | €50.00 / A |
| [PWR-002 - Touch-protected main fuse holder](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) (2 each) | €50.00 / A |
| [PWR-003 - DC service disconnect](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) (2 each) | €110.00 / A |
| [PWR-004 - Monitored DC contactor provision](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) (4 each) | €440.00 / A |
| [PWR-005 - Contactor feedback and coil protection provision](power-distribution.md#ps21-main-fuses-disconnects-and-contactors) (4 each) | €60.00 / A |
| **Module subtotal** | €710.00 |

<a id="cost-precharge"></a>

### 05.06 Precharge discharge and voltage-test hardware

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-006 - Pre-charge relay resistor and mounting](power-distribution.md#ps22-precharge-and-discharge) (2 pod set) | €70.00 / A |
| [PWR-007 - Controlled discharge and voltage-test provision](power-distribution.md#ps22-precharge-and-discharge) (2 pod set) | €20.00 / A |
| **Module subtotal** | €90.00 |

<a id="cost-control-supplies"></a>

### 05.07 Control DC/DC logic supplies and branch protection

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-012 - Protected traction-to-control DC/DC converter](power-distribution.md#ps24-control-supplies-and-branch-protection) (2 each) | €180.00 / A |
| [PWR-013 - Logic step-down supply](power-distribution.md#ps24-control-supplies-and-branch-protection) (2 each) | €30.00 / A |
| [PWR-014 - Low-voltage fuse blocks fuses and terminals](power-distribution.md#ps24-control-supplies-and-branch-protection) (2 pod set) | €50.00 / A |
| **Module subtotal** | €260.00 |

<a id="cost-enclosures"></a>

### 05.08 Electronics enclosures glands cooling and mounting

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [PWR-015 - Filament for DIY electronics enclosures and cable covers](power-distribution.md#ps25-printed-enclosures-and-cable-glands) (2 kg) | €50.00 / A |
| [PWR-016 - Cable glands vent and strain relief](power-distribution.md#ps25-printed-enclosures-and-cable-glands) (1 lot) | €35.00 / A |
| [PWR-021 - Controller heat spreaders and thermal interface](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) (2 pod set) | €50.00 / A |
| [PWR-022 - DIY enclosure mounting backplates](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) (2 each) | €20.00 / A |
| [PWR-023 - DIY enclosure gaskets and lid fasteners](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) (2 pod set) | €16.00 / A |
| [PWR-024 - Threaded inserts for printed enclosures](power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) (2 pod set) | €10.00 / A |
| **Module subtotal** | €181.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €1,241.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)


## Supplier evidence

Dated supplier claims for this scope, recorded under the [common sourcing weights](../../bom/sources.md#common-sourcing-weights). Catalog listings are leads, not quotes or qualification. Source IDs stay stable for the [cost ledger](../../bom/chassis-bom.csv).

<a id="s18"></a>

### S18: DC-CON-72V400A contactor example

**Source / source type:** [DOLD
DC-CON-72V400A](https://www.dold-mechatronik.de/DC-CONTACTOR-DC-CON-72V400A),
price-class example

**Evidence or limitation:** €62.23 displayed in HTML. “72V400A” alone does not establish
coil voltage, full-charge DC breaking ability, auxiliary feedback, or safety
suitability; not the selected contactor. CSV allows €110 each for a properly reviewed
alternative.

**Engineering detail:** [Main fuses, disconnects and contactors](power-distribution.md#ps21-main-fuses-disconnects-and-contactors).

[↑ Back to document overview](power-distribution.md#power-distribution-and-enclosures)
