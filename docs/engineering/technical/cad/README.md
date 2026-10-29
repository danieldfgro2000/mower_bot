# Interactive CAD and engineering documentation

**Summary:** Browse the current pod-fit SCAD study and its documentation side by
side in a local browser. The **Presentation / Engineering** selector switches
the selected component between its concise generated pitch card and detailed
technical section. Click a **3D thumbnail** in either view to select and frame
that component. No hosting or publishing is required.

**Status:** Unqualified sourcing-candidate fit study, not fabrication geometry
or authorization to build. It represents the 200 x 72 x 40 track, paired 120 mm printed
roller concept, paired 200 mm idler candidate, HPM5000B interfaces and current
DC HOUSE body envelope. **The represented solid clashes are cleared**, using a
raised fixed upper return and revised battery tray. U supports/axles, connected
tray frame, motor reaction plate and a spring-loaded sliding front idler are
now represented custom proposals. This is not a complete qualified machine:
brake, reducer supports, joints and actual spring specification remain open.
The BOM baseline is not changed by this candidate study.

## Modeled dimensions and limits

| Component | Relevant detail | Evidence / remaining assumption |
| --- | --- | --- |
| Track | 200 mm width, 72 mm pitch, 40 guide/tread positions; three-circle path, 2,880 mm nominal loop | [Track candidate](../modules/01-structure-and-running-gear/running-gear.md#pod-fit-cad-assumptions). Code interpretation and belt mid-thickness pitch line unconfirmed; 20 mm belt, 24 x 24 x 20 mm guide lugs and 6 mm tread height are schematic |
| Drive drum | Flexible 350 mm OD, 200 mm axial envelope, central guide relief and hollow running bands | No selected tooth profile or load path; 10 mm shell and 50 mm guide channel are placeholders |
| Idler | Two 200 mm OD wheels, each 50 mm tread / 60 mm hub, 20 mm bore; 160 mm total axial envelope | [Interwheel 161.540 candidate](../modules/01-structure-and-running-gear/running-gear.md#s37-bearing-wheel-roller-and-idler-candidates), not an approved fit. Hub OD is schematic |
| Lower rollers | Four paired assemblies, unchanged 120 x 50 mm wheels; 8 mm TPU tread, PC core, two 20 x 42 x 12 mm bearings per wheel; 150 mm pair width | [Printed-wheel concept](../modules/01-structure-and-running-gear/running-gear.md#s38-3d-printed-roller-wheels-owner-proposed). 50 mm tread-face guide gap and 1 mm bearing recess are study values, not print tolerances |
| Upper roller / support | Fixed paired 120 x 50 mm assembly at X = 200, Y = 515 mm; 6 mm U cheeks, 20 mm axle and bridge below wheels; inboard mast to Z = -116 mm | [Fixed upper proposal](../modules/01-structure-and-running-gear/running-gear.md#fixed-upper-roller-support). Capacity/joints unqualified; mast takes 16 mm of central space per pod |
| Motor | 206 x 126 mm body, 22.3 mm shaft / 53 mm projection, 5 x 43 mm keyway, four nominal M8 openings on 148 mm PCD | [Drawing evidence](../modules/02-drive-train/propulsion.md#s24-golden-motor-hpm5000b-family-specification). Hole depth, clocking and keyway axial offset are illustrative; threads and cooling details omitted |
| Battery | 504 x 268 x 233 mm body (length / transverse width / vertical height) | [DC HOUSE S30](../modules/04-battery-and-charging/batteries.md#s30-dc-house-100-ah-charger-bundle). Listing dimensions conflict with other supplier material; terminals, cables, handles and restraints need measured envelopes |
| Tray / battery position | 524 x 288 x 10 mm plate at Y = 140-150 mm; battery X = 35, Z = 44 mm, bottom Y = 150 mm | Custom proposal; 10 mm body-edge margins. Tray inboard edge matches the track at Z = -100 mm; extra width goes outboard |
| Lower U supports | Four pairs of 6 mm cheeks, 20 mm axles, 6 mm top bridges at Y = 134-140 mm | [Support details](../modules/01-structure-and-running-gear/running-gear.md#lower-support-rollers); 5 mm tire-side and 4 mm bridge/tread gaps; bearing fits, retention and loads unqualified |
| Tray frame / motor plate | Rear arms through drum relief, stepped side rails to front guide blocks; 250 mm OD x 12 mm motor plate, 148 mm mounting PCD | [Frame proposal](../modules/01-structure-and-running-gear/frame.md#connected-pod-frame-proposal); motor moves 12 mm outboard, reducer positions unchanged; fixed-ring and brake mounts still absent |
| Idler carriage / spring | 6 mm yoke, two 10 mm guide rods / 11 mm sleeve bores, +/-15 mm stop positions; 36 mm OD coil / 4 mm wire, six active turns + two end rings | [Carriage](../modules/01-structure-and-running-gear/running-gear.md#sliding-idler-carriage) / [spring](../modules/01-structure-and-running-gear/running-gear.md#spring-tensioner-concept); 72.356 mm nominal seat gap, 57.356-87.356 mm geometric range; no rate/preload or selected commercial spring |

Drive and idler axes are at X = -440 and +419.356 mm: **859.356 mm spacing**.
The exact three-circle external tangents and wrap arcs close the nominal loop
to within 0.02 mm; guide positions follow actual segment lengths, not an
equal-wheel approximation. The belt-body longitudinal envelope is approximately
**1,174 mm**, before tread projections. Overall track height is about **617 mm**.

| Clearance / change | Revised result | Provisional requirement |
| --- | ---: | --- |
| Battery to front / rear continuous guide-tip return envelopes | 40.1 / 36.0 mm normal to the runs | 35 mm nominal = 20 running + 10 motion allowance + 5 deflection/tolerance reserve |
| Conservative return clearance after both allowances | **21.0 mm minimum** | 20 mm; assumptions need actual track data |
| Fixed upper wheel to battery | 72 mm | 20 mm |
| Lower rollers to tray / battery | 10 / 20 mm | 10 / 20 mm |
| Adjacent lower rollers | 23.1 mm; last axle 15 mm rearward for idler yoke | 10 mm |
| Battery to drive / idler physical envelopes | 48.0 / 38.3 mm | 20 mm |
| Guide lateral gap, each side | 13 mm at lower/upper wheels and drum; 8 mm at idler hubs | 5 mm |
| Motor + reaction plate + stages + carrier | 206 mm stack; 12 mm outboard projection, **6 mm inboard remainder** | 5 mm; excludes brake/reducer supports |
| U bridges to lower / upper wheels | 4 / 9 mm | 3 / 5 mm provisional running gaps |
| Front stepped rails to moving yoke | 5 mm vertical | 5 mm provisional; checked through +/-15 mm X stroke |
| Guide rod to sleeve bore | 0.5 mm radial | Study clearance only; not a selected sliding-bearing fit |

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

The outboard battery-body extraction prism clears represented running gear,
frame, U supports, mast and spring/carriage; terminals, restraints, handles,
guards and the rest of the machine are excluded. The battery bottom rises
from 100 to 150 mm versus the previous
clashing study, raising its body CG 50 mm. The outboard offset and track mass
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
  coordinates, in millimetres. Planetary pitch-circle studies are grouped by
  stage; the four lower rollers are separate exports. The removal arrow is
  explicitly an annotation, not a physical part.
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
The [presentation catalog](../../presentation/catalog.json) owns concise
pitch facts, which are checked against technical evidence during generation.
The [SCAD source](module-01-track-pod-fit.scad) owns all geometry. Unmodeled
components have no invented mesh.

## Refresh and verify

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
re-exports only when stale: separate binary STL files and a freshness manifest
go to ignored `build/cad-viewer/`, and thumbnails go to `viewer/previews/`. `npm run check`
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
