# Stage 1–2 Prototype BOM

**Status:** preliminary sourcing comparison; not a purchasing specification.
**Checked:** 2026-10-23. **Budget:** €5,000 maximum; about €3,000 preferred for
2 motors, 2 controllers, and 2 battery packs.
**Currency:** BNR rates for 2026-10-23: €1 = RON 5.3495; US$1 = RON 4.7770.
Converted prices are estimates, not checkout or landed prices.

This BOM follows [plan.md](../../plan.md). The plan still carries a provisional
48V / approximately 8kWh usable battery baseline. This sourcing comparison
prefers 72V, with 48V as an alternative; it does not silently change the plan.
Supplier claims require verification. No supplier contact, purchase, build, or
hardware operation is authorized.

## Drive requirement

| Item | Qty. | Short specification |
| --- | ---: | --- |
| Traction motor | 2 | Approximately 4kW each; 72V preferred, 48V alternative. Gear reduction must meet 70–80Nm per track at 140–280rpm per plan. |
| Motor controller | 2 | One matched controller per motor; voltage, current, sensors, control mode, and regenerative-braking limits must match the motor and battery. |
| Battery pack | 2 | One pack per drive. Preferred 72V, approximately 60Ah each; confirm usable energy, continuous/peak current, charger, BMS, and regenerative-charge compatibility. |

At 4kW, ideal DC current is about 56A at 72V or 83A at 48V; losses increase
actual current. Two 72V, 60Ah packs provide 8.64kWh nominal, not confirmed
usable energy. Final current limits and runtime require component data and
testing.

## Motor and controller options

Each specification cell is under 50 words. Listed prices are per part unless
stated; torque values are motor-shaft values, not track output.

