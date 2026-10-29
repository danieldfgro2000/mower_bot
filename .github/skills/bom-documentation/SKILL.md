---
name: bom-documentation
description: Maintain MowerBot repository documentation and linked module BOM costs. Use when changing engineering documents, component quantities or prices, supplier evidence, BOM scopes, alternatives, budget allowances, or their cost summaries.
---

# MowerBot Documentation and BOM Maintenance

## Scope and authority

Read `docs/index.md`, `docs/agents/project-guardrails.md` and
`docs/agents/documentation-guardrails.md` before work, then only the owning scope.
For engineering BOM routing and module numbering, use
`docs/engineering/bom/agent-index.md` and `agent-guide.md`.
Read `docs/project/overview.md` and relevant `plan.md` sections for product,
hardware, safety or operating-envelope decisions. Preserve evidence labels,
release holds and unrelated edits. Documentation does not authorize purchasing,
fabricating, uploading, energizing or operating the machine.

For non-BOM documentation, maintain its authoritative owner and inbound links;
do not restructure unrelated documents or run BOM generation unnecessarily.

## BOM ownership

- `docs/engineering/bom/chassis-bom.csv`: authoritative baseline quantities,
  48 V unit/extended costs, basis codes, source IDs and assumptions.
- `docs/engineering/bom/cost-modules.csv`: exactly-once item ownership, module
  labels, scope links, display grouping and installed/bench/support disposition.
  Its `scope` values route to authoritative documents under the numbered
  `docs/engineering/modules/` folders.
  Inclusive `PREFIX-001:PREFIX-003` ranges and `|` unions are supported.
- `docs/engineering/bom/budget-allowances.csv`: non-material cash provisions.
- `docs/engineering/bom/propulsion-alternatives.csv`: candidate replacements,
  not additional purchases. Never merge into baseline sums without an explicit
  configuration decision and complete downstream re-costing.
- Module scope pages (`docs/engineering/modules/NN-name/*.md`): self-contained
  owners of single-scope supplier evidence (`### S##:` / `### U##:`), decision
  records (F/L), procurement packages (Q) and release holds (H), in the order
  Parts at a glance → studies → requirements → Sourcing → Procurement and
  release holds → Interfaces → generated costs → Decision records → Supplier
  evidence. Add new single-scope evidence there, not centrally.
- `docs/engineering/bom/sources.md`: sourcing weights and eligibility policy,
  the source-ID lookup, shared multi-module catalogs (S04, S06, S07) and link
  verification. Source IDs must be unique across `sources.md` and module pages;
  the generator fails on duplicates or missing IDs.
- `docs/engineering/bom/feedback.md` and `docs/engineering/chassis-build-requirements.md`:
  cross-module decisions/holds plus index tables linking to module-owned records.
- `docs/engineering/bom/updating-linked-costs.md`: human-facing maintenance
  procedure, input ownership, regeneration, reference checks and validation history.
- `docs/engineering/cost-breakdown.md`: generated focused view of detailed
  module costs and installed/bench/support totals. The main BOM remains estimate
  owner; keep its generated module totals and budget concise and link to this
  detailed view and technical scopes instead of duplicating itemized tables.
- Scope Markdown files: technical requirements and generated detailed costs.
  The main BOM contains generated linked module totals, evidence counts, stage
  costs, alternatives and broader budget. Present its generated major-module
  cost summary before broader budget allowances and contingency so readers see
  what each module costs. Link the module/category labels to their engineering
  scope documents and omit a duplicate Contents entry for the summary; reserve
  remaining navigation for other useful destinations. Generated baseline cost
  tables use one active 48 V value column. Keep alternative products in
  non-additive comparisons with appropriate unit/cumulative price columns.
  Do not restore retired voltage columns, `both variants`, or `Same as 48 V`
  placeholders without an explicit new configuration decision and corresponding
  input, generator and regression-test changes.
  For generated overview links, use file-only links to open scope summaries;
  avoid fragments to raw HTML overview IDs because heading-only readers may not
  resolve them. Use fragments only for Markdown headings.
  Do not edit generated blocks by hand.
- Use established canonical document and build-stage names from `docs/index.md`
  and `plan.md` consistently in titles, navigation/link labels, and generated
  tables. When a generated label changes, update its generator tests and
  regenerate; keep technical scope titles and cost-module labels distinct.
