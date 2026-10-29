# MowerBot Engineering

<a id="document-overview"></a>

**Summary:** Engineering starting point for the MowerBot tracked chassis: what
is being designed, where each part family is documented, and how to open the
clickable 3D CAD viewer. Everything here is a **costed study, not released for
purchase, fabrication or operation**.

**On this page:** [Engineering summary](README.md#engineering-summary) ·
[3D CAD viewer](README.md#3d-cad-viewer) ·
[Where to go next](README.md#where-to-go-next)

## Engineering summary

- **Machine:** two tracked pods joined by a width-adjustable scissor frame,
  on an active 48 V battery baseline. See the
  [width and slope feasibility screen](width-and-slope-sizing.md) for the
  packaging and 40° site target.
- **Build stages costed:** Stage 1 bench propulsion prototype and Stage 2
  rolling two-pod chassis. Mower integration and autonomy are excluded. Totals
  per module are in the [Chassis BOM](bom/chassis-bom.md#estimate-at-a-glance).
- **Current part choices** live in each module's *Parts at a glance*:
  [running gear](modules/01-structure-and-running-gear/running-gear.md#parts-at-a-glance)
  (tracks, drum, idlers, printed roller wheels),
  [drive train](modules/02-drive-train/propulsion.md#parts-at-a-glance)
  (HPM5000B motor candidate, reduction, brakes) and
  [batteries](modules/04-battery-and-charging/batteries.md#parts-at-a-glance).
- **Open items:** custom reduction and brake installation are unpriced, and
  release holds remain open in the
  [build and procurement checklist](chassis-build-requirements.md).
- **CAD status:** the 3D fit study uses historical dimensions and does not yet
  model every current choice; see the [CAD guide](cad/README.md).

## 3D CAD viewer

Run from the repository root. First-time setup needs Node.js 20+ and
`openscad` on `PATH`:

```sh
npm ci --prefix tool/cad-viewer --ignore-scripts
```

**Start** (regenerates models only when stale, then serves the viewer):

```sh
npm run sync --prefix tool/cad-viewer
npm start --prefix tool/cad-viewer
```

Open <http://127.0.0.1:8765/>. Set `PORT` to use another port.

**Stop:** press Ctrl+C in the terminal running the server. If it runs in the
background (macOS/Linux), stop it by port:

```sh
kill $(lsof -ti tcp:8765 -sTCP:LISTEN)
```

**After editing `.scad` files, the component map or linked headings:** run
`npm run sync --prefix tool/cad-viewer` and restart the server. The
[CAD documentation sync skill](../../.github/skills/cad-documentation-sync/SKILL.md)
lists the full checks. The [CAD guide](cad/README.md) covers viewer controls
and troubleshooting.

## Where to go next

| I want to… | Open |
| --- | --- |
| Inspect a part family's choices, prices and fit | [Module directory](modules/README.md) |
| See cost totals and budget | [Chassis BOM](bom/chassis-bom.md) · [Cost breakdown](cost-breakdown.md) |
| Check what blocks purchase or build | [Build and procurement checklist](chassis-build-requirements.md) |
| Change costs or supplier evidence | [Updating linked costs](bom/updating-linked-costs.md) |
| Route an agent BOM task | [BOM agent index](bom/agent-index.md) |

[↑ Back to document overview](README.md#mowerbot-engineering)