| Option | Short technical specification | Supplier and price |
| --- | --- | --- |
| **72V, 4kW — Volcano VOL-BL400C72** | 4kW, 72V, 2,580rpm, 14.81Nm, S1 duty, IP44/IP54. Published current conflicts: 58.82A and 71.17A. Hall controller optional; obtain matched controller quote and resolve current rating. | [Motor listing](https://www.volcanomotors.com/product/251mm-72v-4kw-hall-sensor-bldc-motor-with-controller/). Motor and controller prices: quote required. China supplier; no landed price. |
| **72V — Golden Motor HPM5000B + EZ-A72500** | Motor listing: 5kW, 72V variant to confirm; shaft torque curve required. Controller: 72V nominal, 95V max, 4–7kW, 200A rated phase / 250A max bus. Limit motor to ~4kW only if manufacturer data permits. | [HPM5000B motor](https://goldenmotorcz.en.made-in-china.com/product/aOQmBwgCXEkV/China-BLDC-PMSM-brushless-motor-HPM-5000B-Nominal-power-5kW.html): US$545 each (1–9 listing). [EZ-A72500 controller](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-72V-Motor-EZ-A72500): €451.98 incl. 19% VAT each. Shipping/tax basis differs. |
| **48V alternative — Golden Motor HPM5000A-48 + EZ-A48500** | Motor: 5kW, 48V; continuous torque curve required. Controller: 48V nominal, 72V max, 3–5kW, 200A rated phase / 250A max bus. Verify sensor match and battery current margin. | [HPM5000A-48 motor](https://www.dold-mechatronik.de/BLDC-Motor-Brushless-DC-Motor-5kW-48V-Air-Cooled-HPM5000A-48): €630.48 incl. VAT. [EZ-A48500 controller](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-48V-Motor-EZ-A48500): €337.35 incl. VAT. One pair: €967.83 incl. VAT. |

## Battery options

| Option | Short technical specification | Supplier and price |
| --- | --- | --- |
| **72V preferred — marketplace reference** | 72V, 60Ah lithium-ion listing; select the 100A BMS version. About 4.32kWh nominal per pack. Verify continuous discharge, cell type, charger, certificates, and exact listing variant. | [AliExpress listing](https://www.aliexpress.com/item/1005013071802854.html): indexed at about US$410 each. Two: about US$820 / €732.24 / RON 3,917.14, before delivery, VAT, or import charges. |
| **72V EU price reference — TZI Power** | 72V, 60Ah LiFePO₄, 60A continuous / 120A peak. 60A leaves little margin for a 4kW drive; not qualified at target power without a higher-current BMS option. | [TZI pack](https://www.tzipower.de/lifepo4-akkus/72v-60ah-lithium-lifepo4-akku-pedelec-e-bike-e-bike-akkupack-roller-scooter-pv_1916_9570/): €1,735 incl. VAT each. Two: €3,470 before shipping. |
| **48V alternative — Elker Solutions** | 48V, 100Ah LiFePO₄, 5.12kWh, listed 100A BMS. Vehicle use, continuous/peak discharge, and regenerative charging are unverified; 100A is a narrow margin at 4kW per drive. | [Elker battery](https://elkersolutions.com/product/lifepo4-lithium-battery-48v-100ah/): €1,019.90 each incl. VAT per indexed listing. Two: €2,039.80; confirm delivery to Romania. |

## Budget comparison

Totals cover **2 motors + 2 controllers + 2 packs only**. They exclude
gearboxes, tracks, shipping not stated, and any unresolved import/VAT charges.

| Configuration | Indicative total | Budget status |
| --- | ---: | --- |
| 72V Golden Motor reference + 2 marketplace battery packs | **€2,609.55 / RON 13,959.80** | Uses two US$545 motors, two €451.98 controllers, and two US$410 packs. Mixed tax basis; not a landed quote. Close to the €3,000 target before freight/import charges. |
| 72V Volcano 4kW motor/controller + 2 marketplace battery packs | Battery pair: **€732.24 / RON 3,917.14**; drive quote required | To meet €3,000, both motor/controller sets must cost at most €2,267.76 combined before unpriced delivery and taxes. |
| 48V DOLD drive pairs + 2 Elker battery packs | **€3,975.46 / RON 21,266.72** | Listed prices include VAT; pack discharge and vehicle suitability need confirmation. Under the €5,000 cap, above the preferred target. |
| 72V Golden Motor reference + 2 TZI packs | **€5,347.31 / RON 28,605.43** | Exceeds the cap; the listed 60A continuous battery current is also marginal. |

The 72V Golden Motor basket is the only priced 72V path currently near the
preferred budget, but its motor is 5kW and the battery/controller prices are
not a landed package quote. Do not select it until exact voltage, torque
curves, continuous current, controller settings, battery discharge limits, and
Romania delivery costs are confirmed. Apply the prior 20% price rule only to
equivalent landed configurations.

## Stage 2 chassis

| Item | Qty. | Short specification / price |
| --- | ---: | --- |
| Rubber tracks | 2 | Plan size 200×72×36. [PowerTrack listing](https://www.powertrack.it/en/powertrack-rubber-tracks/2023-Rubber-tracks-for-miniexcavators-200x72x36-0793596792038.html): €128.82 each at pair quantity; €257.64 / RON 1,378.25 total. Confirm VAT, track version, load rating, and Romania delivery. |
| Sprockets, idlers, rollers, tensioners | 2 pod sets | Match to the selected track pitch and undercarriage; quote required. |
| Pod frames, motor plates, scissor frame, implement spine | 1 chassis set | Design to verified loads; retain positive width locks, hard stops, guards, and service access. Fabrication quote required. |
| Battery distribution and independent safety path | 1 system | Size cables, fuses, contactors, pre-charge, disconnects, and stop path to verified controller/battery limits. Design and price TBD. |
| Bench instrumentation and test fixture | 1 set | Measure torque, speed, voltage, current, and temperature under load. Specify after the motor/controller pair is selected; price TBD. |

Stage 1 tests one drive; Stage 2 uses both drives and packs. The full Stage 1–2
total remains **TBD** until the drive, gearing, chassis, protection, and
instrumentation are specified. Purchases, fabrication, energizing, firmware
uploads, and field tests require separate explicit approval.
