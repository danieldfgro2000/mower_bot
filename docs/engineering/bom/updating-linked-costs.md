# Updating linked costs

<a id="document-overview"></a>

**Summary:** Edit the [authoritative CSV inputs](updating-linked-costs.md#cost-inputs),
[regenerate linked Markdown tables](updating-linked-costs.md#regenerate-and-verify),
then [verify freshness and references](updating-linked-costs.md#reference-checks).
The generator owns derived totals; this guide does not authorize hardware or
supplier actions.

**Purpose:** maintain the BOM estimate when quantities, prices, module ownership
or source evidence change. This is a documentation procedure, not an
instruction to purchase parts, build, upload, energize or operate the machine.

**Contents:** [Cost inputs](updating-linked-costs.md#cost-inputs) ·
[Regenerate and verify](updating-linked-costs.md#regenerate-and-verify) ·
[Reference checks](updating-linked-costs.md#reference-checks) ·
[Validation history](updating-linked-costs.md#validation-history)

**BOM documents:** [BOM overview](../chassis-bom.md) ·
[Cost breakdown](../cost-breakdown.md) · [Supplier register](sources.md) ·
[Documentation index](../../index.md)

## Cost inputs

Edit numeric costs in their authoritative CSV, not in generated Markdown tables:

| Input file | What it owns |
| --- | --- |
| [Baseline item ledger](../chassis-bom.csv) | Item quantities, scenario unit/extended costs, basis codes, source IDs and assumptions |
| [Module mapping](cost-modules.csv) | Exactly-once item ownership, scope documents, cost categories and accounting disposition |
| [Budget allowances](budget-allowances.csv) | Non-material cash provisions |
| [Propulsion alternatives](propulsion-alternatives.csv) | Candidate replacements excluded from baseline totals |

Keep the [supplier evidence](sources.md) and affected scope requirements in
step with the inputs. Follow the [estimate rules](../chassis-bom.md#estimate-rules)
and the [BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md).
A sourcing request alone does not select a new hardware configuration.

[↑ Back to document overview](updating-linked-costs.md#document-overview)


## Regenerate and verify

From the repository root, regenerate and then check:

```sh
python3 .github/skills/bom-documentation/scripts/update_costs.py
python3 .github/skills/bom-documentation/scripts/update_costs.py --check
```

This updates the dedicated cost breakdown, module/category totals, accounting
totals, stages, cost-basis snapshot, candidate cost table, broader budget and
all eight scoped item-cost tables in one pass. Extensions must reconcile with
unit costs and quantities; missing purchase prices and missing/duplicate module
ownership fail explicitly. The 20% contingency is applied after the separately
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

[↑ Back to document overview](updating-linked-costs.md#document-overview)


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
heading IDs. Both `#section` and `other-file.md#section` must resolve; finding
the file alone is not sufficient. Inline/reference-style links, images, HTML
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
its label or purpose is clear. Keep same-page jumps under **On this page** and
document links under **BOM documents** or a scope directory. Check that a reader
can identify the owning document and distinguish estimates, requirements,
source evidence and maintenance instructions.

[↑ Back to document overview](updating-linked-costs.md#document-overview)


## Validation history

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

### Reference validation evidence

TDD evidence, 2026-10-26: regression fixtures first exposed accepted missing
cross-file anchors and headings hidden in comments or code fences, plus a
false failure for a valid underlined heading. After rendered-target validation,
all 15 reference regressions passed. A temporary copy of
[the main BOM](../chassis-bom.md) passes before removing `### Drive train` and
reports the broken `#drive-train` afterward; the live repository-test entry point
also rejects a missing cross-file fragment.

[↑ Back to document overview](updating-linked-costs.md#document-overview)
