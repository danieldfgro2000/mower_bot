---
name: cad-documentation-sync
description: Keep MowerBot engineering documentation, OpenSCAD drawings and the local clickable 3D viewer in sync, and resolve dependent component interference after geometry or component changes. Use when replacing or resizing a battery, track, roller, idler or motor; changing a CAD file or component map; or editing linked documentation and 3D study tables.
---

# MowerBot CAD Fit and Documentation Sync

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

**Fit is part of the change, not a separate optional task.** When a component
changes, adjust the dependent layout and flexible dimensions until the modeled
assembly meets its clearance requirements. Do not finish with only a clash
report when a feasible adjustment is within scope. The sync command checks
links and export freshness; it does **not** solve or certify physical fit.

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
   - *Geometry or component dimensions*: run the fit-adjustment loop below,
     edit dependent SCAD geometry and documentation, then regenerate exports.
   - *Component added, removed or renamed*: change the SCAD list, dispatcher
     and component map together; add, remove or rename its 3D study
     thumbnail in the owning module page.
   - *Heading moved or renamed, or section moved to another file*: update the
     component map `document#anchor`; keep same-file links filename-qualified.
   - *Decision or status change* (for example track width, wheel material,
     battery, brake or tensioner): update its evidence/status and modeled
     representation. If it changes fit, run the fit-adjustment loop; update
     the CAD README and module-page notes for anything still unmodeled.
2. **Test first** for SCAD geometry as well as `tool/cad-viewer` code: add or
   update a failing geometry/clearance test in `tool/cad-viewer/*.test.mjs`
   (or a browser assertion for viewer behavior), run it, then implement.
3. **Preserve evidence boundaries.** Do not invent supplier dimensions.
   Custom geometry needed for fit may be developed as a clearly labeled
   proposal, not a released part. Keep unknown purchased-part interfaces
   explicitly unmodeled rather than adding a convincing but unsupported mesh.
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

## Fit-adjustment loop

1. **Separate fixed inputs from design variables.** Read the owning module
   evidence and relevant `plan.md` constraints. Preserve actual purchased or
   sourced component dimensions, owner-fixed choices and safety requirements.
   Treat documented flexible placeholders as adjustable, not immutable targets.
   A larger battery must not be scaled down to retain the old layout.
2. **Trace the dependent package.** For a battery change, check the enclosure,
   carrier, mounts, lower rollers, upper return, guide lugs, tensioner sweep,
   terminals/cables and removal path. For motor, roller or idler changes, also
   check shafts, bearings, guide gaps, drum/reducer/brake stack and track path.
   Distinguish intentional contact, engagement and mounting interfaces from
   forbidden solid interference.
3. **Define acceptance before editing.** Specify numeric minimum margins for
   solid clearance, guide passage, moving sweeps and installation/service
   access. Include relevant tolerances, belt deflection and tensioner travel.
   Use justified, explicitly provisional margins when data is missing; a
   zero-gap screenshot is not clearance evidence. If essential geometry or a
   defensible margin is unavailable, state what cannot be checked.
4. **Adjust, recalculate and iterate.** Reposition components or revise custom
   carrier geometry, axle spacing, roller width/diameter, idler diameter or
   track size where those remain flexible. Start with the smallest practical
   change, but do not preserve a placeholder at the expense of fit. Never
   alter a catalog part's geometry to pretend it is still the same product:
   use a real alternative under the existing listed-price sourcing policy.
   A different commercial belt must have a supported width/pitch and integer
   link count; do not stretch it or invent a purchasable loop length.
5. **Recheck consequences, not only the original clash.** Recompute unequal
   end-wheel tangencies, wrap and loop length, ground/support contact, guide-lug
   passage, roller spacing, tension adjustment, motor/reducer/brake clearance
   and battery extraction. Revisit gearing/speed, load capacity, stability/CG,
   overall width and cost wherever the adjustments affect them. Do not remove
   a functional component or bypass a safety requirement to obtain clearance.
6. **Prove the revised fit.** Iterate until every affected modeled clearance
   meets its stated margin without creating a new clash. Use numeric geometry
   checks or mesh intersection/distance checks, plus assembly inspection;
   component bounding boxes and successful exports alone are insufficient.
   Replace tests that require the current assembly to collide with positive
   clearance regressions; preserve an old collision as a separate historical
   fixture only if useful. Keep valid component-dimension assertions.
7. **Synchronize the result.** Update parameter relationships, SCAD, component
   map, thumbnails, owning module dimensions, fit notes and affected cost
   evidence together, then run the workflow's sync and verification steps.
   Candidate studies must not silently change the approved/costed baseline.
   Preserve dated history, but remove current claims that a now-resolved clash
   is intentional or must remain.

Proceed with flexible study adjustments without seeking approval for each
parameter. Ask for a decision when the remaining solution would change a fixed
owner choice, architecture, safety constraint or baseline purchasing scope.
If no feasible solution exists within those boundaries, report the attempted
adjustments, remaining interference and exact decision/data needed; do not
hide it or claim fit. Geometric clearance remains a study result, not structural
qualification or authorization to manufacture.

## Handoff

Report affected components and dependent adjustments, before/after dimensions,
minimum clearances versus their required margins, and which dimensions remain
assumptions. Include export/check outcomes and unmodeled interfaces. Explicitly
mark any unresolved fit as blocked, not complete. Do not commit unless asked.
