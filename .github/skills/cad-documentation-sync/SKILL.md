---
name: cad-documentation-sync
description: Keep MowerBot engineering documentation, OpenSCAD drawings and the local clickable 3D viewer in sync. Use after changing any docs/engineering/cad SCAD file, the viewer component map, a heading or section targeted by a CAD component, a module page with a 3D study table, or a decision that changes what the CAD represents.
---

# MowerBot CAD, Documentation and 3D Viewer Sync

## Scope and authority

Read `docs/index.md`, `docs/agents/project-guardrails.md` and
`docs/agents/documentation-guardrails.md`, then the
[CAD viewer guide](../../../docs/engineering/cad/README.md) and only the owning
module page. Load the [bom-documentation skill](../bom-documentation/SKILL.md)
for any Markdown or BOM edit; its regeneration and link checks still apply.

CAD is a fit study, not a release drawing. Syncing never authorizes purchasing,
fabricating, uploading, energizing or operating the machine.

Synchronization is agent-run: there is no watcher, git hook or CI job. Run the
sync command yourself before handoff whenever a trigger below applies.

## The three linked layers

| Layer | Owner | Must agree with |
| --- | --- | --- |
| Geometry | `docs/engineering/cad/*.scad`: `viewer_components` list and `pod_component(id)` dispatcher | Component map IDs |
| Component map | `docs/engineering/cad/viewer/components.json`: ID, label, color, `document#anchor` | SCAD IDs and real Markdown headings |
| Documentation | Module pages: **3D study** thumbnail tables after *Parts at a glance*; `viewer/previews/<id>.png` | Component map IDs |

Every component needs at least one Markdown entry point
(`cad/viewer/index.html?component=<id>`), and a linked thumbnail must show the
same component it opens.

## Workflow

1. **Classify the change**:
   - *Geometry only*: edit SCAD; regenerate exports.
   - *Component added, removed or renamed*: change the SCAD list, dispatcher
     and component map together; add, remove or rename its 3D study
     thumbnail in the owning module page.
   - *Heading moved or renamed, or section moved to another file*: update the
     component map `document#anchor`; keep same-file links filename-qualified.
   - *Decision or status change* (for example track width, wheel material,
     battery, brake or tensioner): update the CAD README and module-page
     notes that state what the CAD does **not** represent.
2. **Test first** when changing `tool/cad-viewer` code: add or update a failing
   `*.test.mjs` or browser assertion, run it, then implement.
3. **Never invent geometry** for an unmodeled or undecided part. Label it as
   unmodeled instead of adding a placeholder mesh.
4. Place thumbnails only in the owning scope, in its 3D study table directly
   after *Parts at a glance*; link other scopes to that section.
5. **Sync** from the repository root:

   ```sh
   npm run sync --prefix tool/cad-viewer
   ```

   It validates SCAD ↔ component map ↔ Markdown anchors and entry points,
   re-exports STL/PNG only when inputs are stale, then verifies freshness.
   Fix every reported mismatch at its owner; do not edit generated previews
   or `build/cad-viewer/state.json` by hand.
6. **Verify** before handoff:

   ```sh
   npm test --prefix tool/cad-viewer
   npm run check --prefix tool/cad-viewer
   npm run test:browser --prefix tool/cad-viewer
   python3 .github/skills/bom-documentation/scripts/update_costs.py
   python3 .github/skills/bom-documentation/scripts/update_costs.py --check
   python3 .github/skills/bom-documentation/scripts/test_bom_links.py
   git diff --check
   ```

   Run the browser test after component-map, anchor or viewer changes. Run the
   BOM steps after any Markdown edit. Restart a running viewer server after a
   component-map or geometry change.

## Handoff

Report the change class, affected components, whether exports regenerated and
which checks ran. List current decisions the CAD still does not model. Do not
commit unless asked.