- When restructuring engineering scope pages, use a concise summary and a
  component-first scan view: current choice/status, cost and specification
  links, and mounting/connection routes. Follow the
  [component reading paths](../../../docs/engineering/bom/updating-linked-costs.md#component-reading-paths).
  Keep these routes beside component details and walk representative
  price/specification-to-fit journeys; valid links alone are insufficient.
  Remove overlapping navigation maps while preserving technical requirements,
  source evidence and release holds.

## Editing workflow

1. Establish whether the change is baseline, alternative, historical or an
   unqualified proposal. Do not infer a hardware upgrade from a sourcing request.
2. Update the owning input CSV and supplier evidence. Quote CSV fields that
   contain commas, and keep source IDs stable. Verify exact model/options,
   quantity tier, currency, tax, included contents and delivery exclusions;
   catalog leads are not quotes.
3. Recalculate baseline extensions from cumulative Stage 2 quantity and unit
   price, rounding half-up to cents. Stage 1 quantity is a subset, not an addition.
   `C`/`A` purchases require positive numeric prices. Only explained `I`/`R`
   lines may use `N/A` for both unit and extension. Unknown is never free.
4. Keep bundled BMS/charger costs bundled unless itemized evidence supports a
   split; do not invent separate prices or double-count kits. The current BMS
   summary note assumes BAT-001 includes it: revise that rule if the pack
   definition changes. The script's EUR5,000 comparison and 20% contingency
   are existing estimate policies, not component prices.
5. For new/moved items, update module coverage and primary specification
   ownership together. Maintain scope technical/specification links and release
   records. Every baseline item must belong to exactly one cost module. When
   moving authoritative BOM files, update generator input/output paths,
   regression fixture paths, and generated relative links together; assert the
   new locations in tests before regenerating and freshness-checking.
6. Run from the repository root:

   ```sh
   python3 .github/skills/bom-documentation/scripts/update_costs.py
   python3 .github/skills/bom-documentation/scripts/update_costs.py --check
   ```

   Generation updates eleven Markdown documents from the CSV owners. It refuses
   malformed prices, inconsistent extensions, missing/duplicate item coverage
   and missing generated-region markers. Fix the input; never suppress errors.
7. Review narrative amounts outside generated blocks in all affected scopes,
   source/feedback records and the main BOM. Update current statements or label
   historical figures rather than leaving contradictory costs. Generation
   deliberately does not rewrite engineering claims or supplier evidence.
8. After **every BOM documentation change**, run the repository-owned Python
   link test and `git diff --check`. The test enumerates every Markdown file
   under `docs/engineering/`, validates local files and same-/cross-file fragments
   against rendered GitHub-style headings and explicit anchors, and delegates
   only external URL reachability to the pinned HTTP checker. Every HTTP 4xx
   response is a failure. Follow the
   [reference-check setup](../../../docs/engineering/bom/updating-linked-costs.md#reference-checks)
   before the first run:

   ```sh
   python3 .github/skills/bom-documentation/scripts/test_bom_links.py
   git diff --check
   ```

   Same-document links must include the current Markdown filename before the
   fragment (for example, `scope.md#document-overview`); fragment-only links
   such as `#document-overview` fail this repository's reference validator.

   If the full module reports regression-fixture failures, run the focused
   repository audit separately:

   ```sh
   python3 .github/skills/bom-documentation/scripts/test_bom_links.py BomDocumentationLinkTest.test_every_engineering_markdown_reference_resolves -v
   ```

   Report both outcomes. A passing repository audit confirms document
   references only; it does not make the regression suite pass.

   Never skip the test because only prose, generated output, an anchor, a source
   URL, or a newly added document changed. Fix the reference or replace it with
   verified evidence; do not whitelist a broken or HTTP 4xx destination.
   A fragment is not a file: repair its target heading or link to the existing
   owning scope. Create a genuinely missing scope with corresponding details,
   not an empty placeholder. The test must remain read-only.
   Explain changed totals, reclassifications and unpriced exposure without
   claiming qualification.

## Generator changes

Follow repository TDD rules before changing executable logic. Run:

```sh
python3 -m unittest discover -s .github/skills/bom-documentation/scripts -p 'test_update_costs.py'
```

The tests cover module links, source-to-summary propagation, preserved totals,
non-additive alternatives, invalid input rejection and non-writing stale checks.
Use temporary copied documents, not live hardware or supplier transactions.
Reference-validator changes also require test-first regression fixtures:

```sh
python3 .github/skills/bom-documentation/scripts/test_bom_links.py BomReferenceRegressionTest -v
```

The link test uses Node.js 20+ with the parser dependencies locked in this
skill's `package-lock.json`; install with
`npm ci --prefix .github/skills/bom-documentation --ignore-scripts`.
External URL checks use `npx` and pinned `markdown-link-check@3.13.7`; remote-page
fragments are not validated. No third-party Python packages are required.

## Synchronization boundary

This is an agent workflow plus local generator, not a file watcher or CI job.
After every BOM edit, execute regeneration and check before handoff. Manual
changes made without running the command can remain stale; never claim otherwise.
Do not add automatic commits, CI writes or deployment as a side effect.
