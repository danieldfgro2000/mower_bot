# Updating linked costs

<a id="document-overview"></a>

**Summary:** Keep estimate inputs, generated tables, and references in sync.
The generator owns derived totals; this guide authorizes no supplier or hardware
actions.

**On this page:** [Cost inputs](updating-linked-costs.md#cost-inputs) ·
[Component reading paths](updating-linked-costs.md#component-reading-paths) ·
[Readable navigation](updating-linked-costs.md#navigation-labels-and-stable-references) ·
[Regenerate and verify](updating-linked-costs.md#regenerate-and-verify) ·
[Reference checks](updating-linked-costs.md#reference-checks) ·
[Validation history](updating-linked-costs.md#validation-history)

**Related documents:**
[Engineering BOM agent guide](agent-guide.md) ·
[Agent index](agent-index.md) ·
[Chassis BOM](chassis-bom.md) ·
[BOM Cost Breakdown](../cost-breakdown.md) ·
[Supplier register](sources.md)

## Cost inputs

Edit numeric costs in their authoritative CSV, not in generated Markdown tables:

| Input file | What it owns |
| --- | --- |
| [Cost ledger](chassis-bom.csv) | Item quantities, active 48 V unit/extended costs, basis codes, source IDs and assumptions |
| [Module mapping](cost-modules.csv) | Exactly-once item ownership, module/submodule numbering, module-folder scope routes, cost categories and accounting disposition |
| [Budget allowances](budget-allowances.csv) | Non-material cash provisions |
| [Propulsion alternatives](propulsion-alternatives.csv) | Candidate replacements excluded from baseline totals; `technical_reference` links to the owning engineering detail |

Keep supplier evidence (in the owning module page, or [Sources](sources.md)
for shared catalogs) and affected scope requirements in step with the inputs. Follow the [estimate rules](chassis-bom.md#estimate-rules)
and the [BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md).
A sourcing request alone does not select a new hardware configuration.

The active ledger uses `unit_eur_48v`, `extended_eur_48v` and `basis_48v`;
budget allowances use `eur_48v`. The higher-voltage columns and their
external-drive-only lines have been retired. Generated cost tables contain
one 48 V value column, not duplicated values or "Same as 48 V" placeholders.
Keep alternative packs and drives outside baseline sums unless a new
configuration decision explicitly replaces the selected budget item.

[↑ Back to document overview](updating-linked-costs.md#updating-linked-costs)


## Navigation labels and stable references

Open each engineering document with a short summary. Technical scopes then
show **Parts at a glance**; maintenance/history pages keep task or evidence
routes appropriate to their purpose. Keep secondary local jumps under
**Further detail** or **On this page**, not ahead of the useful part view.
The [module directory](../modules/README.md#module-directory) shows
component-to-component routes rather than repeating the specification index. Link the topic itself:
[Workshop tools (PS36)](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools),
not just its requirement code. Supplier, decision, request, and hold references
also need meaningful names.

New fragment links target Markdown headings so heading-only readers can resolve
them. Keep old explicit anchors for inbound compatibility, not as the primary
navigation targets.

| Navigation surface | Owner and maintenance rule |
| --- | --- |
| Generated cost headings | The [module map](cost-modules.csv) owns human-readable numbered labels. Generated links target those headings; legacy `cost-<module_id>` anchors remain for existing links. |
| Cost-item links to requirements | Each scope owns plain-text `### PS##: Name` headings and the following `**Cost-ledger coverage:**` line. The generator derives the heading link and requires every scope item to have exactly one requirement owner. |
| Requirement coverage | Use inclusive item ranges and `\|` unions, as in the module map. A family without purchases uses `None;` followed by its explanation; it must not claim priced items. |
| Supplier names and IDs | Descriptive `### S##: Name` / `### U##: Name` headings live in the owning module page's **Supplier evidence** section, or in [Sources](sources.md#source-id-lookup) for shared catalogs; IDs must be unique across both. Link to the named headings and preserve `s##` / `u##` aliases for existing source links. |
| Alternative technical detail | `technical_reference` in the [alternatives CSV](propulsion-alternatives.csv) is relative to that CSV's `bom/` directory and points to a module Markdown section. Keep `product_url` for supplier evidence; neither field changes the non-additive cost treatment. |
| New or renamed detail sections | Update the local topic map and inbound links together; link a section for a specific topic and a file for a scope overview. |

Keep detailed requirements, supplier limitations, calculations, and release
holds in their owning sections. Summaries should link to those details, not
silently replace them or turn a study into an approved design. Generated tables
are still outputs: edit the owner and regenerate rather than hand-editing links.

### Component reading paths

The reader should be able to **scan a part → inspect price and specifications
→ move to its mounting or connected component** without returning to an index.
A complete contents list and valid links alone do not satisfy this use case.

| At the reading point | What to provide |
| --- | --- |
| Scope opening | Named physical parts or actual models, current choice/status, direct cost/data links, and the next fit/connection. Explicitly label study candidates, costed alternatives, reused inventory and unselected parts. |
| Component detail or supplier record | Local **Part links**, **Inspect**, or **Continue** routes to that part's price, specifications, and physical/electrical interfaces. Do not send the reader to a whole document when a relevant section exists. |
| Prices | Say unit versus pair/cumulative total, allowance versus supplier reference, what is included, and what is unpriced. Keep generated totals owned by the CSVs and review narrative amounts when inputs change. |
| Mounting/connection detail | Separate the documented concept, required interfaces, and missing dimensions/ratings. Link both directions between the part and its adjoining assembly; do not manufacture a design to complete the route. |
| Long pages and repeated maps | Prefer one useful part scan table to several overlapping requirement directories. Preserve detailed evidence and stable destinations below it. |

Before handoff, walk real reading paths from the rendered sections, not only
whole-file link presence. The minimum checks for this package are:

- [HPM5000B](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate)
  → price/specifications → [motor-to-track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting)
  → [frame plates](../modules/01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates)
  and [drum engagement](../modules/01-structure-and-running-gear/running-gear.md#drive-drum-study).
- [Battery](../modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive)
  → cost/data → [pod fit and restraints](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit).
- [Width motor](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor)
  → cost/data → screw supports → scissor pivots/holding.
- [Power connector](../modules/05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness)
  → cost/requirements → [crimp tooling](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools),
  with a route back to the connector.
- [E-stop](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control)
  → hardware cost/requirements → contactor and brake interfaces.

Confirm that the destination actually explains the requested detail and leaves
unknowns explicit. Link reachability is still required, but is a separate check.

[↑ Back to document overview](updating-linked-costs.md#updating-linked-costs)


## Regenerate and verify

From the repository root, regenerate and then check:

```sh
python3 .github/skills/bom-documentation/scripts/update_costs.py
python3 .github/skills/bom-documentation/scripts/update_costs.py --check
```

This updates BOM Cost Breakdown, module/category totals, accounting totals,
stage acquisitions, cost-basis snapshot, candidate cost table, broader budget and
all nine scoped item-cost tables and their requirement links in one pass.
Extensions must reconcile with unit costs and quantities; missing purchase
prices, missing/duplicate module ownership, and missing/duplicate specification
coverage fail explicitly. The 20% contingency is applied after the separately
sourced cash provisions.

**This is not a live spreadsheet or watcher.** Edits outside this workflow need
the same command before tables are current. `--check` reports stale documents
without changing them. The generator never selects hardware or rewrites
engineering assumptions.

Review the diff and reconcile narrative amounts, supplier evidence and
technical requirements outside generated blocks. Preserve evidence labels
and release holds. Then run the [reference checks](updating-linked-costs.md#reference-checks).

When changing the generator, also run its regression suite:

```sh
python3 -m unittest discover -s .github/skills/bom-documentation/scripts -p 'test_update_costs.py'
```

[↑ Back to document overview](updating-linked-costs.md#updating-linked-costs)


## Reference checks

Run the Python reference test after **every BOM documentation change**. It
checks every Markdown file under `docs/engineering/`, including newly added
scope documents. Python uses only its standard library; Markdown rendering
requires Node.js 20+ and the locked parser dependencies. Install them once per
checkout, and again after a parser dependency/lockfile change:

```sh
npm ci --prefix .github/skills/bom-documentation --ignore-scripts
```

From the repository root:

```sh
# Regression fixtures, including local HTTP failure responses
python3 .github/skills/bom-documentation/scripts/test_bom_links.py BomReferenceRegressionTest -v
# Regression fixtures plus the complete engineering reference audit
python3 .github/skills/bom-documentation/scripts/test_bom_links.py
git diff --check
```

**Local targets:** the test renders Markdown with pinned `marked` and
`marked-gfm-heading-id`, then checks links against actual files and rendered
heading IDs. Same-page links must include their document name
(`scope.md#section`), as must cross-file links (`other-file.md#section`);
fragment-only links are rejected to preserve document context. Finding the
file alone is not sufficient. Inline/reference-style links, images, HTML
links and explicit anchors, encoded paths, formatted/duplicate headings and
underlined headings are covered. Code samples and comments cannot satisfy a
missing heading.

**External targets:** `npx` runs pinned `markdown-link-check@3.13.7` for URL
reachability only, not remote-page fragment validation. Every HTTP 4xx response
is a failure, including access-blocked supplier pages. Failure diagnostics are
checked even when that tool returns exit status zero.

**Repair, then rerun:** failures identify the referring document, destination
and missing file or anchor. A fragment such as `#drive-train` refers to a
section, not a separate file. Restore the corresponding section or link to its
existing authoritative scope. If a scope document is genuinely missing, create
it with the corresponding item costs, source evidence, specification/inspection
requirements and interfaces; keep unknowns and release holds explicit. Do not
create an empty placeholder, duplicate an existing scope, or hide a broken
reference. Regenerate the linked costs and rerun the checks after repair.
The test itself is read-only: it neither creates missing documents nor changes
prices, requirements or release status.

**Readability review is separate:** a valid destination does not establish that
its label or purpose is clear. Follow the
[navigation-label rules](updating-linked-costs.md#navigation-labels-and-stable-references)
and walk the [component reading paths](updating-linked-costs.md#component-reading-paths).
A generic requirement paragraph, another index, or a link count is not a
substitute for the requested price, technical data, or connection detail.

[↑ Back to document overview](updating-linked-costs.md#updating-linked-costs)


## Validation history

### Single-scenario cost migration

**2026-10-28 scope:** Retire the higher-voltage active ledger/reporting path,
preserving 48 V arithmetic, item/specification ownership, alternatives and
non-writing freshness behavior.

**Red:** Added `test_active_cost_inputs_are_48v_only` and
`test_48v_only_inputs_generate_single_scenario_tables`, then ran them before
implementation. They failed because both CSV owners still contained `72v`
fields and the generator required `unit_eur_72v` for a 48 V-only fixture.

**Green and refactor:** Migrated the CSV owners, retired DRV-007–011 (all had
N/A 48 V purchase costs), narrowed the existing reduction-hardware module to
DRV-012, and removed the unused multi-scenario rendering helpers. Both new
cases and the full **17-test generator suite passed**:

```sh
python3 -m unittest discover -s .github/skills/bom-documentation/scripts -p 'test_update_costs.py'
```

The migration alone preserved the €12,888.82 materials total. The separately
documented pack/charger substitution then increased it to €13,879.10.
Regression expectations retain fixed non-battery module checks and derive
overall/stage totals from the fixture's current 48 V values, rather than
retaining obsolete second-scenario snapshots. Cost propagation, invalid-price
rejection, ownership failures and read-only stale checks remain covered.
Generation, freshness checking and `git diff --check` also passed after the
pricing update. Reference validation remains the separate required gate above;
these results establish no hardware qualification.

**Records:** [Original generator checks](updating-linked-costs.md#generator-validation-evidence) ·
[Readable-navigation regression](updating-linked-costs.md#readable-navigation-regression) ·
[Component-focused follow-up](updating-linked-costs.md#component-focused-reading-pass) ·
[Reference-validator evidence](updating-linked-costs.md#reference-validation-evidence).

### Generator validation evidence

TDD evidence, 2026-10-26: the initial executable scaffold ran but failed the
expected module-link, cost-propagation, stale-table and invalid-input assertions.
After implementation, the focused suite passed. A separate category-subtotal
assertion then failed before subtotal generation was added and passed afterward.
Coverage includes unchanged baseline sums, updates reaching scope and summary,
non-additive alternatives, missing prices, inconsistent extensions, unmapped or
multiply owned items, and missing markers without partial output writes.
No application build or hardware test is implied.

Naming refactor, 2026-10-26: the same eight regression checks passed before
and after renaming the documents and updating generator paths. The item ledger
schema and its numeric content are unchanged; build-phase column names remain
compatible with the existing cost model.

### Readable-navigation regression

TDD evidence, 2026-10-28: the
[generator regression suite](../../../.github/skills/bom-documentation/scripts/test_update_costs.py)
first failed on opaque generated headings, missing item-to-requirement links,
the HPM5000B link opening CSV instead of technical detail, rejection of named
source headings, and accepted missing/duplicate specification coverage.
After the [generator update](../../../.github/skills/bom-documentation/scripts/update_costs.py),
all 15 tests passed, including unchanged baseline/budget totals and non-additive
alternatives. Existing cost anchors and source IDs remain stable.

The heading-only reader follow-up first failed three generated-link assertions
that still targeted legacy HTML anchors. Those assertions passed after generated
links targeted the readable Markdown headings. Narrative links use those
headings too; the legacy anchors remain for compatibility.

In that first navigation pass, the full 18-test reference suite passed, including the live engineering-document
audit. Regeneration/freshness covered all eleven generated documents; the
readability pass covered all 26 engineering Markdown files and preserved every
pre-existing rendered heading/anchor. Opening summaries are at most 61 words
in this revision. These checks do not refresh supplier prices or qualify hardware.

The navigation pass also reconciles old narrative line-count and loose-handling
descriptions with the current ledger and dated workshop decision; it does not
change quantities, prices, hardware choices, or release status.

### Component-focused reading pass

Follow-up, 2026-10-28: the reader feedback required more than navigable section
directories. All nine technical scopes now open with physical parts, current
choices/status, cost/data links, and fit/connection routes. Module overviews,
the main BOM, source lookup, and supporting pages route into those part views
instead of repeating full requirement indexes.

Section-local reading walks covered HPM5000B price/specifications → track
mounting → frame plates/drum and back; battery → pod fit; width motor → screw
→ scissor pivots; connector ↔ crimp tools; E-stop ↔ contactor/brake; and
sensors/logger → measurement tools. The motor interface map distinguishes the
known layout from missing mounting drawings and dimensions. No new hardware
selection or mounting design is implied.

This follow-up changed no executable logic or CSV inputs. The 15 generator
checks, regeneration/freshness, and full 18-test reference suite passed; legacy
anchors, generated monetary values, and all four input-file fingerprints were
preserved. These are navigation and preservation checks, not hardware evidence.

### HPM5000B drivetrain baseline evidence

2026-10-28: `CostDocumentationTest.test_selected_drive_components_and_battery_accounting`
first failed on the old motor/controller/brake identities and missing unpriced
reduction disclosure. After the approved DRV-001:DRV-003 substitutions, all
18 generator tests passed. Regeneration and `--check` passed for all eleven
outputs; the full 18-test reference suite and `git diff --check` passed.
No generator logic or schema changed.

The ledger comparison confirmed only those three rows changed, with battery
bundle/included-charger accounting and every other row preserved. USD conversion,
EUR brake VAT, rounded unit extensions, €10,584.10 materials and €13,756.92
indicative budget were checked. ALT-DRV-002 remains excluded from baseline
totals. Reading paths now connect the selected motor/controller/brake prices
to motor-to-track and motor-to-brake fit, with the old HPM heading retained as
a historical anchor. These checks do not qualify hardware; custom reduction
and brake integration remain unpriced.

### Reference validation evidence

TDD evidence, 2026-10-26: regression fixtures first exposed accepted missing
cross-file anchors and headings hidden in comments or code fences, plus a
false failure for a valid underlined heading. After rendered-target validation,
all 15 reference regressions passed. A temporary copy of
[BOM Cost Breakdown](../cost-breakdown.md) passes before removing
`### 02 — Drive train` and reports the broken
`cost-breakdown.md#02--drive-train` afterward; the live repository-test entry
point also rejects a missing cross-file fragment.

### Module-owned evidence regrouping

TDD evidence, 2026-10-29: generator tests first failed for a source entry moved
into a module page, a duplicate entry across documents and a missing entry.
`load()` now collects `### S##:` / `### U##:` headings from `sources.md` and
every module page and rejects duplicates. Single-scope supplier evidence,
decision records, procurement packages and release holds then moved into
their module pages; the per-module README overviews were folded into the
[module directory](../modules/README.md#module-directory). Central pages keep
policy, ID indexes and cross-module records. Costs and the baseline ledger
were unchanged.

[↑ Back to document overview](updating-linked-costs.md#updating-linked-costs)
