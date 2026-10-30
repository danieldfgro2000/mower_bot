# Interactive CAD and engineering documentation

**Summary:** Browse the current pod-fit SCAD study and its documentation side by
side in a local browser. The **Presentation / Engineering** selector switches
the selected component between its concise generated pitch card and detailed
technical section. Click a **3D thumbnail** in either view to select and frame
that component. No hosting or publishing is required.

**Status:** Unqualified sourcing-candidate fit study, not fabrication geometry
or authorization to build. It represents the 200 x 72 x 40 track, paired 120 mm printed
roller concept, paired 200 mm idler candidate, HPM5000B interfaces and current
DC HOUSE body envelope. Represented payload and running-gear clearances are
checked using a raised fixed upper return and revised battery tray, not a
complete assembly clearance certificate. U supports/axles, connected
tray frame, motor reaction plate and a spring-loaded sliding front idler are
now represented custom proposals. This is not a complete qualified machine:
brake, reducer supports, joints and actual spring specification remain open.
The upright battery is rotated 180 degrees on a proposed open tray with four
removable base-clamp concepts (no box or over-pack straps),
one flat telescopic guide under the tray and a tray-level two-position pin. An
actual-size controller envelope and a main contactor placeholder sit on a
fixed frame support centered above it, with direct, connector-free battery and phase
harness routing. The preferred protected short-end position clashes
with the current drum/return geometry. See the
[cassette load/evidence boundary](../modules/04-battery-and-charging/batteries.md#sliding-battery-cassette).
The BOM baseline is not changed by this candidate study.

## Modeled dimensions and limits

| Component | Relevant detail | Evidence / remaining assumption |
| --- | --- | --- |
| Track | 200 mm width, 72 mm pitch, 40 links; listed roller type R2; four-circle path, 2,880 mm nominal loop. Per link: twin trapezoidal horns at Z = +/-19.5 mm (19 mm high, 19/6 x 30/20 mm base/tip), 20 x 30 mm metal land, 42 mm open window; 3.5 mm inner shoulder, 15 x 10 mm chamfer, staggered 36 mm tread blocks | [Track candidate](../modules/01-structure-and-running-gear/running-gear.md#pod-fit-cad-assumptions) / [R2 evidence](../modules/01-structure-and-running-gear/running-gear.md#s39-longer-powertrack-belt-candidates). Profile rounded from an undimensioned image; code interpretation and mid-thickness pitch line unconfirmed; 20 mm belt (image scales to about 31.5 mm) and 6 mm tread height are schematic |
| Drive drum | Flexible 350 mm OD, 200 mm axial envelope; running bands outboard of a 70 mm groove; 306 mm OD root ring 3 mm under the horn tips; side webs; 16 trapezoidal 10 mm-wide teeth on a central disc entering the open link windows | Static R2 window passage only, not a matched sprocket; tooth count/flanks, 10 mm shell and groove are placeholders |
| Idler | Two 200 mm OD wheels, each 50 mm tread / 60 mm hub, 20 mm bore; treads at Z = +/-60 mm outboard of the R2 horns; 170 mm tread / 180 mm hub envelope | [Interwheel 161.540 candidate](../modules/01-structure-and-running-gear/running-gear.md#s37-bearing-wheel-roller-and-idler-candidates), not an approved fit. Hub OD is schematic; treads overhang the illustrative shoulder taper by 11 mm |
| Lower rollers | Four paired assemblies, 120 x 40 mm wheels (narrowed from 50 mm for R2); 8 mm TPU tread, PC core, two 20 x 42 x 12 mm bearings per wheel; 150 mm pair width | [Printed-wheel concept](../modules/01-structure-and-running-gear/running-gear.md#s38-3d-printed-roller-wheels-owner-proposed). 70 mm tread-face groove and 1 mm bearing recess are study values, not print tolerances |
| Upper rollers / supports | Two fixed paired 70 x 40 mm assemblies at X = 245 and -195, Y = 510 mm; 6 mm U cheeks, 20 mm axles and bridges; inboard masts to Z = -116 mm; outboard 25 mm square posts with 12 mm notched flat crossheads on fixed carrier wings, Z up to 179 mm | [Fixed upper proposal](../modules/01-structure-and-running-gear/running-gear.md#fixed-upper-roller-support). No idler-arm or moving-tray landing; capacity, carrier-wing bending and joints unqualified; 70 mm diameter and track bend radius HOLD; masts take 16 mm of central space per pod |
| Motor | 206 x 126 mm body, 22.3 mm shaft / 53 mm projection, 5 x 43 mm keyway, four nominal M8 openings on 148 mm PCD | [Drawing evidence](../modules/02-drive-train/propulsion.md#s24-golden-motor-hpm5000b-family-specification). Hole depth, clocking and keyway axial offset are illustrative; threads and cooling details omitted |
| Battery | 504 x 268 x 233 mm body (length / transverse width / vertical height) | [DC HOUSE S30](../modules/04-battery-and-charging/batteries.md#s30-dc-house-100-ah-charger-bundle). Listing dimensions conflict with other supplier material; terminals, cables, handles and restraints need measured envelopes |
| Carrier / battery position | Fixed 524 x 288 x 10 mm core plus two rectangular side wings: 650 x 288 mm overall envelope, not a full rectangle; Y = 140-150 mm; battery X = 35, Z = 44 mm, bottom Y = 158 mm | Custom proposal; wings carry fixed roller posts, not the unchanged 8 mm moving tray. Inboard tray edge stays Z = -100 mm |
| Battery service cassette | Open 8 mm steel tray (no box) with four removable slotted-jaw/hand-knob concepts on fixed seats; one flat 305 mm telescopic guide under the tray; tray-level 12 mm pin and two 12.5 mm bores | [Geometry, 85 kg load screen and S40 price](../modules/04-battery-and-charging/batteries.md#sliding-battery-cassette). The pack's base flange, clamp grip, threads and lock are unmodeled; the concepts are **not a verified restraint**. The single flat guide rating (about 27.2 kg) is below the pack, so guide, seat transfer and joints remain HOLD |
| Controller / contactor / harness | EZ-A48500 A-series 200 x 164 x 70.47 mm overall, centered on a fixed frame support above the tray; its terminal row runs across the pod at X = 53; X = -47 to +117, Z = -56 to +144, base Y = 411 mm. A 45 x 70 x 70 mm contactor placeholder shares the support | [Position assessment/drawing evidence](../modules/02-drive-train/propulsion.md#ez-a48500-controller-candidate), [terminal/harness assumptions](../modules/05-power-cables-and-electronics/cables-connectors.md#battery-cassette-harness). Battery lugs bolt directly to the terminals; P+ is switched by the E-stop contactor; phases run directly to the motor inside the track side silhouette, with no connectors; exact battery offsets / motor cable exit unverified |
| Lower U supports | Four pairs of 6 mm cheeks, 20 mm axles, 6 mm top bridges at Y = 134-140 mm | [Support details](../modules/01-structure-and-running-gear/running-gear.md#lower-support-rollers); 5 mm tire-side and 4 mm bridge/tread gaps; bearing fits, retention and loads unqualified |
| Tray frame / motor plate | Four 25 x 25 mm motor supports on 240 x 80 mm centers; straight rectangular outboard cradle on the rear fixed carrier wing; deeper rear rails and 20 x 65 mm front webs; 290 mm OD x 16 mm motor plate, 148 mm mounting PCD | [Frame proposal and local stress screens](../modules/01-structure-and-running-gear/frame.md#local-structural-load-screen); each plate seat has 625 mm² modeled overlap. Motor/reducer positions unchanged; joints, fixed-ring and brake mounts still undesigned |
| Idler carriage / spring | 6 mm yoke with cheeks at Z = +/-95-101 mm, 206 mm axle, two 10 mm guide rods at Z = +/-114 mm / 11 mm sleeve bores, +/-15 mm stop positions; 36 mm OD coil / 4 mm wire, six active turns + two end rings | [Carriage](../modules/01-structure-and-running-gear/running-gear.md#sliding-idler-carriage) / [spring](../modules/01-structure-and-running-gear/running-gear.md#spring-tensioner-concept); 57.036 mm nominal seat gap, 42.036-72.036 mm geometric range; no rate/preload or selected commercial spring |

Drive and idler axes are at X = -440 and +410.308 mm: **850.308 mm spacing**.
The exact four-circle external tangents and wrap arcs close the nominal loop
to within 0.02 mm; guide positions follow actual segment lengths, not an
equal-wheel approximation. The belt-body longitudinal envelope is approximately
**1,165 mm**, before tread projections. Overall track height is about **587 mm**.

| Clearance / change | Revised result | Provisional requirement |
| --- | ---: | --- |
| Battery to front / rear continuous horn-tip return envelopes | 41.5 / 104.0 mm normal to the runs | 35 mm nominal = 20 running + 10 motion allowance + 5 deflection/tolerance reserve |
| Conservative return clearance after both allowances | **26.5 mm minimum** | 20 mm; assumptions need actual track data |
| Fixed upper wheel to battery | 84 mm | 20 mm |
| Lower rollers to fixed carrier / battery | 10 / 28 mm | 10 / 20 mm |
| Adjacent lower rollers | At least 10 mm; locations recalculate with the idler | 10 mm |
| Battery to drive / idler physical envelopes | At least 20 mm | 20 mm |
| R2 horn lateral gap, each side | 6 mm to lower/upper wheels, idler treads and drum bands; 5 mm to drum webs and teeth | 5 mm |
| Common axles to R2 horn tips | 31 mm lower; 6 mm upper | 5 mm provisional |
| Drum root ring / central disc to wrapped horn tips / link lands | 3 / 5 mm radial | No running requirement set: the wrap co-rotates; belt deflection and actual horn height are HOLD |
| Rotating idler hubs to frame strip / front anchors | 5 mm radial and axial through the +/-15 mm stroke (swept relief) | 5 mm provisional |
| Motor + reaction plate + stages + carrier | 210 mm stack; 16 mm outboard projection, **6 mm inboard remainder** | 5 mm; excludes brake/reducer supports |
| U bridges to lower / upper wheels | 4 / 29 mm | 3 / 5 mm provisional running gaps |
| Reinforced front rail caps / outer webs to moving yoke / sleeves | 6 mm vertical / lateral; at least 5 mm to the continuous carriage sweep and nominal track envelope | 5 mm provisional; guide rod/sleeve contact is intentional, track deflection and load unqualified |
| Motor posts / plate to motor, drum, track, lower wheel and phase leads | At least 5 mm to represented envelopes | 5 mm provisional; actual hardware and deformation unmodeled |
| Roller outboard posts/crossheads to cassette extraction, idler stroke, harnesses and running gear | At least 5 mm; full 625 mm² post feet on fixed carrier wings, direct crosshead/U-bridge overlap | 5 mm provisional; geometric load paths are not weld or carrier-wing capacity evidence |
| Illustrative sprocket root bore to stationary motor plate / posts | 5.2 mm radial to plate; more than 5 mm to posts | 5 mm provisional; R2 window engagement is a separate, unqualified intentional interface |
| Guide rod to sleeve bore | 0.5 mm radial | Study clearance only; not a selected sliding-bearing fit |
| Battery and individual base-clamp sweeps to fixed gear, controller, contactor and frame | At least 5 mm, checked by expanded solid sweeps | Provisional geometry screen only; real flange and dynamic cassette allowance not qualified |
| Tray sweep to full +/-15 mm idler/yoke stroke | At least 5 mm, checked by expanded conservative envelopes | Idler stroke is geometric, not proven usable tensioning travel |
| Power leads to upper wheels/support; phase-to-phase and phase-to-track/drum | At least 5 mm between represented cable envelopes and running gear | Provisional; actual motor exits, bends and insulation need confirmation |
| Phase-lead supports: free span, grip and running-gear gap | Five supports per phase; no span over 200 mm including lug ends; every support anchored to frame, post or electrical plate; at least 5 mm to track, drum, rollers and stages | 200 mm span, cleat material and vibration rating are HOLD |
| Flat guide stages to lower rollers and U supports | At least 5 mm through travel | Provisional; rail profiles/fixings still require actual drawings |
| Inner-stage pads to tray in WORK | 0.9-1.1 mm float; tray rests on fixed seats | Seat-to-guide load transfer is HOLD |

The axial stack includes 2 mm between the motor reaction plate and first stage, between
stages, and before the 6 mm output carrier. The 53 mm shaft shares the sun-bore
space; it is not added in series or a designed coupling. Schematic gear
engagement, wheel/belt running contact, battery/tray contact and the
carrier/drum connection are intentional interfaces, not forbidden clashes.

**Clearance-only tensioner envelope:** the upper axis is now fixed and the
front idler slides +/-15 mm in X. At 1 mm intervals, actual yoke/wheel meshes
clear the fixed frame, reaction rod, neighboring wheels and mast; the spring
and moving seat also clear at both extremes and nominal position. Nominal
return margins retain the conservative 10 mm motion + 5 mm deflection reserve;
recalculated return tangents through the idler sweep leave at least 25 mm,
including the 5 mm deflection reserve. Guide end blocks and separate stop
collars are represented, but stop fixings and spring characteristics are not.
The commercial belt is modeled at its nominal 40-link length only. Moving
the idler changes the ideal tangent-loop length, so +/-15 mm is **not
demonstrated usable spring travel**. Belt elasticity/slack, setup, spring
rate/preload and tension loads must be established before release. No
commercial belt was stretched or purchasable loop length invented to claim fit.

The 305 mm cassette extraction clears represented running gear and frame.
The battery, open tray, base-clamp concepts, inner guide stage and locking strip move;
the controller, its support, the main contactor and all power leads stay
fixed. Pin withdrawal and middle-stage half travel are independent animation
tracks. Remaining interfaces include rated restraints, signal harnesses,
guards, exact terminal datums and the rest of the machine.
The controller's case occupies X = -47 to +117 mm, Z = -56 to +144 mm and
Y = 411-481.47 mm overall, including its provisional terminal pads. It is
centered over the battery so the B+, U, V, W, B- row runs across the pod at
X = 53 mm. The phases use staggered-height lanes past the drive drum and
climb behind the battery; the pack leads approach from the rotated +X terminal
end. Battery and phase leads do not cross in plan above the battery.
Power harnesses, controller and
contactor stay inside Z = -125 to +183 mm; the reinforced front rail and fixed
flat guide set the physical envelope at Z = -151 to +205 mm. Top mounting needs
reviewed support joints, cooling and overhead protection; the battery carries
no controller load.
The battery bottom rises
from 100 to 158 mm versus the previous
clashing study, raising its body CG 58 mm. The cassette mass, outboard offset and track mass
change require a new complete-machine mass/CG and transport assessment; see
the [width screen](../width-and-slope-sizing.md#minimum-width-and-packaging).
No printed-wheel load rating or safe slope is inferred from clearance.

## Open the local viewer

From the repository root, with Node.js 20+ and the `openscad` executable installed:

```sh
npm ci --prefix tool/cad-viewer --ignore-scripts
npm run sync --prefix tool/cad-viewer
npm start --prefix tool/cad-viewer
```

Open `http://127.0.0.1:8765/`. The server binds to loopback only, serves no
firmware or credentials, and performs no hardware operations. Stop it with
Ctrl+C. Set `PORT` if needed; set `OPENSCAD` to an executable path if OpenSCAD
is not on `PATH`. PNG generation uses OpenSCAD's renderer and may require a
desktop session or configured offscreen display on Linux.

The browser previews exported SCAD geometry, not an embedded native OpenSCAD
session. **Editable SCAD** downloads the source to open in OpenSCAD; it cannot
launch the desktop application automatically. Markdown thumbnail links work
inside this local reader. GitHub and ordinary editor Markdown previews can show
the images but cannot run the viewer HTML; open the local reader first.

## Inspect components

[![3D motor body](../../presentation/viewer/previews/motor.png)](../../presentation/viewer/index.html?component=motor)

**Click the motor thumbnail above** to frame the HPM5000B and open its
[price, specification and mounting documentation](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate).
The same thumbnail route is available beside the motor in its owning scope.

- Drag to orbit, scroll to zoom, right-drag to pan.
- Click a visible mesh to open its owning section without leaving the viewer.
- Use **Component** or a part name in the visibility tree to inspect its
  documentation. Inspection and display are independent: inspecting a hidden
  component does not silently replace or expand the displayed set.
- **Modules and component visibility** groups the modeled parts under
  **01 Structure and running gear**, **02 Drive train** and **04 Battery and
  charging**, with nested subassemblies. Annotations are separate, not a
  fabricated engineering module. Check any combination of modules,
  subassemblies or individual parts; partial checkboxes indicate mixed
  visibility. Group checkboxes always affect their whole subtree.
- **Only** beside a module, subassembly or part replaces the displayed set
  with that group or component. **Show all** and **Hide all** apply globally.
  Search filters the tree by module/component name without changing geometry,
  visibility or the scope of a group checkbox.
- **Isolate selection** temporarily displays only the inspected part, including
  a hidden part. Unchecking it restores the exact previous display set.
  Editing a visibility checkbox, using **Only**, or showing/hiding all exits
  temporary isolation. **Fit inspected** frames the visible inspected part;
  **Fit displayed** frames all displayed geometry. Empty displays disable fit.
  **Reset assembly** restores every part, clears the inspection/search and
  exits isolation.
- To inspect motor mounting holes and the shaft keyway, isolate the motor and
  orbit to its shaft-side (negative Z) face; the default outboard view hides them.
- **Selected STL** downloads just that component in the original assembly
  coordinates, in millimetres. The battery harness is one selection with red
  positive and black negative viewer meshes; its combined STL does not retain
  those colors. Planetary schematic-tooth studies are grouped by stage; the four
  lower rollers are separate exports. The removal arrow is explicitly an
  annotation, not a physical part.
- **Animate** plays a configured motion. **Battery cassette** withdraws the
  tray-level pin 35 mm down, slides the open tray and battery 305 mm outboard
  with the middle guide at half travel, then reengages the pin. The battery
  lugs are already unbolted; the animation is not an electrical disconnect procedure. **Play**/**Pause**/**Replay**
  run it; the slider scrubs to any point. Choosing an animation frames the whole
  path. Inspection, visibility and layout are unchanged; if every animated
  part is hidden the viewer says so. **Reset assembly** clears the animation.
  `animation=<id>` and progress `t=0..1` persist in the URL; selecting an
  animation adds a history entry, while playback and scrubbing replace it.
  The animation is a geometric sequence, not a demonstrated handling
  procedure: terminal datums, complete harness protection, restraints and lifting remain unqualified.
- **Split**, **CAD focus** and **Docs focus** in the header choose the pane
  layout. CAD focus collapses the documentation so the model uses the full
  width; Docs focus collapses the model for reading. Focus views keep the
  inspected part, display set and open section. Clicking a 3D thumbnail while
  in Docs focus returns to Split so the selected part is visible.
- Markdown links keep their scope and fragment in the reader. Presentation and
  engineering modes, inspected part, custom visibility, temporary isolation
  and pane layout persist in the URL. Reload and Browser Back/Forward restore
  them; the address can be bookmarked. A missing `visible` parameter means all
  components; `visible=` explicitly means none. A missing `layout` means split;
  `layout=cad` or `layout=docs` selects a focus view. Unknown visibility IDs or
  layouts are reported as errors, not silently discarded.

The [component map](../../presentation/viewer/components.json) owns each
selectable ID, label, technical target and generated presentation target,
plus the module/subassembly hierarchy. Every modeled component must occur
exactly once in the hierarchy; startup rejects unknown, duplicate or ungrouped
components. These display groups do not change BOM cost ownership or quantities.
The same map owns `animations`: keyframed offsets in SCAD millimetres for
listed components, starting at the assembled position. An optional
`tracks` map supplies independent keyframes (such as the
lock pin or half-speed guides); track IDs cannot duplicate the shared group.
Each animation needs a Markdown entry point (`index.html?animation=<id>`).
Export tests cover the battery/cassette path against fixed gear, telescopic
stages against stationary mounts, and pin/strip alignment at both ends and
during travel. They explicitly distinguish intended bearing/mount interfaces
from forbidden interference; they do not prove every unmodeled interface.
The [presentation catalog](../../presentation/catalog.json) owns concise
pitch facts, which are checked against technical evidence during generation.
The [SCAD source](module-01-track-pod-fit.scad) owns all geometry. Unmodeled
components have no invented mesh.

**Source layout:** [`module-01-track-pod-fit.scad`](module-01-track-pod-fit.scad)
is the entry point. It holds only the viewer component list and the
dispatcher. The geometry is split into subsystem files under
`module-01-track-pod/`:

- `parameters.scad`
- `frame.scad`
- `running-gear.scad`
- `idler-tensioner.scad`
- `drive-train.scad`
- `battery-cassette.scad`
- `electrical.scad`

Edit the subsystem file that owns the geometry you are changing. Put a value
in `parameters.scad` only when more than one subsystem uses it.

The OpenSCAD runner (`tool/cad-viewer/scad.mjs`) caches STL, PNG and probe
results under a key built from the OpenSCAD version and every SCAD source
file:

- **Any geometry edit** invalidates the whole cache. The exports then re-run
  in parallel worker processes.
- **Unchanged geometry** reuses cached results. This covers re-runs and edits
  that only touch the component map or the tests. An unchanged tree
  re-exports in about 0.5 s.
- **Disable the cache** with `CAD_CACHE=0`.

For a multicolored component, `components.json` can declare `renderParts`:
each names a unique internal model ID, an OpenSCAD module and a color. The
viewer groups those meshes under the original component for selection,
visibility and animation; the component's own SCAD selector remains the union
used for STL download and preview. The battery harness regression checks that
its two rendered leads cover that union exactly. Internal model IDs are not
new independently selectable components or thumbnail links.

The fit tests are split by subsystem into `tool/cad-viewer/fit-*.test.mjs`,
with shared probes in `cad-test-helpers.mjs`. `npm test` runs these files in
parallel. To iterate on one subsystem, run its file alone, for example
`node --test tool/cad-viewer/fit-battery-cassette.test.mjs`. Before handoff,
run the full `npm test --prefix tool/cad-viewer`. Earlier evidence entries
cite `export.test.mjs`; its tests now live in the matching `fit-*.test.mjs`
files.

Run `npm run stress --prefix tool/cad-viewer` for the CAD-backed local
structural and clearance screens. It reports assumed loads, stresses and
deflections and exits nonzero when a case fails. The
[load cases, mass exposure and exclusions](../modules/01-structure-and-running-gear/frame.md#local-structural-load-screen)
are part of the result; a passing screen is not frame or machine qualification.

`fit-estop.test.mjs` checks two things, written before the geometry.
First, the E-stop operator is outboard of the track (at least 30 mm), beside
the controller (within 60 mm) and stands proud on top. Its finger guard
rises above the track top, blocks straight reach lines to the belt and is
bolted to the fixed electrical plate; no separate arm or platform remains. It
clears every other component and the battery lift path. Second, the named
cable paths (`battery_positive_path_a/b`, `battery_negative_path`,
`motor_phase_path(i)`) stay within length budgets. The phase budgets were
raised to 780, 722 and 717 mm (2,215 mm total) because the phases now follow
fixed structure so they can be clamped.

**R2 track profile test-first update (2026-10-30):** the running-gear,
drive-teeth, tensioner, controller-support and frame tests were changed first
and failed on the single-lug track, 50 mm wheels and old drum. They now
require twin R2 horns with an open window per link, 40 mm printed wheels
outboard of a 70 mm groove, idler treads at Z = +/-60 mm, 16 drum teeth inside
the link windows clear of horns and lands, and a 5 mm swept idler-hub
clearance to the frame. That last test was added after the wider idler
touched the rail strip with zero volume. The widened carriage moved the front
rails to Z = 131-151 mm. The profile is image-scaled and HOLD; these checks
do not confirm supplier geometry or meshing.

**Electrical plate and phase-lead supports test-first update:**
`fit-controller-support`, `fit-estop` and the new
`fit-motor-harness-supports` tests were changed first and failed. They now
require one 6 mm plate at Y = 405-411 mm carrying the controller, contactor
and E-stop, with more than 500 mm³ of overlap at both inboard masts and both
outboard upper-roller posts and no contact with the moving cassette. The phase
leads must have five gripped supports each, no free span over 200 mm, no cut
into the leads, a fastened anchor at every support and 5 mm to running gear.
The plate is about 2.9 kg in aluminium; lightening holes, fasteners and
grommet edge protection are HOLD.

**Rotated controller and second upper roller test-first update (2026-10-30; superseded controller position):**
the frame, controller-support, E-stop and tensioner tests were changed first
and failed against the three-circle, 120 mm upper-roller layout. They now
require a four-circle loop with two 70 mm upper pairs, both connected to the
frame; the rotated controller at X = -130 to +34 mm; and length budgets of
P+ 320 mm, P- 320 mm, 700 mm per phase and 2,060 mm for all three phases.
Modeled routes are about P+ 314, P- 312 and U/V/W 679/681/692 mm.

## Refresh and verify

**Frame reinforcement test-first update:** new material and load regressions
first failed on the old slender motor supports, front rails and missing
eccentric load case. The first 5 mm front-clearance probe also exposed a
yoke-to-cap clearance of only 5 mm, so the cap was raised to 6 mm. A convex
hull of the complete carriage between the stroke extremes, expanded by 5.1 mm,
conservatively covers its continuous translation against the added front rails.
The nominal track check separately bounds the side belt/treads and central lugs.
These geometric
checks do not cover belt deformation, tolerance stack-up or guide-bearing fit.
The [local beam screens](../modules/01-structure-and-running-gear/frame.md#local-structural-load-screen)
are analytical comparisons, not FEA or physical testing.

**Centered controller and battery base-clamp test-first update (2026-10-30):**
The cassette, controller and harness checks first failed on the old straps,
off-center controller and terminal end. Expanded lead checks exposed
phase-to-phase, drum and upper-support conflicts and the battery lead against
an upper wheel; the rerouted leads now clear these modeled parts by 5 mm.
Four removable slotted jaws, studs and hand-knob envelopes follow the tray;
each clamp has a 5 mm expanded sweep to fixed gear. At EXTRACT, the jaw can
rise 5 mm and slide 14 mm outward below the loosened knob; the non-convex
slotted sweep is checked without filling the slot. An illustrative 4 x 6 mm
flange fixture can bear on the jaw and lift 300 mm past the remaining hardware;
the actual flange and full-pack handling remain unverified. The full tray
envelope clears the +/-15 mm idler stroke by 5 mm. Real battery grip, knob
threads, captive hardware and a secondary lock remain unmodeled pending flange
dimensions and load evidence. The centerline limits
are P+ 335, P- 320, U/V/W 660/615/585 and combined phases 1,855 mm; modeled
routes are approximately 332, 320 and 656/612/583 mm, respectively.

**Battery polarity and viewer-color test-first update (2026-10-30):**
the browser regression first failed because the single STL material rendered
both battery leads red, with no black lead visible. The viewer now loads
separately colored P+ and P- submeshes under the existing harness selection.
The fit checks trace the assumed battery endpoints through the contactor to
the B+ and B- ends of the manufacturer-drawn terminal row and retain 5 mm
between the represented leads. The supplier photograph, exact supplied
terminal positions and actual wiring remain unqualified; color is not a
substitute for checking markings and polarity.

**Loaded battery cassette test-first update (2026-10-29):**
new export tests first failed on absent enclosure/tray/controller IDs, and
animation validation failed to reject unknown independent tracks. Subsequent
solid checks exposed the enlarged rear box against the motor arms, the
shortened idler sweep against the fixed carrier, and a lock/rail mounting
conflict. Motor arms now connect below the moving cassette, both carriers
clear the idler's full stroke, guide sections are mirrored correctly and the
lock bridge passes above the fixed tower. Tests cover enclosure/terminal
clearance, actual steel mass versus the 85 kg screen, plate stress/deflection,
both lock bores, pin sequencing, half-travel stages, full extraction and a
5 mm expanded enclosure sweep. `npm test --prefix tool/cad-viewer` and the
browser suite exercise the resulting geometry/configuration and state.
These checks do not qualify joints, dynamic loads, wiring or vehicle stability.

**Protected controller placement test-first update (2026-10-29):**
The preferred short-end candidate was moved inboard to Z = -17 to +183 mm
and tested at Y offsets 0 through 140 mm in 20 mm steps. Every sampled
pose intersected the drive drum or return track; the exposed outboard mount
was not retained to hide those conflicts. The roof fallback preserves the
battery, motor, drum, roller and commercial track dimensions.
`node --test --test-name-pattern='protected roof fallback' tool/cad-viewer/export.test.mjs`
first failed on the old short-end orientation instead of the required flat
envelope. A second red assertion exposed an extra 10 mm pad allowance beyond
the published overall depth; this was corrected to 70.47 mm including pads,
and the short-end probes were repeated with that actual depth.
The focused roof/sweep and harness regressions then passed after roof mounting,
guide restoration and route separation. At that time they enforced the
205/-125 mm seated pod side limits (the reinforced rail now reaches -151 mm),
the box-width limit on controller and harnesses, a 5 mm
expanded controller sweep against all fixed components, and unchanged
enclosure/guide/load screens. Moving cables use exact sweeps of individual
convex capsule segments, not a hull across disconnected branches or a
pose-sampling approximation. The complete unit/geometry suite passes 30 tests.

**Open tray, flat guide and direct wiring test-first update (superseded strap concept):**
The cassette, controller/contactor, harness, stage-travel and animation tests
were changed first and failed (6 of 30) on the missing hold-down, contactor,
flat guide and direct harnesses. They now require: no box, lid or connectors;
the tray resting on fixed seats with the inner-stage pads floating 0.9-1.1 mm
below it; one flat guide wholly beneath the tray between the middle lower-roller
columns with at least 5 mm to rollers and U supports; a tray-level lock strip;
battery leads landing on the terminals and P+ switched by the contactor; phase
leads landing on the motor face and staying inside the track side silhouette;
a 5.5 mm battery/phase lead margin and no plan crossing; and a 5 mm battery and
hold-down sweep margin. After the SCAD change all 30 tests pass. This does not
qualify the guide rating, seat transfer, contactor selection or wiring.

**Earlier fixed controller support and removable lid update (superseded by open tray):**
The animation, cassette, controller and harness tests were changed first and
failed on the missing lid, support and battery feed and on the moving
controller. They now require: battery, box, lid, tray and battery leads to
move while the controller, support, feed and phase leads stay fixed; the lid
to separate from the body and the battery to lift 300 mm clear after
extraction; the support to tie into the frame and mast; a 5.5 mm battery/phase
lead margin; no plan crossing above the lid; an unplugged battery connector
and a mated phase connector. The first SCAD pass failed the harness sweep on
the track guide lugs, so the lead exit and connector were lowered.
This does not qualify thermal performance,
roof joints, guards, exact electrical interfaces or complete-machine fit.

**Earlier controller short-end relocation (superseded by protected roof mount):**
`node --test tool/cad-viewer/export.test.mjs` first failed because the
controller retained its former long-side orientation instead of the published
envelope on the motor-facing short end. After the relocation, guide adjustment
and harness fit iteration, the targeted controller/sweep and harness clearance
checks pass with
`node --test --test-name-pattern='controller mounts|harnesses reach' tool/cad-viewer/export.test.mjs`.
They verify the 5 mm track-edge gap, motor and box non-interference, fixed-gear
clearance through 305 mm extraction, and cable separation. Full CAD/viewer,
browser, generated-document freshness and link checks pass: `npm test
--prefix tool/cad-viewer` (30 tests), `npm run check --prefix
tool/cad-viewer`, `npm run test:browser --prefix tool/cad-viewer`,
`python3 .github/skills/bom-documentation/scripts/update_costs.py --check`,
and the engineering reference suite (18 tests). `git diff --check` is clean.
Geometric fit does not qualify its proposed brackets, thermal path or
electrical interfaces.

**Earlier body-only animation test-first update (2026-10-29, superseded by cassette):**
`node --test tool/cad-viewer/animation.test.mjs` first failed on the missing
animation module, and the new export test failed because no animation path was
configured. After implementation, 26 node tests pass, including an OpenSCAD
hull sweep of each keyframe segment (exact for the convex battery body)
against all represented physical parts and a final pose 20 mm or more outboard.
Browser checks cover selection, scrubbing, reload, playback to the end, pause
and replay, history, kept inspection, hidden-part notice, Reset assembly, the
Markdown animation link from Docs focus and invalid parameters.

**Split/focus layout test-first update (2026-10-29):**
`npm run test:browser --prefix tool/cad-viewer` first failed on the missing
layout control. The implementation also defers camera fitting while the model
pane is collapsed, because a zero-size pane would otherwise produce an invalid
camera aspect. Browser checks cover both focus views, widened canvas, kept
inspection/display, reload, Back/Forward, documentation links, thumbnail
return to split, invalid layout and narrow screens.

**Grouped visibility test-first update (2026-10-29):**
`node --test tool/cad-viewer/visibility.test.mjs` first failed because the
module hierarchy was absent; `npm run test:browser --prefix tool/cad-viewer`
then failed on the missing module visibility control. After implementation,
a delayed-document regression exposed a visibility edit losing the inspected
component from browser history; URL state now follows the active inspection
even while documentation is loading. Twenty viewer tests and the browser
workflows pass, including module/subassembly/part combinations, partial
checkboxes, only/show/hide actions, search, empty displays, isolation restore,
reload, Back/Forward, invalid display parameters and narrow layout. Geometry
and BOM quantities are unchanged by this UI feature.

After changing SCAD geometry, the component map, pitch facts, a targeted
documentation heading or a 3D study table, follow the
[CAD documentation sync skill](../../../../.github/skills/cad-documentation-sync/SKILL.md)
and regenerate the presentation followed by the CAD exports:

```sh
python3 .github/skills/bom-documentation/scripts/update_costs.py
npm run sync --prefix tool/cad-viewer
```

The generator checks presentation facts against their technical evidence.
CAD sync checks that SCAD selectors, component map, both documentation modes
and Markdown 3D links agree. Each component must have both document targets and
a Markdown entry point; each linked thumbnail must open its own component. It
re-exports only when stale: separate binary STL files, including colored render
parts, and a freshness manifest go to ignored `build/cad-viewer/`; thumbnails
go to `viewer/previews/`. `npm run check`
performs the same validation without writing. The server refuses stale or
incomplete exports at startup. Restart it after a component-map or geometry
change; nothing hot-reloads automatically.

```sh
npm run check --prefix tool/cad-viewer
npm test --prefix tool/cad-viewer
npm run test:browser --prefix tool/cad-viewer
```

The browser check uses Playwright Chromium, or `CHROME_PATH` for an installed
Chromium/Chrome executable. If neither is installed, install the test browser
with `npx --prefix tool/cad-viewer playwright install chromium`.

**Test-first evidence:** `core.test.mjs` initially failed for missing local
document/thumbnail routing and rendered anchors. `export.test.mjs` initially
exported the entire 1105 x 390 x 387 mm assembly when asked for the motor,
instead of the 206 x 206 x 126 mm body. These tests cover scoped navigation,
file-serving boundaries and isolated export in assembly coordinates.

**Initial viewer validation (2026-10-29, before candidate geometry):** Six contract/export tests passed, including the
unchanged assembly envelope and unknown-selector rejection. The browser check
passes thumbnail-to-model navigation, motor mesh raycasting, all 15 documentation
routes, section scrolling, bookmarks, Back/Forward, missing-document errors and
narrow layout. A delayed-document regression first restored the obsolete motor
URL after selecting the track; it now preserves the latest navigation. Export
freshness, JavaScript syntax, linked-cost freshness and engineering references
also pass. These software checks do not qualify physical geometry or operation.

**Candidate geometry test-first update (2026-10-29):**
`node --test tool/cad-viewer/export.test.mjs` first failed on the old 126 mm
motor-only envelope, 80 mm solid rollers, 200 mm track and 350 mm solid idler.
The updated mesh tests check actual material/void probes at motor mounting
holes and keyway, paired-wheel guide gaps, shaft bores, bearing recesses, track
lugs and treads, plus candidate battery/idler bounds. All five geometry tests
then passed. These checks cover represented features, not supplier conformity.

**Clash-resolution test-first update (2026-10-29):**
`node --test tool/cad-viewer/export.test.mjs` initially failed six assertions:
the old 180 mm/37-link geometry, narrow guide passage, old tray, axial overhang
and actual payload/track intersection. A further conservative 35 mm nominal
return-margin assertion failed before the upper axis was raised to Y = 515 mm.
Seven geometry tests then passed. Independent tangent/arc calculations from
exported mesh centers check 40-link closure and return clearances at 1 mm
steps through the provisional sweep; nominal margins also reserve the full
10 mm motion plus 5 mm deflection. Boolean intersections test payload/tray,
outboard body extraction, shaft/sun passage and track/guide material with a
0.01 mm³ float32-STL contact tolerance and a nonempty positive control.
This resolves the represented clashes only; it does not qualify missing mounts,
brake integration, printed capacity, tensioner mechanics or a complete vehicle.
Broader validation passed 12 CAD contract/geometry tests, all 16 browser component
routes and 42 BOM/presentation/reference tests. All 16 component exports and
13 generated documents were refreshed and freshness-checked.

**Structural supports test-first update (2026-10-29):**
`node --test tool/cad-viewer/export.test.mjs` first passed the seven existing
geometry checks. New regressions then failed on the motor's missing 12 mm
reaction-plate offset and four absent structural exports, before SCAD edits.
The first implementation exposed real rear-arm/extraction and rail/yoke-sweep
intersections; shortening the arm attachment and raising the front rails
resolved them without changing purchased-part dimensions. All 12 geometry
tests now pass, including nonempty exports, material/void probes, positive
fixed-frame connection volumes, nominal running clearance, extraction, and
31 moving-idler positions. Mesh checks use the same explicit 64-facet
tessellation and 0.01 mm³ float32 contact tolerance. The six added selectable
groups bring the viewer to 22 components. These are geometric results, not
strength, spring-rate, fatigue or complete-vehicle qualification.
