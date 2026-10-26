---
name: bom-documentation
description: Maintain MowerBot repository documentation and linked module BOM costs. Use when changing engineering documents, component quantities or prices, supplier evidence, BOM scopes, alternatives, budget allowances, or their cost summaries.
---

# MowerBot Documentation and BOM Maintenance

## Scope and authority

Read `docs/index.md`, `docs/agents/project-guardrails.md` and
`docs/agents/documentation-guardrails.md` before work, then only the owning scope.
Read `docs/project/overview.md` and relevant `plan.md` sections for product,
hardware, safety or operating-envelope decisions. Preserve evidence labels,
release holds and unrelated edits. Documentation does not authorize purchasing,
fabricating, uploading, energizing or operating the machine.

For non-BOM documentation, maintain its authoritative owner and inbound links;
do not restructure unrelated documents or run BOM generation unnecessarily.

## BOM ownership

- `docs/engineering/chassis-bom.csv`: authoritative baseline quantities,
  scenario unit/extended costs, basis codes, source IDs and assumptions.
- `docs/engineering/bom/cost-modules.csv`: exactly-once item ownership, module
  labels, scope links, display grouping and installed/bench/support disposition.
  Inclusive `PREFIX-001:PREFIX-003` ranges and `|` unions are supported.
- `docs/engineering/bom/budget-allowances.csv`: non-material cash provisions.
- `docs/engineering/bom/propulsion-alternatives.csv`: candidate replacements,
  not additional purchases. Never merge into baseline sums without an explicit
  configuration decision and complete downstream re-costing.
- `docs/engineering/bom/sources.md`: dated supplier evidence and price limits.
- `docs/engineering/cost-breakdown.md`: generated focused view of major and
  detailed module costs; `docs/engineering/chassis-bom.md` remains the main
  estimate owner.
- Scope Markdown files: technical requirements and generated detailed costs.
  The main BOM contains generated linked module totals, evidence counts, stage
  costs, alternatives and broader budget. Present its generated major-module
  cost summary before broader budget allowances and contingency so readers see
  what each module costs. Do not edit generated blocks by hand.

## Editing workflow

1. Establish whether the change is baseline, alternative, historical or an
   unqualified proposal. Do not infer a hardware upgrade from a sourcing request.
2. Update the owning input CSV and supplier evidence. Keep source IDs stable.
   Verify exact model/options, quantity tier, currency, tax, included contents
   and delivery exclusions; catalog leads are not quotes.
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
   records. Every baseline item must belong to exactly one cost module.
6. Run from the repository root:

   ```sh
   python3 .github/skills/bom-documentation/scripts/update_costs.py
   python3 .github/skills/bom-documentation/scripts/update_costs.py --check
   ```

   Generation updates ten Markdown documents from the CSV owners. It refuses
   malformed prices, inconsistent extensions, missing/duplicate item coverage
   and missing generated-region markers. Fix the input; never suppress errors.
7. Review narrative amounts outside generated blocks in all affected scopes,
   source/feedback records and the main BOM. Update current statements or label
   historical figures rather than leaving contradictory costs. Generation
   deliberately does not rewrite engineering claims or supplier evidence.
8. Check changed relative links/anchors and `git diff --check`. Explain changed
   totals, reclassifications and unpriced exposure without claiming qualification.
   For a full BOM link audit, run the standard checker against every engineering
   Markdown file and treat every HTTP 4xx response as a failed link:

   ```sh
   while IFS= read -r file; do
     npx -y markdown-link-check@3.13.7 --quiet "$file" || exit 1
   done < <(find docs/engineering -type f -name '*.md' -print)
   ```

## Generator changes

Follow repository TDD rules before changing executable logic. Run:

```sh
python3 -m unittest discover -s .github/skills/bom-documentation/scripts -p 'test_*.py'
```

The tests cover module links, source-to-summary propagation, preserved totals,
non-additive alternatives, invalid input rejection and non-writing stale checks.
Use temporary copied documents, not live hardware or supplier transactions.
No third-party Python packages are required.

## Synchronization boundary

This is an agent workflow plus local generator, not a file watcher or CI job.
After every BOM edit, execute regeneration and check before handoff. Manual
changes made without running the command can remain stale; never claim otherwise.
Do not add automatic commits, CI writes or deployment as a side effect.
