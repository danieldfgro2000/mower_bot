# Interactive CAD and engineering documentation

**Summary:** Browse the current pod-fit SCAD study and its owning Markdown
sections side by side in a local browser. Click a component in the 3D view to
open its documentation; click a **3D thumbnail** in the rendered documentation
to select and frame that component. No hosting or publishing is required.

**Status:** Concept visualization only. These are the existing study envelopes,
not fabrication models, verified fit, or authorization to build. The CAD still
uses the historical 200 mm track, 350 mm end rollers, 80 mm support rollers and
battery envelope. It does **not** implement the current 180 mm track preference,
120 mm printed-wheel choice, holding brake or upper tensioner.

## Open the local viewer

From the repository root, with Node.js 20+ and the `openscad` executable installed:

```sh
npm ci --prefix tool/cad-viewer --ignore-scripts
npm run export --prefix tool/cad-viewer
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

[![3D motor body](viewer/previews/motor.png)](viewer/index.html?component=motor)

**Click the motor thumbnail above** to frame the HPM5000B and open its
[price, specification and mounting documentation](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate).
The same thumbnail route is available beside the motor in its owning scope.

- Drag to orbit, scroll to zoom, right-drag to pan.
- Click a visible mesh to open its owning section without leaving the viewer.
- Use **Component** for enclosed parts; **Isolate selection** or component
  visibility controls remove occluding parts. **Fit view** frames the selection;
  **Reset assembly** restores all geometry.
- **Selected STL** downloads just that component in the original assembly
  coordinates, in millimetres. Planetary pitch-circle studies are grouped by
  stage; the four lower rollers are separate exports. The removal arrow is
  explicitly an annotation, not a physical part.
- Markdown links keep their scope and fragment in the reader. Browser Back and
  Forward restore the document/selection; the address can be bookmarked.

The [component map](viewer/components.json) owns each selectable ID, label,
color and exact documentation section. The
[SCAD source](module-01-track-pod-fit.scad) owns all geometry. Unmodeled
components have no invented mesh.

## Refresh and verify

After changing SCAD geometry, the component map, a targeted documentation
heading or a 3D study table, follow the
[CAD documentation sync skill](../../../.github/skills/cad-documentation-sync/SKILL.md)
and run one command:

```sh
npm run sync --prefix tool/cad-viewer
```

It checks that SCAD selectors, the component map, documentation anchors and
Markdown 3D links agree. Each component must have a Markdown entry point, and
each linked thumbnail must open its own component. It re-exports only when
stale: separate binary STL files and a freshness manifest go to ignored
`build/cad-viewer/`, and thumbnails go to `viewer/previews/`. `npm run check`
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

**Validation (2026-10-29):** All six contract/export tests pass, including the
unchanged assembly envelope and unknown-selector rejection. The browser check
passes thumbnail-to-model navigation, motor mesh raycasting, all 15 documentation
routes, section scrolling, bookmarks, Back/Forward, missing-document errors and
narrow layout. A delayed-document regression first restored the obsolete motor
URL after selecting the track; it now preserves the latest navigation. Export
freshness, JavaScript syntax, linked-cost freshness and engineering references
also pass. These software checks do not qualify physical geometry or operation.
